import 'package:flutter/material.dart';

class Bienvenida extends StatefulWidget {
  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pastillero"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "¡Bienvenido al pastillero!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}