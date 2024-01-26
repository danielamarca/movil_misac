import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Empleado/nuevoEmpleado.dart';

class Empleados extends StatefulWidget {
  @override
  _EmpleadosState createState() => _EmpleadosState();
}

class _EmpleadosState extends State<Empleados> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )),
      body: Center(
        child: const Text('Hola empleado'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).cardColor,
        height: 70,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Spacer(),
            _buildTabItem(
              index: 0,
              icon: Icon(
                Icons.list,
                size: 33,
              ),
              label: 'Lista',
            ),
          ],
        ),
      ),
      floatingActionButton: _buildGradientButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTabItem({
    required int index,
    required Icon icon,
    String? label,
  }) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: icon,
      color: isSelected ? Color.fromARGB(255, 227, 205, 107) : Colors.white,
      onPressed: () => _onItemTapped(index),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildGradientButton() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 231, 193, 39),
                Color.fromARGB(255, 175, 142, 8),
                Color.fromARGB(255, 7, 51, 103),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            _FormularioEmpleado(context);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ],
    );
  }

  void _FormularioEmpleado(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Agregar Empleado'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: Text("adfsa"),
            // body: EquipoForm(onEquipoUpdated: cargarListaEquipos),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
    // ).then((_) => cargarListaEquipos());
  }
}
