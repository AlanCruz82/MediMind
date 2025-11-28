import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contador extends StatefulWidget {
  @override
  _ContadorState createState() => _ContadorState();
}

class _ContadorState extends State<Contador> {
  final emailController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final String docId = 'correoConfig';
  late final DocumentReference correoDocRef;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    correoDocRef = db.collection('correos').doc(docId);
    _cargarCorreoExistente();
  }

  Future<void> _cargarCorreoExistente() async {
    try {
      final DocumentSnapshot doc = await correoDocRef.get();
      if(doc.exists) {
        final String? correoGuardado = (doc.data() as Map<String, dynamic>?)?['email'];
        if(correoGuardado != null) {
          if(mounted) {
            emailController.text = correoGuardado;
          }
        }
      }
    } catch (e) {
      print("Error al cargar el correo: $e");
    }
  }

  void _ActualizarCorreo() async {
    final String nuevoCorreo = emailController.text.trim();
    if(nuevoCorreo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ingresa un correo electrónico."))
      );
      return;
    }
    final bool esCorreoValido = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(nuevoCorreo);

    if(!esCorreoValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ingresa un correo electrónico válido"))
      );
      return;
    }

    try {
      await correoDocRef.set({
        'email': nuevoCorreo,
        'ultimaActualizacion': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Correo electrónico actualizado."))
      );
    } catch (e) {
      print("Error al actualizar correo electrónico: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar correo electrónico"))
      );
    }
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
                margin: EdgeInsets.fromLTRB(70, 40, 70, 4),
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Correo",
                ),
              )
            )
          ),

          Flexible(
            child: Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(110, 16, 110, 4),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      )
                  ),
                  onPressed: _ActualizarCorreo,
                  child: Text(
                    "Cambiar correo",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
            ),
          ),
        ]
      )
    );
  }
}