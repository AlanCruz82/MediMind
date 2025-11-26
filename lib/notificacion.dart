import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medimind/fotografia.dart';
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

  static Future<void> programarNotificacion(int id, String titulo, String cuerpo, DateTime fechaMedicina,
  ) async {
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

    await _notificacion.zonedSchedule(
      10,
      titulo,
      cuerpo,
      tz.TZDateTime.from(fechaMedicina, tz.local),
      detallesNotificacion,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}