import 'package:flutter/material.dart';
import 'pantallas/bienvenida.dart';
import 'pantallas/contador.dart';

class PantallaPrincipal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {

  int _indiceActual = 0;  // Indice inicial
  late List<Widget> _pantallas; //Lista de widgets que almacenan nuestras pantallas utilizadas

  @override
  void initState() {
    super.initState();

    //Inicalizamos el estado de cada pantalla, pasandole la funcion para cambiar de pantalla a la pantalla del login
    _pantallas = [
      Bienvenida(),
      Contador(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indiceActual],  // Cargar la pantalla correspondiente al indice
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //Propiedad para evitar que se quede en blanco después de 3 pantallas/items
        currentIndex: _indiceActual,  // El índice actual para cambiar la pantalla
        onTap: (index) { // Cuando el usuario toca un icono cambiamos el indice
          setState(() { // Actualizamos el estado para mostrar la pantalla
            _indiceActual = index;  // Cambiar el índice al hacer clic en un ítem
          });
        },
        items: [ // botones de la app con los cuales vamos a navegar entre pantallas
          BottomNavigationBarItem(icon: Icon(Icons.medical_information), label: "Pastillero"),
          BottomNavigationBarItem(icon: Icon(Icons.text_snippet), label: "Reporte")
        ],
      ),
    );
  }
}