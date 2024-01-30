import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Cliente/Elements/bottomNavigator.dart';
import 'package:proyecto/componentes/Servicio/servicioNuevo.dart';
import 'package:proyecto/componentes/Servicio/servicioLista.dart';

class ServicioView extends StatefulWidget {
  @override
  _ServicioViewState createState() => _ServicioViewState();
}

class _ServicioViewState extends State<ServicioView> {
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
          title: const Text('Servicios')),
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
          _FormularioNuevoServicio(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ListaServicio();
      default:
        return Text('Vacio...!!');
    }
  }

  void _FormularioNuevoServicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Agregar Servicio'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: ServicioNuevo(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }
}
