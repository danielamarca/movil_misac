import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Equipo/proveedor.dart';
import 'package:proyecto/provider/server.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto/componentes/Equipo/entidades.dart';

class CategoriaService {
  Future<List<Categoria>> fetchCategoria() async {
    try {
      final response =
          await http.get(Uri.parse('${Server().url}/equipo/categoria'));
      if (response.statusCode != 200)
        throw Exception('Error al cargar categoria');
      Map<String, dynamic> responseBody = json.decode(response.body);
      List<dynamic> data = responseBody['data'];
      return data.map((json) => Categoria.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error al conectar a la API: $e');
    }
  }

  Future<Categoria> addCategoria(Categoria proveedorData) async {
    try {
      final response = await http.post(
        Uri.parse('${Server().url}/equipo/categoria'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'nombre': proveedorData.nombre,
          'descripcion': proveedorData.descripcion
        }),
      );
      if (response.statusCode == 400) {
        Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['error']['message']);
      }
      if (response.statusCode != 200)
        throw Exception('Error al registrar proveedor');
      Map<String, dynamic> responseBody = json.decode(response.body);
      Map<String, dynamic> data = responseBody['data'];
      return Categoria.fromJson(data);
    } catch (e) {
      throw Exception('Error al conectar a la API: $e');
    }
  }
}

class CategoriaDialog extends StatefulWidget {
  final Function(Categoria) onCategoriaSelected;
  CategoriaDialog({required this.onCategoriaSelected});
  @override
  _CategoriaDialogState createState() => _CategoriaDialogState();
}

class _CategoriaDialogState extends State<CategoriaDialog> {
  final CategoriaService _categoriaService = CategoriaService();
  List<Categoria> _categorias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCategoria();
  }

  void _cargarCategoria() async {
    try {
      _categorias = await _categoriaService.fetchCategoria();
      setState(() => _isLoading = false);
    } catch (e) {
      // Manejar el error adecuadamente aquí
      setState(() => _isLoading = false);
    }
  }

  List<Widget> _buildCategoriaDetails(Categoria categoria) {
    List<Widget> details = [];
    if (_isNotEmpty(categoria.descripcion)) {
      details.add(Text("Descripción: ${categoria.descripcion}",
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
      title: Text('Seleccionar Categoria'),
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
                children: _categorias.map((categoria) {
                  List<Widget> categoriaDetails =
                      _buildCategoriaDetails(categoria);

                  return Column(
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            categoria.nombre,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: categoriaDetails.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: categoriaDetails,
                                )
                              : null,
                          onTap: () {
                            widget.onCategoriaSelected(categoria);
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
          child: Text('Añadir Nueva Categoria'),
          onPressed: () => _mostrarFormularioNuevaCategoria(),
        ),
      ],
    );
  }

  void _mostrarFormularioNuevaCategoria() {
    final _nombreController = TextEditingController();
    final _descripcionController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir Nueva Categoria'),
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
                  controller: _descripcionController,
                  decoration: InputDecoration(hintText: "Descripción"),
                  textCapitalization:
                      TextCapitalization.characters, // Añadir esto
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Agregar'),
              onPressed: () async {
                try {
                  Categoria nuevaCategoria = Categoria(
                      nombre: _nombreController.text.toUpperCase(),
                      descripcion: _descripcionController.text.toUpperCase());
                  Categoria nuevo =
                      await _categoriaService.addCategoria(nuevaCategoria);
                  Navigator.of(context).pop(); // Cierra el formulario
                  widget.onCategoriaSelected(nuevo);
                  FocusScope.of(context).unfocus();
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
