import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class Notificacion {
  static final _notificacion = FlutterLocalNotificationsPlugin();

  static inicializar(){
    _notificacion.initialize(InitializationSettings(
      android : AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings()
    ));
    tz.initializeTimeZones();
  }

  static notificacionProgramada(String titulo, String cuerpo) async{
    
    var androidDetalles = const AndroidNotificationDetails(
      'important_notificacions', 
      'My Channel',
      importance: Importance.max,
      priority: Priority.high
    );

    var iosDetalles = DarwinNotificationDetails();

    var detallesNotificacion = NotificationDetails(android: androidDetalles, iOS: iosDetalles);

    _notificacion.zonedSchedule(
      0, 
      titulo, 
      cuerpo, 
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)), 
      detallesNotificacion,
      androidScheduleMode:AndroidScheduleMode.exactAllowWhileIdle
    );
  }
}