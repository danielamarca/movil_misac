import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Cliente/Elements/bottomNavigator.dart';
import 'package:proyecto/componentes/Cliente/ClienteNuevo.dart';
import 'package:proyecto/componentes/Cliente/ClienteLista.dart';

class ClientesView extends StatefulWidget {
  @override
  _ClienteViewState createState() => _ClienteViewState();
}

class _ClienteViewState extends State<ClientesView> {
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
          title: const Text('Cliente')),
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
          _FormularioServicio(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ListaCliente();
      default:
        return Text('Vacio...!!');
    }
  }

  void _FormularioServicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Agregar Cliente'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: ClienteNuevo(),
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
