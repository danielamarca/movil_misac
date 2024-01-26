import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/componentes/Equipo/proveedor.dart';
import 'package:proyecto/componentes/Equipo/categoria.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:proyecto/componentes/Equipo/entidades.dart';

class EquipoService {
  Future<Equipo> addEquipo(Equipo equipo) async {
    final response = await http.post(Uri.parse('${Server().url}/equipo'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'nombre': equipo.nombre,
          'descripcion': equipo.descripcion,
          'precio': equipo.precio,
          'stock': equipo.stock,
          'id_proveedor': equipo.id_proveedor,
          'id_equipo_categoria': equipo.id_equipo_categoria
        }));
    if (response.statusCode != 200) throw Exception('Error al crear Equipo');
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> data = responseBody['data'];
    return Equipo.fromJson(data);
  }
}

class EquipoForm extends StatefulWidget {
  final VoidCallback onEquipoUpdated;
  EquipoForm({Key? key, required this.onEquipoUpdated}) : super(key: key);

  @override
  _EquipoFormState createState() => _EquipoFormState();
}

class _EquipoFormState extends State<EquipoForm> {
  final EquipoService _equipoService = EquipoService();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _precioController = TextEditingController();
  final _stockController = TextEditingController();
  Equipo? _equipo;
  Categoria? _id_equipo_categoria;
  Proveedor? _id_proveedor;
  EquipoFoto? _equipoFoto;
  File? _image;
  String? _imageURL;
  final ImagePicker _picker = ImagePicker();
  // XFile? _imagen;
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
          children: [
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
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
            ListTile(
              title: Text(_id_proveedor?.nombre != null
                  ? 'Proveedor: ${_id_proveedor?.nombre}'
                  : "Seleccione proveedor"),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () => _selectProveedor(context),
            ),
            ListTile(
              title: Text(_id_equipo_categoria?.nombre != null
                  ? 'Categoria: ${_id_equipo_categoria?.nombre}'
                  : 'Selecione Categoria'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: () => _selectCategoria(context),
            ),
            if (_image != null)
              Image.file(
                _image!,
                width: 200, // Ancho fijo
                height: 200, // Alto fijo
                fit: BoxFit
                    .cover, // Esto asegura que la imagen se recorte si es necesario
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Seleccionar Imagen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {_submitForm(context)},
              child: Text('Registrar Producto'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectProveedor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ProveedorDialog(
          onProveedorSelected: (Proveedor proveedor) {
            setState(() {
              _id_proveedor = proveedor;
            });
          },
        );
      },
    );
  }

  void _selectCategoria(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CategoriaDialog(
          onCategoriaSelected: (Categoria categoria) {
            setState(() {
              _id_equipo_categoria = categoria;
            });
          },
        );
      },
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
        textCapitalization: TextCapitalization.characters,
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
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.digitsOnly]
            : null, // Añade esta línea
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

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    print('image');
    print(_image);
    if (_image == null) return '';
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dg9mtscxp/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'olrxmgk6'
      ..files.add(await http.MultipartFile.fromPath('file', _image!.path));
    // Aquí reemplaza con la URL de tu endpoint de subida;
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      return jsonMap['url'];
    }
    return '';
  }

  void _submitForm(BuildContext context) async {
    try {
      await _enviarDatosProducto();
      Navigator.of(context).pop();
    } catch (e) {
      _mostrarErrorDialog(context, e.toString());
    }
  }

  void _mostrarErrorDialog(BuildContext context, String mensajeError) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text('Error al registrar Equipo'),
          content: Text(mensajeError),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de error
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _enviarDatosProducto() async {
    var url = Uri.parse('${Server().url}/equipo');

    double? precio = double.tryParse(_precioController.text);
    int? stock = int.tryParse(_stockController.text);

    var body = json.encode({
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'precio': precio,
      'stock': stock,
      'id_equipo_categoria': _id_equipo_categoria?.id ?? '',
      'id_proveedor': _id_proveedor?.id ?? ''
    });

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"}, body: body);
      if (response.statusCode != 200) {
        throw Exception('Error al añadir nuevo Equipo: ${response.body}');
      }

      Map<String, dynamic> data = json.decode(response.body)['data'];
      Equipo equipo = Equipo.fromJson(data);
      String urlImagen = await _uploadImage();

      var urlImage = Uri.parse('${Server().url}/equipo/equipo_foto');
      var bodyImage = json.encode({
        'id_equipo': equipo.id,
        'archivoUrl': urlImagen,
      });

      final responseImage = await http.post(urlImage,
          headers: {"Content-Type": "application/json"}, body: bodyImage);
      if (responseImage.statusCode != 200) {
        throw Exception(
            'Error al añadir foto del equipo: ${responseImage.body}');
      }
    } catch (e) {
      throw Exception('Error en _enviarDatosProducto: $e');
    }
  }
}
