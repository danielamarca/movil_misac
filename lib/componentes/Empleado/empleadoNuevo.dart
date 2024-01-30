import 'package:flutter/material.dart';
import 'package:proyecto/componentes/Empleado/Elements/Input.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/models/empleado.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:proyecto/provider/servicioEmpleadoProvider.dart';

class EmpleadoNuevo extends StatefulWidget {
  @override
  _EmpleadoNuevoState createState() => _EmpleadoNuevoState();
}

class _EmpleadoNuevoState extends State<EmpleadoNuevo> {
  late ServicioEmpleadoProvider _ServicioEmpleadoProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ServicioEmpleadoProvider =
        Provider.of<ServicioEmpleadoProvider>(context, listen: false);
  }

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
  List<String> _especialidadTecnico = [
    'INSTALACION',
    'REPARACION',
  ];
  String _selectedEspecialiadTecnico = 'INSTALACION';
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
            CustomTextField(
                controller: _ciController, label: 'Carnet Identidad'),
            CustomTextField(
              controller: _direccionController,
              label: 'Dirección',
              maxLines: 2,
            ),
            CustomTextField(controller: _telefonoController, label: 'Telefono'),
            CustomTextField(controller: _correoController, label: 'Correo'),
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
            if (_selectedRol == 'TECNICO')
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Especialidad',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            if (_selectedRol == 'TECNICO')
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
                  value: _selectedEspecialiadTecnico,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedEspecialiadTecnico = newValue!;
                    });
                  },
                  items: _especialidadTecnico.map((String especialidad) {
                    return DropdownMenuItem<String>(
                      value: especialidad,
                      child: Text(especialidad),
                    );
                  }).toList(),
                  hint: Text('Selecciona un Especialidad'),
                ),
              ),
            CustomTextField(
              controller: _salarioController,
              label: 'Salario',
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            ElevatedButton(
              onPressed: () {
                _submit(context);
              },
              child: Text('Registrar Empleado'),
            )
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    try {
      String url = '${Server().url}/empleado/tecnico';
      double? salario = double.tryParse(_salarioController.text ?? '0');
      Empleado empleado = Empleado(
        id: '',
        rol: _selectedRol ?? '',
        salario: salario,
        nombres: _nombresController.text ?? '',
        apellidoPaterno: _apellidoPaternoController.text ?? '',
        apellidoMaterno: _apellidoMaternoController.text ?? '',
        direccion: _direccionController.text ?? '',
        telefono: _telefonoController.text ?? '',
        ci: _ciController.text ?? '',
        correo: _correoController.text ?? '',
      );
      Map<String, dynamic> empleadoMap = empleado.toMap();
      empleadoMap.remove('nombreCompleto');
      Map<String, dynamic> tecnicoMap = {
        'especialidad': _selectedEspecialiadTecnico,
        'id_empleado': empleadoMap
      };
      final response = await Dio().post(
        url,
        data: json.encode(tecnicoMap),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode != 200) throw Exception('Error de tecnico');
      _ServicioEmpleadoProvider.syncEmpleado();
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
                    Navigator.of(context).pop(); // Cierra el diálogo de error
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
