import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class Bienvenida extends StatefulWidget {
  @override
  _BienvenidaState createState() => _BienvenidaState();
}

//Funcion callback que se ejecuta cuando enciende la alarma
@pragma('vm:entry-point')
void sonarAlarma() {
  print("ALARMA EJECUTADA");
}

class _BienvenidaState extends State<Bienvenida> {

  @override
  void initState() {
    super.initState();
  }

  TextEditingController _nombreMedicamento = TextEditingController();
  int _dosis = 50;
  DateTime _fechaFinMedicamento = DateTime.now();

  //Establecemos la alarma con sus configuraciones
  void establecerAlarma(DateTime fechaMedicamento) async {
    //Id unico en base la fecha-tiempo y milisegundos
    final int id = DateTime.now().millisecondsSinceEpoch;

    await AndroidAlarmManager.oneShotAt(
      fechaMedicamento, //Fecha-tiempo en que se enciende la alarma (retraso aprox 2 min)
      id,
      sonarAlarma, //Funcion callback                     
      exact: true,
      wakeup: true,
      allowWhileIdle: true, //Permite que la alarma suene aunque el Android este en modo Idle
      rescheduleOnReboot: true,
    );

    print("Alarma programada correctamente");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Logica para agregar medicamentos
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.black,
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
                      Text("Fecha Final de Medicación"),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      CupertinoCalendarPickerButton(
                        minimumDateTime: DateTime.now(),
                        maximumDateTime: DateTime(2026, 7, 10),
                        initialDateTime: DateTime.now(),
                        currentDateTime: DateTime.now(),
                        mode: CupertinoCalendarMode.dateTime,
                        timeLabel: 'Final',
                        onDateTimeChanged: (fechaFin) {
                          _fechaFinMedicamento = fechaFin;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Text("Dosis"),
                      //Construimos un Stateful local para poder visualizar el cambio del seleccionador de numero 
                      StatefulBuilder(builder: (BuildContext context, StateSetter setNumberState){
                        return Column(
                        children: [
                          NumberPicker(
                            value: _dosis,
                            minValue: 0,
                            maxValue: 500,
                            step: 5,
                            itemHeight: 50,
                            axis: Axis.horizontal,
                            onChanged: (value) =>
                                setNumberState(() => _dosis = value),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color.fromARGB(66, 155, 141, 141)),
                            ),
                          ),
                          Text('Mg: $_dosis'),
                        ],
                        );
                      }),
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
                        print(_nombreMedicamento.text + " " + _fechaFinMedicamento.toString() + " " + _dosis.toString());
                        establecerAlarma(_fechaFinMedicamento);
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