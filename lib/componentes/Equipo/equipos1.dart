import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/server.dart';
// import 'package:proyecto/componentes/Equipo/crud.dart';
import 'package:proyecto/componentes/Equipo/nuevoEquipo.dart';
import 'package:image_picker/image_picker.dart'; // Añade esta línea para el selector de imágenes
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto/models/producto.dart';
import 'package:proyecto/provider/servicioEquipoProvider.dart';

class Equipos extends StatefulWidget {
  @override
  _EquipoState createState() => _EquipoState();
}

class _EquipoState extends State<Equipos> {
  final GlobalKey<_ListaEquiposState> listaEquiposKey = GlobalKey();

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late ListaEquipos _listaEquipos;
  late ServicioEquipoProvider _ServicioEquipoProvider; // Agregado

  // @override
  // void initState() {
  //   super.initState();
  //   _listaEquipos = ListaEquipos(onListaRecargada: _cargarListaEquipos);
  //   _cargarListaEquipos(); // Cargar equipos al iniciar
  // }
  @override
  void initState() {
    // _ServicioEquipoProvider =
    //     Provider.of<ServicioEquipoProvider>(context, listen: false);
    _listaEquipos = ListaEquipos(onListaRecargada: _cargarListaEquipos);
    super.initState();
    // _ServicioEquipoProvider =
    //     Provider.of<ServicioEquipoProvider>(context, listen: false); // Agregado
    // _listaEquipos =
    //     ListaEquipos(onListaRecargada: _cargarListaEquipos); // Cambiado
    // _cargarListaEquipos(); // Cargar equipos al iniciar
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Accede al proveedor en didChangeDependencies
  //   _ServicioEquipoProvider = Provider.of<ServicioEquipoProvider>(context, listen: false);
  //   _listaEquipos = ListaEquipos(onListaRecargada: _cargarListaEquipos);
  //   _cargarListaEquipos();
  // }

  // void _cargarListaEquipos() async {
  //   var url = Uri.parse('${Server().url}/equipo');
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body)['data'];
  //     listaEquiposKey.currentState
  //         ?.updateEquipos(data.map((json) => Equipo.fromJson(json)).toList());
  //   } else {
  //     // Manejo de error
  //   }
  // }
  void _cargarListaEquipos() async {
    // try {
    //   await _ServicioEquipoProvider.fetchAndSaveData();
    //   listaEquiposKey.currentState?.updateEquipos(_ServicioEquipoProvider.equipos);
    // } catch (error) {
    //   // Manejo de error
    //   print('Error al cargar equipos: $error');
    // }
  }

  @override
  Widget build(BuildContext context) {
    // _ServicioEquipoProvider =
    //     Provider.of<ServicioEquipoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: _buildBodyContent(),
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

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ListaEquipos(
            key: listaEquiposKey, onListaRecargada: _cargarListaEquipos);
      case 1:
        return Text('Negocios');
      default:
        return ListaEquipos(
            key: listaEquiposKey, onListaRecargada: _cargarListaEquipos);
    }
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
            _FormularioProducto(context);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ],
    );
  }

  void _FormularioProducto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Agregar Equipo'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: EquipoForm(onEquipoUpdated: _cargarListaEquipos),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    ).then((_) => _cargarListaEquipos());
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
}

class ListaEquipos extends StatefulWidget {
  final VoidCallback onListaRecargada;
  ListaEquipos({Key? key, required this.onListaRecargada}) : super(key: key);

  @override
  _ListaEquiposState createState() => _ListaEquiposState();
}

class _ListaEquiposState extends State<ListaEquipos> {
  late List<Equipo> _equipos = [];
  late List<Equipo> _equiposFiltrados = [];
  late ServicioEquipoProvider _ServicioEquipoProvider; // Agregado

  void updateEquipos(List<Equipo> nuevosEquipos) {
    setState(() {
      _equipos.clear();
      _equipos.addAll(nuevosEquipos);
    });
  }

  @override
  void initState() {
    super.initState();
    _ServicioEquipoProvider =
        Provider.of<ServicioEquipoProvider>(context, listen: false);
    _ServicioEquipoProvider.localEquipo();
    setState(() {
      _equipos = _ServicioEquipoProvider.equipos;
      _equiposFiltrados = _equipos;
      print('Equipos: $_equipos');
    });

    // _cargarEquipos();
  }

  @override
  void dispose() {
    widget.onListaRecargada();
    super.dispose();
  }

  Future<void> _borrarEquipo(String id) async {
    var url = Uri.parse('${Server().url}/equipo/' + id);
    print('url: ${url}');
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      // _cargarEquipos();
    } else {
      print('error al cargar equipos');
    }
  }

  void _filtrarEquipos(String query) {
    setState(() {
      if (query.isEmpty) {
        _equiposFiltrados = _equipos;
      } else {
        _equiposFiltrados = _equipos.where((equipo) {
          return equipo.nombre.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _ServicioEquipoProvider =
        Provider.of<ServicioEquipoProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filtrarEquipos,
              decoration: InputDecoration(
                labelText: 'Buscar Equipo',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _equiposFiltrados.length,
              itemBuilder: (context, index) {
                Equipo equipo = _equiposFiltrados[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DetallesEquipo(equipo: equipo),
                        ),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(equipo.nombre),
                          subtitle: Text(
                              ' ${equipo.precio} Bs. , descripcion: ${equipo.descripcion}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // Lógica para editar
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Lógica para eliminar
                                  print('id: ${equipo}');
                                  _borrarEquipo(equipo.id ?? '');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetallesEquipo extends StatelessWidget {
  final Equipo equipo;

  DetallesEquipo({required this.equipo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipo.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // if (equipo.equipoFoto != null &&
            //     equipo.equipoFoto!.archivoUrl != null)
            //   Center(
            //     child: Container(
            //       width: 300, // Ancho de la imagen
            //       height: 300, // Alto de la imagen
            //       margin: EdgeInsets.only(top: 16.0), // Margen superior
            //       decoration: BoxDecoration(
            //         // Aquí añades el borde redondeado al contenedor
            //         borderRadius:
            //             BorderRadius.circular(20.0), // Ajusta el radio aquí
            //       ),
            //       clipBehavior: Clip.hardEdge,
            //       child: Image.network(
            //         equipo.equipoFoto!.archivoUrl ?? '',
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24.0, top: 8.0, right: 16.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Descripción: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                            text: '${equipo.descripcion ?? 'No disponible'}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Precio: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                            text: '${equipo.precio ?? 'No disponible'}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Stock: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                            text: '${equipo.stock ?? 'No disponible'}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Proveedor: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        // TextSpan(
                        //     text:
                        //         ' ${equipo.proveedors?.nombre ?? 'No disponible'}',
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.yellow)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Categoria: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        // TextSpan(
                        //     text:
                        //         ' ${equipo.equipoCategorias?.nombre ?? 'No disponible'}',
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.yellow)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Imagen URL: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        // TextSpan(
                        //     text:
                        //         ' ${equipo.equipoFoto?.archivoUrl ?? 'No disponible'}',
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.yellow)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  // Repite este patrón para los demás campos
                  // ...
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
