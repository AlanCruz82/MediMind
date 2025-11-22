import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:numberpicker/numberpicker.dart';

class Bienvenida extends StatefulWidget {
  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {

  @override
  void initState() {
    super.initState();
  }

  TextEditingController _nombreMedicamento = TextEditingController();
  int _currentValue = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Logica para agregar medicamentos
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Agregar medicamento"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _nombreMedicamento,
                        decoration: InputDecoration(
                          labelText : "Medicamento",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Text("Fecha final medicacion"),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      CupertinoCalendarPickerButton(
                        minimumDateTime: DateTime(2024, 7, 10),
                        maximumDateTime: DateTime(2025, 7, 10),
                        initialDateTime: DateTime(2024, 8, 15, 9, 41),
                        currentDateTime: DateTime(2024, 8, 15),
                        mode: CupertinoCalendarMode.dateTime,
                        timeLabel: 'Inicio',
                        onDateTimeChanged: (startdate) {
                          print(startdate);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Text("Dosis"),
                      NumberPicker(
                        value: _currentValue,
                        minValue: 0,
                        maxValue: 100,
                        step: 10,
                        itemHeight: 100,
                        axis: Axis.horizontal,
                        onChanged: (value) =>
                            setState(() => _currentValue = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
              ],
            ),
                  actions: [
                    TextButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Agregar"),
                      onPressed: () {
                        //Logica para establecer la alarma
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
          ),
        ),
      ),
      
      body: ListView(
        children: [
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