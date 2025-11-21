import 'package:flutter/material.dart';

class Contador extends StatefulWidget {
  @override
  _ContadorState createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reporte"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "¡Reporte medicinal!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}