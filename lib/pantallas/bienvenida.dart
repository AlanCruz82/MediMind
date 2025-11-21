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
      body: ListView(
        children: [

          //Código para el botón de agregar medicamentos.
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(70, 15, 70, 2),
            child: ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)
                )
              ),
              onPressed: null,
              child: Text(
                "Agregar Medicamento",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ),

          //Aqui debe ir el for que itere de firebase.
          //Código de la tarjeta.
          Container(
            height: 160,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              border: Border.all(
                width: 3,
                color: Colors.red
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,

                    //Texto para el nombre del medicamento.
                    child: Text(
                      "Paracetamol",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    )
                  )
                ),

                //Texto para la dosis del medicamento.
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Dosis: 200mg",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
                ),

                //Código para la fila con texto de Hora del medicamento y botón
                //para ajustar el contenido.
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Hora: 12:00",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                              fixedSize: Size.fromWidth(100),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)
                                )
                            ),
                            onPressed: null,
                            child: Text(
                              "Ajustar",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                      )
                    ]
                  ),
                ),

                //Código para la fila con texto de Hora del medicamento y botón
                //para ajustar el contenido.
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Fecha y Hora",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            fixedSize: Size.fromWidth(100),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                            )
                          ),
                          onPressed: null,
                          child: Text(
                            "Eliminar",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        )
                      )
                    ],
                  )
                )
              ],
            ),
          )
          //Fin del código de la tarjeta.

        ],
      )
    );
  }
}