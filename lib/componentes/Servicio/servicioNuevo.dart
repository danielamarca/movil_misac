import 'package:flutter/material.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/models/servicio.dart';
import 'package:proyecto/models/cliente.dart';
import 'package:proyecto/models/empleado.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:proyecto/componentes/Servicio/servicioTipo.dart';
import 'package:proyecto/componentes/Servicio/Cliente/servicioCliente.dart';
import 'package:proyecto/componentes/Servicio/Tecnico/servicioTecnico.dart';
import 'package:proyecto/provider/servicioEmpleadoProvider.dart';

import 'package:proyecto/provider/servicioServicioProvider.dart';
import 'package:proyecto/provider/servicioClienteProvider.dart';

class ServicioNuevo extends StatefulWidget {
  @override
  _ServicioNuevoState createState() => _ServicioNuevoState();
}

class _ServicioNuevoState extends State<ServicioNuevo> {
  late ServicioServicioProvider _ServicioServicioProvider;
  late ServicioEmpleadoProvider _ServicioEmpleadoProvider;
  late ServicioClienteProvider _ServicioClienteProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ServicioServicioProvider =
        Provider.of<ServicioServicioProvider>(context, listen: false);
    _ServicioEmpleadoProvider =
        Provider.of<ServicioEmpleadoProvider>(context, listen: false);
    _ServicioClienteProvider =
        Provider.of<ServicioClienteProvider>(context, listen: false);
  }

  final _formKey = GlobalKey<FormState>();
  final _descripcionController = TextEditingController();
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  DateTime? _fechaProgramada;
  ServicioTipo? _servicioTipo;
  TecnicoDetalle? _tecnico;
  Cliente? _cliente;

  List<String> _estado = [
    'NO INICIADO',
    'INICIADO',
    'FINALIZADO SIN OBSERVACIONES',
    'FINALIZADO CON OBSERVACIONES',
    'SUSPENDIDO',
    'POSPUESTO',
  ];

  String _selectedEstado = 'NO INICIADO';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripcion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la descripción';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_tecnico?.especialidad != null
                    ? 'Responsable: ${_tecnico?.id_empleado?.nombreCompleto}'
                    : "Seleccione técnico"),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: () => _selectTecnico(context),
              ),
              ListTile(
                title: Text(_servicioTipo?.tipo != null
                    ? 'Tipo de Servicio: ${_servicioTipo?.tipo}'
                    : "Seleccione tipo"),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: () => _selectServicioTipo(context),
              ),
              ListTile(
                title: Text(_cliente?.nombreCompleto != null
                    ? 'Cliente: ${_cliente?.nombreCompleto}'
                    : "Seleccione cliente"),
                trailing: Icon(Icons.arrow_drop_down),
                onTap: () => _selectCliente(context),
              ),
              buildElevatedButton(
                  'Seleccionar Fecha Inicio', _selectDateAndTimeInicio),
              buildInfoText('Fecha Inicio', _fechaInicio),
              buildElevatedButton(
                  'Seleccionar Fecha Fin', _selectDateAndTimeFin),
              buildInfoText('Fecha Fin', _fechaFin),
              buildElevatedButton(
                  'Seleccionar Fecha Programada', _selectDateAndTimeProgramada),
              buildInfoText('Fecha Programada', _fechaProgramada),
              DropdownButtonFormField(
                value: _selectedEstado,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedEstado = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona el estado';
                  }
                  return null;
                },
                items: _estado.map((String rol) {
                  return DropdownMenuItem<String>(
                    value: rol,
                    child: Text(rol),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _submit(context);
                },
                child: Text('Registrar Servicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTecnico(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ServicioTecnicoBox(
              onTecnicoSelected: (TecnicoDetalle tecnico) {
            setState(() {
              _tecnico = tecnico;
            });
          });
        });
  }

  void _selectServicioTipo(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ServicioTipoBox(
              onServicioTipoSelected: (ServicioTipo servicioTipo) {
            setState(() {
              _servicioTipo = servicioTipo;
            });
          });
        });
  }

  void _selectCliente(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ServicioClienteBox(onClienteSelected: (Cliente cliente) {
            setState(() {
              _cliente = cliente;
            });
          });
        });
  }

  ElevatedButton buildElevatedButton(String label, Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Text buildInfoText(String label, DateTime? dateTime) {
    return Text(
      dateTime != null ? '$label: ${_formatDateTime(dateTime)}' : '',
      style: TextStyle(fontSize: 16),
    );
  }

  Future<void> _selectDateAndTimeInicio() async {
    final pickedDateTime = await _selectDateAndTime(context, _fechaInicio);
    print('datee ${pickedDateTime}');
    if (pickedDateTime != null) {
      setState(() {
        _fechaInicio = pickedDateTime;
      });
    }
  }

  Future<void> _selectDateAndTimeFin() async {
    final pickedDateTime = await _selectDateAndTime(context, _fechaFin);
    print('datee ${pickedDateTime}');
    if (pickedDateTime != null) {
      setState(() {
        _fechaFin = pickedDateTime;
      });
    }
  }

  Future<void> _selectDateAndTimeProgramada() async {
    final pickedDateTime = await _selectDateAndTime(context, _fechaProgramada);
    print('datee ${pickedDateTime}');
    if (pickedDateTime != null) {
      setState(() {
        _fechaProgramada = pickedDateTime;
      });
    }
  }

  Future<DateTime?> _selectDateAndTime(
      BuildContext context, DateTime? initialDateTime) async {
    DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    print('datee: ${pickedDateTime}');

    if (pickedDateTime != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      );
      print('hora ${pickedTime}');

      if (pickedTime != null) {
        pickedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    return pickedDateTime;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ';
  }

  void _submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      print('hola ${_servicioTipo?.tipo}');
      try {
        String url = '${Server().url}/servicio';
        Servicio servicio = Servicio(
            id: '',
            id_cliente: _cliente?.id,
            id_tecnico: _tecnico?.id,
            id_servicio_tipo: _servicioTipo?.id,
            estado: _selectedEstado,
            descripcion: _descripcionController.text,
            fechaInicio: _fechaInicio,
            fechaFin: _fechaFin,
            fechaProgramada: _fechaProgramada);
        Map<String, dynamic> servicioMap = servicio.toMap();
        servicioMap.remove('nombreCompleto');
        if (servicio.fechaFin == null) servicioMap.remove('fechaFin');
        if (servicio.fechaInicio == null) servicioMap.remove('fechaInicio');
        if (servicio.fechaProgramada == null)
          servicioMap.remove('fechaProgramada');
        print('envio de datos ${servicioMap}');
        final response = await Dio().post(
          url,
          data: json.encode(servicioMap),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );
        if (response.statusCode != 200) throw Exception('Error de técnico');
        await _ServicioEmpleadoProvider.syncEmpleado();
        await _ServicioEmpleadoProvider.syncTecnico();
        await _ServicioClienteProvider.syncCliente();
        await _ServicioServicioProvider.syncServicioTipo();
        await _ServicioServicioProvider.syncServicio();
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
                title: Text('Error al registrar Servicio'),
                content: Text(
                  'Servicio duplicado. Por favor, verifica la información e intenta nuevamente.',
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
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.red,
                title: Text('Error al registrar Servicio'),
                content: Text(
                  'Se produjo un error al intentar registrar al cliente. Por favor, inténtalo nuevamente.',
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
      }
    }
  }
}
