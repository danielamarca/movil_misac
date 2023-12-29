import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/componentes/Equipo/crud.dart';
import 'package:image_picker/image_picker.dart'; // Añade esta línea para el selector de imágenes
import 'package:http/http.dart' as http;
import 'dart:convert';


class Equipos extends StatefulWidget {
  @override
  _EquipoState createState() => _EquipoState();
}

class _EquipoState extends State<Equipos> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
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
        color: Theme.of(context).primaryColor,
        height: 70,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabItem(
              index: 0,
              icon: Icon(
                Icons.home,
                size: 33,
              ),
              label: 'Inicio',
            ),
            Spacer(),
            _buildTabItem(
              index: 1,
              icon: Icon(
                Icons.business,
                size: 33,
              ),
              label: 'Negocios',
            ),
            Spacer(),
            Spacer(),
            Spacer(),
            _buildTabItem(
              index: 2,
              icon: Icon(
                Icons.school,
                size: 33,
              ),
              label: 'Escuela',
            ),
            Spacer(),
            _buildTabItem(
              index: 3,
              icon: Icon(
                Icons.listen,
                size: 33,
              ),
              label: 'Perfil',
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
        return ListaEquipos();
      case 1:
        return Text('Negocios');
      case 2:
        return Text('Escuela');
      case 3:
        return Text('Perfil');
      case 4:
        return ProductoForm();
      default:
        return ListaEquipos();
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
            body: ProductoForm(),  // Tu formulario de producto
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



class ProductoForm extends StatefulWidget {
  @override
  _ProductoFormState createState() => _ProductoFormState();
}

class _ProductoFormState extends State<ProductoForm> {
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  String? _categoriaSeleccionada;
  XFile? _imagen;

  // Lista de categorías disponibles
  final List<String> _categorias = [
    'Electrónica',
    'Ropa',
    'Alimentos',
    'Libros',
    'Juguetes',
    // Añade más categorías según sea necesario
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField(
              controller: _nombreController,
              label: 'Nombre',
              keyboardType: TextInputType.text,
            ),
            _buildTextField(
              controller: _descripcionController,
              label: 'Descripción',
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            _buildDecoratedTextField(
              controller: _precioController,
              label: 'Precio',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildDecoratedTextField(
                    controller: _stockController,
                    label: 'Stock',
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _incrementStock(),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => _decrementStock(),
                ),
              ],
            ),
            // Selector de categoría
            DropdownButton<String>(
              value: _categoriaSeleccionada,
              hint: Text('Elige una categoría'),
              onChanged: (String? newValue) {
                setState(() {
                  _categoriaSeleccionada = newValue;
                });
              },
              items: _categorias.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Botón para seleccionar imagen
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleccionar imagen'),
            ),
            // Vista previa de la imagen seleccionada
            if (_imagen != null) Image.file(File(_imagen!.path)),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Registrar Producto'),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDecoratedTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  void _incrementStock() {
    int currentValue = int.tryParse(_stockController.text) ?? 0;
    _stockController.text = (currentValue + 1).toString();
  }

  void _decrementStock() {
    int currentValue = int.tryParse(_stockController.text) ?? 0;
    currentValue = currentValue > 0 ? currentValue - 1 : 0;
    _stockController.text = currentValue.toString();
  }
  // Resto del código de los widgets permanece igual...

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagen = image;
    });
  }







  void _submitForm() async {
    // Imprimir los datos del formulario en la consola (opcional)
    print('Nombre: ${_nombreController.text}');
    print('Descripción: ${_descripcionController.text}');
    print('Precio: ${_precioController.text}');
    print('Stock: ${_stockController.text}');
    print('Categoría: $_categoriaSeleccionada');
    if (_imagen != null) {
      print('Ruta de imagen: ${_imagen!.path}');
    }

    // Realizar la petición HTTP
    var response = await _enviarDatosProducto();
    if (response == 0) {
      // Éxito
      print('Producto registrado con éxito');
    } else {
      // Error
      print('Error al registrar el producto');
    }
  }

  Future<int> _enviarDatosProducto() async {

    var url = Uri.parse('http://192.168.1.22:3000/equipo'); // Reemplaza con la URL de tu API
    var headers = {"Content-Type": "application/json"};
    double? precio = double.tryParse(_precioController.text);
    int? stock = int.tryParse(_stockController.text);
    var body = json.encode({
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'precio': precio,
      'stock': stock,
      // 'categoria': _categoriaSeleccionada,
      // 'imagen': Aquí podrías añadir la imagen si tu API lo soporta
    });
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // Tratar la respuesta de la API aquí
        return 0; // Éxito
      } else {
        // Manejar otros códigos de estado HTTP
        return 1; // Error
      }
    } catch (e) {
      // Manejar excepciones de red, etc.
      print('Error de conexión: ${e.toString()}');
      return 2; // Error de conexión
    }
  }
}















class Equipo {
  final String? id;
  final String nombre;
  final String? descripcion;
  final double? precio;
  final int? stock;
  final String? imageUrl;

  Equipo({
    required this.nombre,
    this.id,
    this.descripcion,
    this.precio,
    this.stock,
    this.imageUrl,
  });

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json["id"]??'',
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? 'sin descripción',
      precio: json['precio'] != null ? json['precio'].toDouble() : null,
      stock: json['stock'],
      imageUrl: json['imageUrl'], // Asume que esto viene del JSON
    );
  }
}

class ListaEquipos extends StatefulWidget {
  @override
  _ListaEquiposState createState() => _ListaEquiposState();
}

class _ListaEquiposState extends State<ListaEquipos> {
  late List<Equipo> _equipos = [];
  late List<Equipo> _equiposFiltrados = [];

  @override
  void initState() {
    super.initState();
    _cargarEquipos();
  }

  Future<void> _cargarEquipos() async {
    var url = Uri.parse('http://192.168.1.22:3000/equipo');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> equiposJson = json.decode(response.body);
      setState(() {
        _equipos = equiposJson.map((json) => Equipo.fromJson(json)).toList();
        _equiposFiltrados = _equipos;
      });
    } else {
      print('error al cargar equipos');
      // Manejar error
    }
  }
  Future<void> _borrarEquipo(String id) async {
    var url = Uri.parse('http://192.168.1.22:3000/equipo/'+id);
    print('url: ${url}');
    var response = await http.delete(url);
    if (response.statusCode == 200) {
          _cargarEquipos();
    } else {
      print('error al cargar equipos');
      // Manejar error
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Equipos'),
      ),
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
                      if (equipo.imageUrl != null && equipo.imageUrl!.isNotEmpty)
                        Image.network(
                          equipo.imageUrl!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        ListTile(
                          title: Text(equipo.nombre),
                          subtitle: Text(
                              '${equipo.id} ${equipo.descripcion} - \$${equipo.precio}'),
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
                                  _borrarEquipo(equipo.id??'');
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
          children: <Widget>[
            equipo.imageUrl != null && equipo.imageUrl!.isNotEmpty
                ? Image.network(
                    equipo.imageUrl!,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/imagen_por_defecto.jpg', // Imagen por defecto
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Descripción: ${equipo.descripcion ?? 'No disponible'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Precio: \$${equipo.precio ?? 'No disponible'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Stock: ${equipo.stock ?? 'No disponible'}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
