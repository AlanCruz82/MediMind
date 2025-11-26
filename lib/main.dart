import 'package:flutter/material.dart';
import 'package:medimind/notificacion.dart';
import 'app.dart'; // Raíz del proyecto

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Notificacion.inicializar();
  runApp(MyApp());
}