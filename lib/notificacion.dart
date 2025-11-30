import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medimind/fotografia.dart';
import 'package:medimind/pantallas/bienvenida.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Notificacion {
  static final FlutterLocalNotificationsPlugin _notificacion =
      FlutterLocalNotificationsPlugin();

  //Inicializacion del plugin y el callback de las notificaciones, se inicializa en el main
  static Future<void> inicializar() async {
    await _notificacion.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/cap'),
        iOS: DarwinInitializationSettings(),
      ),
      //Callback de las acciones de la notificacion
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.notificationResponseType == NotificationResponseType.selectedNotificationAction) {
          //Ejecucion en base al id de la accion (Accion_ok o Accion_cancelar)
          switch (notificationResponse.actionId) {
            //En caso de que el usuario haya seleccionado 'Consumir'
            case 'Accion_ok':
              //Abrimos la camara y obtenemos los valores nombre y hora medicamento del JSON
              final String? ruta = await Fotografia.tomarFoto();
              if (ruta != null) {
                //Obtenemos los datos del payload regresandolos a su formato JSON
                Map<String, dynamic> datosPayload = jsonDecode(notificationResponse.payload!);
                await _enviarCorreo(ruta, datosPayload['nombre'], datosPayload['hora']);
              } else {
                print("No se tomó la fotografía. Cancelada por el usuario.");
              }
              break;
            case 'Accion_cancelar':
              print("El usuario presionó Postergar");
              break;
          }
        }
    },
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Mexico_City'));
    await _requestExactAlarmsPermission();
  }

  //Obtenemos la direccion de correo guardada en Firebase y creamos un objeto Email con los detalles generados por el medicamento
  static Future<void> _enviarCorreo(String ruta, String nombreMedicamento, String horaMedicamento) async {
    final db = FirebaseFirestore.instance;
    final DocumentSnapshot correoConfig = await db.collection('correos').doc('correoConfig').get();
    final datos = correoConfig.data()! as Map<String, dynamic>;
    String correoDestino = datos['email'] as String;
    final Email correo = Email(
      body: "Enviamos este correo para notificar que la persona se ha tomado su medicamento $nombreMedicamento a la hora $horaMedicamento.",
      subject: "Reporte de medicamento $nombreMedicamento.",
      recipients: [correoDestino], //Aqui debe de obtener el correo configurado de firebase.
      attachmentPaths: [ruta],
      isHTML: false
    );

    //Enviamos el mensaje en caso de que si se pueda y si no obtenemos la excepcion generada en el catch
    try {
      await FlutterEmailSender.send(correo);
      print("Correo enviado.");
    } catch (error) {
      print("Error al intentar enviar el correo.");
    }
  }

  //Obtenemos el valor del permiso Android para usar alarmas exactas
  static Future<void> _requestExactAlarmsPermission() async {
    final androidPlugin = _notificacion
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final bool? granted = await androidPlugin.requestExactAlarmsPermission();
      print("Permiso SCHEDULE_EXACT_ALARM concedido: $granted");
    }
  }

  //Programamos las notificaciones en base a los detalles del medicamento recibido en el onpressed de 'Agregar' en bienvenida.dart
  static Future<void> programarNotificacion(Medicamento medicamento) async {
    const androidDetalles = AndroidNotificationDetails(
      'important_notificacions',
      'My Channel',
      importance: Importance.max,
      priority: Priority.high,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction('Accion_ok', 'Consumir', showsUserInterface: true),
        AndroidNotificationAction('Accion_cancelar', 'Postergar'),
      ],
    );

    const iosDetalles = DarwinNotificationDetails();

    final detallesNotificacion = NotificationDetails(
      android: androidDetalles,
      iOS: iosDetalles,
    );

    //Datos en formato JSON que se van a enviar como payload en la notificacion
    Map<String, dynamic> datosNotificacion = {
      'nombre': medicamento.nombre,
      'hora': medicamento.fecha_final.hour.toString().padLeft(2, '0') + ':' +
      medicamento.fecha_final.minute.toString().padLeft(2, '0'), 
    };

    //Obtenemos la diferencia de dias que hay entre la fecha en que termina el medicamento e incia
    final int intervaloDias = medicamento.fecha_final.difference(medicamento.fecha_inicial).inDays + 1;

    //Recorremos todos los dias en los que debe llegar la notificacion
    for (int i = 0; i < intervaloDias; i++) {
      //Generemos la nueva fecha en la que va a sonar la notificacion con fecha de hoy y hora,minutos,segundos de la fecha final
      //(fecha final porque es la que contiene la hora del medicamento)
      DateTime nuevaFecha = DateTime(medicamento.fecha_inicial.year, medicamento.fecha_inicial.month,
                          medicamento.fecha_inicial.day + i, medicamento.fecha_final.hour, medicamento.fecha_final.minute,
                          medicamento.fecha_final.second);

      //Si la nueva fecha ya paso hoy, recorremos en un dia la nueva fecha para que se programe manana
      if (nuevaFecha.isBefore(DateTime.now())) {
        nuevaFecha = nuevaFecha.add(Duration(days: 1));
      }
      
      //Programamos la alarma para ese dia, sumandole i al id para que cada una sea unica y no se sobrescriban
      await _notificacion.zonedSchedule(
        medicamento.id + i,
        medicamento.nombre,
        '¡Hora de tu ${medicamento.nombre} ${medicamento.dosis} mg!',
        tz.TZDateTime.from(nuevaFecha, tz.local),
        detallesNotificacion,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: jsonEncode(datosNotificacion) //Convertimos el JSON a String para poder enviarlo en el payload
      );
    }
  }

  //Eliminamos las notificaciones generadas para el medicamento en su intervalo de tiempo de [fecha inicio-fecha final]
  static Future<void> eliminarNotificacion(int idNotificacion, DateTime fechaInicial, DateTime fechaFinal) async {
    //Obtenemos la diferencia de dias que hay entre la fecha en que termina el medicamento e incia
    final int intervaloDias = fechaFinal.difference(fechaInicial).inDays + 1;
    
    //Seguimos la misma logica que al crear la notificacion, usando el contador i como id de la notificacion
    for (int i = 0; i < intervaloDias; i++) {
      //Cancelamos la notificacion de ese medicamento en base a su id con la que fue programada
      await _notificacion.cancel(idNotificacion + i);
    }
  }
}