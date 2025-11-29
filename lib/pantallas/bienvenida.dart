import 'package:flutter/material.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:medimind/notificacion.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bienvenida extends StatefulWidget {
  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class Medicamento {
  final int id;
  final String nombre;
  final DateTime fecha_inicial;
  final DateTime fecha_final;
  final int dosis;

  Medicamento({
    required this.id,
    required this.nombre,
    required this.fecha_inicial,
    required this.fecha_final,
    required this.dosis,
  });
}

class _BienvenidaState extends State<Bienvenida> {

  @override
  void initState() {
    super.initState();
    _obtenerMedicamento();
  }

  final db = FirebaseFirestore.instance;
  TextEditingController _nombreMedicamento = TextEditingController();
  int _dosis = 50;
  DateTime _fechaFinMedicamento = DateTime.now();
  DateTime _fechaInicioMedicamento = DateTime.now();
  List<Widget> _tarjetas = [];
  String idMedTemporal = "";

  //Establecemos la alarma con sus configuraciones
  void establecerAlarma(Medicamento medicamento) async {
    //Programamos la notificacion
    Notificacion.programarNotificacion(medicamento);
  }

  //Metodo para guardar los datos de la cita en firebase con los valores del usuario
  void guardarMedicamento(Medicamento medicamento) async{
    Map<String,dynamic> detallesMedicamento = {
      'nombre' : medicamento.nombre,
      'fecha_inicio' : medicamento.fecha_inicial,
      'fecha_final' : medicamento.fecha_final,
      'dosis' : medicamento.dosis
    };
    //Guardamos el medicamento en la coleccion de medicamentos con id de su fecha final en milisegundos
    await db.collection("Medicamentos").doc(medicamento.id.toString()).set(detallesMedicamento);
  }

