import 'package:medimind/navegador.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {

  // Widget raíz de la aplicación
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // La primera pantalla en mostrarse es nuestra mainscreen que contiene el bottomnavbar
      home: PantallaPrincipal(), 
    );
  }
}