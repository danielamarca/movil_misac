import 'package:flutter/material.dart';
import 'package:proyecto/provider/server.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto/componentes/Equipo/entidades.dart';

class ProveedorService {
  Future<List<Proveedor>> fetchProveedores() async {
    try {
      final response =
          await http.get(Uri.parse('${Server().url}/equipo/proveedor'));
      if (response.statusCode != 200) {
        throw Exception('Error al cargar proveedores');
      }
      Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> data = responseBody['data'];
      return data.map((json) => Proveedor.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al conectar a la API: $e');
    }
  }

  Future<Proveedor> addProveedor(Proveedor proveedor) async {
    final response = await http.post(
      Uri.parse(('${Server().url}/equipo/proveedor')),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'nombre': proveedor.nombre,
        'descripcion': proveedor.descripcion,
        'direccion': proveedor.direccion,
        'contacto': proveedor.contacto,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al añadir proveedor');
    }
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> data = responseBody['data'];
    return Proveedor.fromJson(data);
  }
}

class ProveedorDialog extends StatefulWidget {
  final Function(Proveedor) onProveedorSelected;

  ProveedorDialog({required this.onProveedorSelected});

  @override
  _ProveedorDialogState createState() => _ProveedorDialogState();
}

class _ProveedorDialogState extends State<ProveedorDialog> {
  final ProveedorService _proveedorService = ProveedorService();
  List<Proveedor> _proveedores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarProveedores();
  }

  void _cargarProveedores() async {
    try {
      _proveedores = await _proveedorService.fetchProveedores();
      setState(() => _isLoading = false);
    } catch (e) {
      // Manejar el error adecuadamente aquí
      setState(() => _isLoading = false);
    }
  }

  List<Widget> _buildProveedorDetails(Proveedor proveedor) {
    List<Widget> details = [];

    if (_isNotEmpty(proveedor.descripcion)) {
      details.add(Text("Descripción: ${proveedor.descripcion}",
          style: TextStyle(fontSize: 14)));
    }
    if (_isNotEmpty(proveedor.direccion)) {
      details.add(Text("Dirección: ${proveedor.direccion}",
          style: TextStyle(fontSize: 14)));
    }
    if (_isNotEmpty(proveedor.contacto)) {
      details.add(Text("Contacto: ${proveedor.contacto}",
          style: TextStyle(fontSize: 14)));
    }

    return details;
  }

  bool _isNotEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Seleccionar Proveedor'),
      content: _isLoading
          ? Center(
              child: SizedBox(
                height: 50, // Define un tamaño específico para el cuadrado
                width: 50, // Asegúrate de que el ancho y el alto sean iguales
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: _proveedores.map((proveedor) {
                  List<Widget> proveedorDetails =
                      _buildProveedorDetails(proveedor);

                  return Column(
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            proveedor.nombre,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: proveedorDetails.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: proveedorDetails,
                                )
                              : null,
                          onTap: () {
                            widget.onProveedorSelected(proveedor);
                            FocusScope.of(context)
                                .unfocus(); // Esto ocultará el teclado

                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Divider(thickness: 1),
                    ],
                  );
                }).toList(),
              ),
            ),
      actions: <Widget>[
        TextButton(
          child: Text('Añadir Nuevo Proveedor'),
          onPressed: () => _mostrarFormularioNuevoProveedor(),
        ),
      ],
    );
  }

  void _mostrarFormularioNuevoProveedor() {
    final _nombreController = TextEditingController();
    final _descripcionController = TextEditingController();
    final _direccionController = TextEditingController();
    final _contactoController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir Nuevo Proveedor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(hintText: "Nombre"),
                  textCapitalization:
                      TextCapitalization.characters, // Añadir esto
                ),
                TextField(
                  controller: _direccionController,
                  decoration: InputDecoration(hintText: "Dirección"),
                  textCapitalization:
                      TextCapitalization.characters, // Añadir esto
                ),
                TextField(
                  controller: _contactoController,
                  decoration: InputDecoration(hintText: "Contacto"),
                  textCapitalization:
                      TextCapitalization.characters, // Añadir esto
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(hintText: "Descripción"),
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType
                      .multiline, // Permite el ingreso de texto en varias líneas
                  maxLines: null, // Permite un número ilimitado de líneas
                  minLines: 3, // Establece un mínimo de 2 líneas
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Agregar'),
              onPressed: () async {
                try {
                  Proveedor nuevoProveedor = Proveedor(
                      nombre: _nombreController.text.toUpperCase(),
                      descripcion: _descripcionController.text.toUpperCase(),
                      direccion: _direccionController.text.toUpperCase(),
                      contacto: _contactoController.text.toUpperCase());
                  Proveedor nuevo =
                      await _proveedorService.addProveedor(nuevoProveedor);
                  Navigator.of(context).pop(); // Cierra el formulario
                  widget.onProveedorSelected(nuevo);
                  FocusScope.of(context).unfocus(); // Esto ocultará el teclado
                  Navigator.of(context).pop();
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.red,
                        title: Text('Error'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text(e.toString()),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
