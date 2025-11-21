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
        title: Text(
          "Pastillero",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [

          //Aqui debe ir el for que itere de firebase.
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
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Dosis: 200mg"
                    ),
                  )
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Hora: 12:00"
                    ),
                  ),
                ),
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
                            ),
                          ),
                        )
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
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
        ],
      )
    );
  }
}