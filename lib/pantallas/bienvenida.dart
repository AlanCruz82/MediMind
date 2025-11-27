import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:medimind/notificacion.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medimind/firebase_options.dart';

class Bienvenida extends StatefulWidget {
  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class Medicamento {
  final String nombre;
  final DateTime fInicio;
  final DateTime fFinal;
  final String hora;
  final int dosis;

  Medicamento({
    required this.nombre,
    required this.fInicio,
    required this.fFinal,
    required this.hora,
    required this.dosis,
  });
}

class _BienvenidaState extends State<Bienvenida> {

  @override
  void initState() {
    super.initState();
    _entrada();
  }

  TextEditingController _nombreMedicamento = TextEditingController();
  int _dosis = 50;
  DateTime _fechaFinMedicamento = DateTime.now();
  List<Widget> _tarjetas = [];

  //Establecemos la alarma con sus configuraciones
  void establecerAlarma(DateTime fechaMedicamento) async {
    //Id unico en base la fecha-tiempo y milisegundos
    final int id = DateTime.now().millisecondsSinceEpoch;

    //Programamos la notificacion
    Notificacion.programarNotificacion(id, 'Medicamento', 'Tomate tu medicamento',fechaMedicamento);
  }

  Future<void> _eliminarMedicamento(QueryDocumentSnapshot doc) async {
    try{
      final String ID = doc.id;
      await FirebaseFirestore.instance.collection('medicamentos').doc(ID).delete();
      await _entrada();
      setState(() {});
    } catch (e) {}
  }
  
  Future<void> _guardarMedicinaEnFirestore(Medicamento medicina) async {
    try {
      final datosMedicamento = {
        'nombre-med':medicina.nombre,
        'fecha-inicio':medicina.fInicio.toIso8601String().split('T')[0],
        'fecha-fin':medicina.fFinal.toIso8601String().split('T')[0],
        'hora':medicina.hora,
        'dosis':medicina.dosis,
      };
      
      await FirebaseFirestore.instance.collection('medicamentos').add(datosMedicamento);
      print ('Medicamento guardado con éxito.');
    } catch (e) {
      print ('Medicamento no guardado.');
      throw Error();
    }
  }

  Future<void> _entrada() async {
    final snapshot = await FirebaseFirestore.instance.collection('medicamentos').get();
    _tarjetas = [
      for (var doc in snapshot.docs)
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
                      doc['nombre-med'],
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
                    "Dosis: ${doc['dosis']}",
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
                            "Hora: ${doc['hora']}",
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
                                  borderRadius: BorderRadius.circular(
                                      4)
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
                            "Periodo: ${doc['fecha-inicio']} a ${doc['fecha-fin']}",
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
                                    borderRadius: BorderRadius
                                        .circular(4)
                                )
                            ),
                            onPressed: () {
                              _eliminarMedicamento(doc);
                            },
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
    ];

  }

  @override
    Widget build(BuildContext context) {
    DateTime fecha = DateTime.now();
      return Scaffold(
        //Logica para agregar medicamentos
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.black,
            child: Icon(Icons.add),
            onPressed: () =>
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: Text("Agregar medicamento"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _nombreMedicamento,
                              decoration: InputDecoration(
                                labelText: "Medicamento",
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
                              maximumDateTime: DateTime(fecha.year+2, fecha.month, fecha.day),
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
                            StatefulBuilder(builder: (BuildContext context,
                                StateSetter setNumberState) {
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
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              66, 155, 141, 141)),
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
                            onPressed: () async {
                              final TimeOfDay horaMedi = TimeOfDay.fromDateTime(_fechaFinMedicamento!);
                              final String horaMediFormat = horaMedi.format(context);
                              final nuevoMedicamento = Medicamento(
                                  nombre: _nombreMedicamento.text,
                                  fInicio: DateTime.now(),
                                  fFinal: _fechaFinMedicamento!,
                                  hora: horaMediFormat,
                                  dosis: _dosis
                              );
                              //Logica para establecer la alarma
                              print(_nombreMedicamento.text + " " + _fechaFinMedicamento.toString() + " " + _dosis.toString());
                              establecerAlarma(_fechaFinMedicamento);
                              await _guardarMedicinaEnFirestore(nuevoMedicamento);
                              await _entrada();
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                ),
          ),

          body: ListView(
            children: _tarjetas,
          )
      );
    }
}