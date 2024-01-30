import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Cliente/Elements/bottomNavigator.dart';
import 'package:proyecto/componentes/Empleado/empleadoNuevo.dart';
import 'package:proyecto/componentes/Empleado/empleadoLista.dart';

class EmpleadoView extends StatefulWidget {
  @override
  _EmpleadoViewState createState() => _EmpleadoViewState();
}

class _EmpleadoViewState extends State<EmpleadoView> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavItem> navItems = [
      BottomNavItem(
        icon: Icon(Icons.list, size: 33),
        label: 'Lista',
      ),
    ];
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Empleados')),
      body: Center(
        child: _buildBodyContent(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        navItems: navItems,
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          _FormularioNuevoEmpleado(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ListaEmpleado();
      default:
        return Text('Vacio...!!');
    }
  }

  void _FormularioNuevoEmpleado(BuildContext context) {
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
            body: EmpleadoNuevo(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    ).then((_) => _cargarListaClientes());
  }

  void _cargarListaClientes() {}
}
