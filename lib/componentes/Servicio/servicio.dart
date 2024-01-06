import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Servicio extends StatefulWidget {
  @override
  _ServicioState createState() => _ServicioState();
}

class _ServicioState extends State<Servicio> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop())),
      body: Center(child: _buildBodyContent()),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        height: 70,
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            _buildTabItem(index: 1, icon: Icon(Icons.filter_list)),
            Spacer(),
            _buildTabItem(index: 0, icon: Icon(Icons.list)),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return Text("asdf");
      default:
        return Text("a1e");
    }
  }

  Widget _buildTabItem({required int index, required Icon icon}) {
    final isSelected = _selectedIndex == index;
    return IconButton(
        icon: icon,
        color: isSelected ? Color.fromARGB(255, 227, 205, 107) : Colors.white,
        onPressed: () => _onItemTapped(index));
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text('Agregar Producto'),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cierra el diálogo
                          },
                        ),
                      ],
                    ),
                    // body: ProductoForm(), // Tu formulario de producto
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ],
    );
  }
}

// class CrearServicio extends StatefulWidget {
//   @override
//   _CrearServicioState createState() => _CrearServicioState();
// }

// class _CrearServicioState extends State<CrearServicio> {
//   final _nombreController=
// }
