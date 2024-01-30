import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Cliente/Elements/Input.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/models/cliente.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/servicioClienteProvider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ClienteNuevo extends StatefulWidget {
  @override
  _ClienteNuevoState createState() => _ClienteNuevoState();
}

class _ClienteNuevoState extends State<ClienteNuevo> {
  late ServicioClienteProvider _ServicioClienteProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ServicioClienteProvider =
        Provider.of<ServicioClienteProvider>(context, listen: false);
  }

  final _nombresController = TextEditingController();
  final _cod_clienteController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
                controller: _cod_clienteController, label: 'Codigo Cliente'),
            CustomTextField(controller: _nombresController, label: 'Nombres'),
            CustomTextField(
                controller: _apellidoPaternoController,
                label: 'Apellido Paterno'),
            CustomTextField(
                controller: _apellidoMaternoController,
                label: 'Apellido Materno'),
            CustomTextField(
                controller: _ciController, label: 'Carnet Identidad'),
            CustomTextField(
              controller: _direccionController,
              label: 'Dirección',
              maxLines: 2,
            ),
            CustomTextField(controller: _telefonoController, label: 'Telefono'),
            CustomTextField(controller: _correoController, label: 'Correo'),
            ElevatedButton(
              onPressed: () {
                _submit(context);
              },
              child: Text('Registrar Cliente'),
            )
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    try {
      String url = '${Server().url}/cliente';
      Cliente cliente = Cliente(
        id: '',
        cod_cliente: _cod_clienteController.text ?? '',
        nombres: _nombresController.text ?? '',
        apellidoPaterno: _apellidoPaternoController.text ?? '',
        apellidoMaterno: _apellidoMaternoController.text ?? '',
        direccion: _direccionController.text ?? '',
        telefono: _telefonoController.text ?? '',
        ci: _ciController.text ?? '',
        correo: _correoController.text ?? '',
      );
      Map<String, dynamic> clienteMap = cliente.toMap();
      clienteMap.remove('nombreCompleto');
      final response = await Dio().post(
        url,
        data: json.encode(clienteMap),
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          }, // Especificar el tipo de contenido
        ),
      );
      _ServicioClienteProvider.syncCliente();
      Navigator.of(context).pop();
    } catch (e) {
      // Manejar el error específico para el cliente duplicado
      if (e is DioError &&
          e.response != null &&
          e.response!.statusCode == 409) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error al registrar Cliente'),
              content: Text(
                  'Cliente duplicado. Por favor, verifica la información e intenta nuevamente.'),
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
      } else {
        // Manejar otros errores de manera más general
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error al registrar Cliente'),
              content: Text(
                  'Se produjo un error al intentar registrar al cliente. Por favor, inténtalo nuevamente.'),
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
    }
  }
}