  void _modificarMedicamento(QueryDocumentSnapshot doc) async {
    //Obtenemos el id del medicamento que se quiere modificar
    String docId = doc.id;
    final datos = doc.data() as Map<String, dynamic>;
    if (datos.containsKey('fecha_final') && datos['fecha_final'] is Timestamp) {
      _fechaFinMedicamento = (datos['fecha_final'] as Timestamp).toDate();
      print("Fecha encontrada: $_fechaFinMedicamento");
    } else {
      print("No hay objeto, pongo el tiempo de ahora");
      _fechaFinMedicamento = DateTime.now();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Editar medicamento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Fecha Final de Medicación"),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              CupertinoCalendarPickerButton(
                minimumDateTime: _fechaFinMedicamento,
                maximumDateTime: DateTime(2026, 7, 10),
                initialDateTime: _fechaFinMedicamento,
                currentDateTime: _fechaInicioMedicamento,
                mode: CupertinoCalendarMode.dateTime,
                timeLabel: 'Final',
                onDateTimeChanged: (fechaFin) {
                  _fechaFinMedicamento = fechaFin;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                //Limpiamos
                _nombreMedicamento.text = "";
                _fechaFinMedicamento = DateTime.now();
                _dosis = 50;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Agregar"),
              onPressed: () {
                //Guardo lo que hay ahora en el dialog excepto el id
                Map<String, dynamic> datosNuevos = {
                  'fechaInicio': Timestamp.fromDate(_fechaInicioMedicamento)
                };
                db.collection("Medicamentos").doc(docId).update(datosNuevos);
                //Limpiamos los campos de los detalles del medicamento
                _fechaFinMedicamento = DateTime.now();
                setState(() {

                });
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  void _eliminarMedicamento(QueryDocumentSnapshot doc) async {
    //Obtenemos el id del medicamento que se quiere eliminar
    String docId = doc.id;

    await db.collection("Medicamentos").doc(docId).delete();
    _obtenerMedicamento();
  }

  //Obtenemos la hora del Timstamp para mostrarla en formato HH:MM
  String _obtenerHora(Timestamp timestamp) {
    DateTime fecha = timestamp.toDate();
    String hora = fecha.hour.toString().padLeft(2, '0');
    String minutos = fecha.minute.toString().padLeft(2, '0');
    return "$hora:$minutos";
  } 

  //Obtenemos la fecha del Timestamp guardado en firebase
  String obtenerFecha(DateTime fecha) {
    final d = fecha.day.toString().padLeft(2, '0');
    final m = fecha.month.toString().padLeft(2, '0');
    final y = fecha.year.toString();
    return "$d/$m/$y";
  } 

  //Obtenemos los medicamentos almacenados en firebase y los construimos en una tarjeta
  Future<void> _obtenerMedicamento() async {
    final snapshot = await FirebaseFirestore.instance.collection('Medicamentos').get();
    _tarjetas = [
      for (var doc in snapshot.docs)
      //Código de la tarjeta.
      Container(
        height: 200,
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
                      doc['nombre'],
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
            Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Dosis: ${doc['dosis']} mg",
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
                            "Hora: ${_obtenerHora(doc['fecha_final'] as Timestamp)}",
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
                              fixedSize: Size.fromWidth(104),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      4)
                              )
                          ),
                          onPressed: () {
                            _modificarMedicamento(doc);
                          },
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

            //Código para la fila con texto de intervalo de fechas y botón
            //para eliminar el contenido/la tarjeta.
            Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Tomar desde ${obtenerFecha(doc['fecha_inicio'].toDate())} hasta ${obtenerFecha(doc['fecha_final'].toDate())}",
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
                                fixedSize: Size.fromWidth(104),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius
                                        .circular(4)
                                )
                            ),
                            onPressed: () {
                              //Eliminamos las notificaciones del medicamento en base a su id y el rango de la fecha final y de inicio
                              //Convertimos los valores del documento de String a int y de Timestamp a Datetime
                              Notificacion.eliminarNotificacion(int.parse(doc.id), doc['fecha_inicio'].toDate(), doc['fecha_final'].toDate());
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
    //Refrescamos el estado del interfaz para mostrar los medicamentos obtenidos
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Encabezado de la pantalla
      appBar: AppBar(
        title: Text('¡Bienvenido(a) a tu pastillero!'),
        centerTitle: true,
      ),
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
                          labelText : "Nombre del Medicamento",
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
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            value: _dosis,
                            minValue: 0,
                            maxValue: 500,
                            step: 5,
                            itemHeight: 70,
                            itemWidth: 70,
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
                        _nombreMedicamento.text = "";
                        _fechaFinMedicamento = DateTime.now();
                        _dosis = 50;
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Agregar"),
                      onPressed: () {
                        //Basamos el id en la acumulacion de milisegundos que han pasado desde la epoca Epoch 1/1/1970
                        //hasta la fechahora actual, generando un id unico para cada medicamento
                        int id = _fechaInicioMedicamento.millisecondsSinceEpoch ~/ 10000;
                        //Construimos el objeto tipo Medicamento que vamos a almacenar y usar para las notificaciones
                        final med = Medicamento(
                          id: id,
                          nombre: _nombreMedicamento.text,
                          fecha_inicial: _fechaInicioMedicamento,
                          fecha_final: _fechaFinMedicamento,
                          dosis: _dosis
                        );
                        print("Print");
                        print(med);
                        if(med.nombre.isNotEmpty){
                          //Almacenamos el medicamento en firebase
                          guardarMedicamento(med);
                          establecerAlarma(med);
                          //Obtenemos los medicamentos guardados en Firebase para refrescar las tarjetas de la pantalla
                          _obtenerMedicamento();
                          //Limpiamos los campos de los detalles del medicamento
                          _nombreMedicamento.text = "";
                          _fechaFinMedicamento = DateTime.now();
                          _dosis = 50;
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Ingresa el nombre del medicamento."))
                          );
                        }
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