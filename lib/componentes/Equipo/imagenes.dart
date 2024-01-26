import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploadDownloadScreen extends StatefulWidget {
  @override
  _ImageUploadDownloadScreenState createState() =>
      _ImageUploadDownloadScreenState();
}

class _ImageUploadDownloadScreenState extends State<ImageUploadDownloadScreen> {
  File? _image;
  String? _imageURL;
  final ImagePicker _picker = ImagePicker();
  String? _downloadedImageUrl;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
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
      setState(() {
        final urli = jsonMap['url'];
        _imageURL = urli;
        print("URL accedo imagen");
        print(urli);
      });
    }
  }

  Future<void> _downloadImage() async {
    if (_downloadedImageUrl == null) return;

    // Aquí implementa la lógica para descargar la imagen usando _downloadedImageUrl
    // Por ejemplo, puedes actualizar un widget de imagen para mostrar la imagen descargada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subir y Descargar Imagen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Subir Imagen'),
            ),
            ElevatedButton(
              onPressed: _downloadImage,
              child: Text('Descargar Imagen'),
            ),
          ],
        ),
      ),
    );
  }
}
