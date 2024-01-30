import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Cliente/Elements/Input.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/models/cliente.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:proyecto/provider/servicioClienteProvider.dart';

class ClienteModificar extends StatefulWidget {
  final Cliente cliente;
  final ServicioClienteProvider _servicioClienteProvider;

  // Constructor que recibe un cliente como parámetro
  ClienteModificar(this.cliente, this._servicioClienteProvider);

  @override
  _ClienteModificarState createState() => _ClienteModificarState();
}

class _ClienteModificarState extends State<ClienteModificar> {
  final _nombresController = TextEditingController();
  final _cod_clienteController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Inicializar los controladores con los valores del cliente
    _cod_clienteController.text = widget.cliente.cod_cliente ?? '';
    _nombresController.text = widget.cliente.nombres ?? '';
    _apellidoPaternoController.text = widget.cliente.apellidoPaterno ?? '';
    _apellidoMaternoController.text = widget.cliente.apellidoMaterno ?? '';
    _ciController.text = widget.cliente.ci ?? '';
    _direccionController.text = widget.cliente.direccion ?? '';
    _telefonoController.text = widget.cliente.telefono ?? '';
    _correoController.text = widget.cliente.correo ?? '';
  }

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
              child: Text('Modificar Cliente'),
            )
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    try {
      if (widget.cliente.id == null || widget.cliente.id == '')
        throw new Exception('No tiene ID');

      String url = '${Server().url}/cliente/${widget.cliente.id}';
      print('id:  ${widget.cliente.id}');
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

      final response = await Dio().put(
        url,
        data: json.encode(clienteMap),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      widget._servicioClienteProvider.syncCliente();
      Navigator.of(context).pop();
    } catch (e) {
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
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
                    Navigator.of(context).pop();
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
