import 'package:flutter/material.dart';

class Contador extends StatefulWidget {
  @override
  _ContadorState createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          //Código para el botón de editar los ajustes del reporte.
          Flexible(
            child: Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(70, 15, 70, 2),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      )
                  ),
                  onPressed: null,
                  child: Text(
                    "Ajustes del Reporte",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
            ),
          ),

          //Código para el text input que acepta correos.
          Flexible(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 15, 20, 2),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Correo",
                ),
              )
            )
          )
        ]
      )
    );
  }
}