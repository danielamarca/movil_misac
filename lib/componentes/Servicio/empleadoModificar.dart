import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Empleado/Elements/Input.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/models/empleado.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:proyecto/provider/servicioEmpleadoProvider.dart';

class EmpleadoModificar extends StatefulWidget {
  final Empleado empleado;
  final ServicioEmpleadoProvider _servicioEmpleadoProvider;

  // Constructor que recibe un empleado como parámetro
  EmpleadoModificar(this.empleado, this._servicioEmpleadoProvider);

  @override
  _EmpleadoModificarState createState() => _EmpleadoModificarState();
}

class _EmpleadoModificarState extends State<EmpleadoModificar> {
  final _nombresController = TextEditingController();
  final _salarioController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _ciController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();
  List<String> _roles = [
    'TECNICO',
    'GERENTE',
    'AUXILIAR GERENTE',
    'VENTAS',
    'LOGISTICA',
  ];
  String _selectedRol = 'TECNICO';
  @override
  void initState() {
    super.initState();

    // Inicializar los controladores con los valores del empleado
    _salarioController.text = widget.empleado.salario.toString() ?? '0';
    _nombresController.text = widget.empleado.nombres ?? '';
    _selectedRol = widget.empleado.rol ?? '';
    _apellidoPaternoController.text = widget.empleado.apellidoPaterno ?? '';
    _apellidoMaternoController.text = widget.empleado.apellidoMaterno ?? '';
    _ciController.text = widget.empleado.ci ?? '';
    _direccionController.text = widget.empleado.direccion ?? '';
    _telefonoController.text = widget.empleado.telefono ?? '';
    _correoController.text = widget.empleado.correo ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(controller: _nombresController, label: 'Nombres'),
            CustomTextField(
                controller: _apellidoPaternoController,
                label: 'Apellido Paterno'),
            CustomTextField(
                controller: _apellidoMaternoController,
                label: 'Apellido Materno'),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Rol',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: DropdownButton<String>(
                value: _selectedRol,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRol = newValue!;
                  });
                },
                items: _roles.map((String rol) {
                  return DropdownMenuItem<String>(
                    value: rol,
                    child: Text(rol),
                  );
                }).toList(),
                hint: Text('Selecciona un Rol'),
              ),
            ),
            CustomTextField(
                controller: _ciController, label: 'Carnet Identidad'),
            CustomTextField(
              controller: _direccionController,
              label: 'Dirección',
              maxLines: 2,
            ),
            CustomTextField(controller: _telefonoController, label: 'Telefono'),
            CustomTextField(controller: _correoController, label: 'Correo'),
            CustomTextField(controller: _salarioController, label: 'Salario'),
            ElevatedButton(
              onPressed: () {
                _submit(context);
              },
              child: Text('Modificar Empleado'),
            )
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    try {
      if (widget.empleado.id == null || widget.empleado.id == '')
        throw new Exception('No tiene ID');

      String url = '${Server().url}/empleado/${widget.empleado.id}';
      print('id:  ${widget.empleado.id}');
      double? salario = double.tryParse(_salarioController.text ?? '0');
      Empleado empleado = Empleado(
        id: '',
        salario: salario,
        nombres: _nombresController.text ?? '',
        apellidoPaterno: _apellidoPaternoController.text ?? '',
        apellidoMaterno: _apellidoMaternoController.text ?? '',
        rol: _selectedRol ?? '',
        direccion: _direccionController.text ?? '',
        telefono: _telefonoController.text ?? '',
        ci: _ciController.text ?? '',
        correo: _correoController.text ?? '',
      );

      Map<String, dynamic> empleadoMap = empleado.toMap();
      empleadoMap.remove('nombreCompleto');

      final response = await Dio().put(
        url,
        data: json.encode(empleadoMap),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      widget._servicioEmpleadoProvider.syncEmpleado();
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
              title: Text('Error al registrar Empleado'),
              content: Text(
                  'Empleado duplicado. Por favor, verifica la información e intenta nuevamente.'),
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
              title: Text('Error al registrar Empleado'),
              content: Text(
                  'Se produjo un error al intentar registrar al empleado. Por favor, inténtalo nuevamente.'),
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
