import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medimind/fotografia.dart';
import 'package:medimind/pantallas/bienvenida.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class Notificacion {
  static final FlutterLocalNotificationsPlugin _notificacion =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    await _notificacion.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      //Callback de las acciones de la notificacion
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.notificationResponseType == NotificationResponseType.selectedNotificationAction) {
          //Ejecucion en base al id de la accion (Accion_ok o Accion_cancelar)
          switch (notificationResponse.actionId) {
            case 'Accion_ok':
              print(await Fotografia.tomarFoto());
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

  static Future<void> _requestExactAlarmsPermission() async {
    final androidPlugin = _notificacion
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final bool? granted = await androidPlugin.requestExactAlarmsPermission();
      print("Permiso SCHEDULE_EXACT_ALARM concedido: $granted");
    }
  }

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

    //Obtenemos la diferencia de dias que hay entre la fecha en que termina el medicamento e incia
    final int intervaloDias = medicamento.fecha_final.difference(medicamento.fecha_inicial).inDays + 1;

    //Recorremos todos los dias en los que debe llegar la notificacion
    for (int i = 0; i < intervaloDias; i++) {
      //Generemos la nueva fecha en la que va a sonar la notificacion con fecha de hoy y hora,minutos,segundos de la fecha final
      //(fecha final porque es la que contiene la hora del medicamento)
      DateTime nuevaFecha = DateTime(medicamento.fecha_inicial.year, medicamento.fecha_inicial.month,
                          medicamento.fecha_inicial.day, medicamento.fecha_final.hour, medicamento.fecha_final.minute,
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
      );
    }
  }

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