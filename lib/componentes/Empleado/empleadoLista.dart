import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/servicioEmpleadoProvider.dart';
import 'package:proyecto/models/empleado.dart';
import 'package:dio/dio.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/componentes/Empleado/empleadoModificar.dart';
import 'dart:convert';
import 'package:proyecto/componentes/Empleado/empleadoDetalle.dart';

class ListaEmpleado extends StatefulWidget {
  @override
  _ListaEmpleadoState createState() => _ListaEmpleadoState();
}

class _ListaEmpleadoState extends State<ListaEmpleado> {
  late ServicioEmpleadoProvider _ServicioEmpleadoProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ServicioEmpleadoProvider =
        Provider.of<ServicioEmpleadoProvider>(context, listen: false);
    _ServicioEmpleadoProvider.localEmpleado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filtrarClientes,
              decoration: InputDecoration(
                labelText: 'Buscar Empleado',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ServicioEmpleadoProvider>(
              builder: (context, servicioEmpleadoProvider, child) {
                return ListView.builder(
                  itemCount: servicioEmpleadoProvider.empleado.length,
                  itemBuilder: (context, index) {
                    Empleado empleado =
                        servicioEmpleadoProvider.empleado[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          // Navegar a la nueva pantalla
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmpleadoDetalle(
                                  empleado), // Pasa el cliente a la nueva pantalla
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(empleado.nombres ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${empleado.apellidoPaterno} ${empleado.apellidoMaterno}',
                                  ),
                                  Text(
                                    'Rol: ${empleado.rol}',
                                  ),
                                  Text('Dirección: ${empleado.direccion}'),
                                  Text('Telefono: ${empleado.telefono}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _FormularioClienteModificar(
                                          context, empleado);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _eliminarEmpleado(context, empleado);
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _FormularioClienteModificar(BuildContext context, Empleado empleado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Modificar Empleado'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: EmpleadoModificar(empleado, _ServicioEmpleadoProvider),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  void _eliminarEmpleado(BuildContext context, Empleado empleado) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Empleado'),
          content: Text('¿Estás seguro de que deseas eliminar este empleado?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Cierra el diálogo de confirmación
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Cierra el diálogo de confirmación
                _realizarEliminacionEmpleado(context, empleado);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _realizarEliminacionEmpleado(
      BuildContext context, Empleado empleado) async {
    try {
      if (empleado.id == null || empleado.id == '')
        throw new Exception('No tiene ID');
      String url = '${Server().url}/empleado/${empleado.id}';
      Map<String, dynamic> clienteMap = empleado.toMap();
      clienteMap.remove('nombreCompleto');
      final response = await Dio().delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      _ServicioEmpleadoProvider.syncEmpleado();
    } catch (e) {
      if (e is DioError &&
          e.response != null &&
          e.response!.statusCode == 409) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error al eliminar Empleado'),
              content: Text(
                  'Por favor, verifica la información e intenta nuevamente.'),
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
              title: Text('Error al eliminar Empleado'),
              content: Text(
                  'Se produjo un error al intentar registrar al empleado. Por favor, inténtalo nuevamente.'),
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

  void _modificarCliente(BuildContext context, Empleado empleado) async {
    try {
      if (empleado.id == null || empleado.id == '')
        throw new Exception('No tiene ID');
      print('id:  ${empleado.id}');
      String url = '${Server().url}/empleado/${empleado.id}';
      Map<String, dynamic> clienteMap = empleado.toMap();
      clienteMap.remove('nombreCompleto');
      final response = await Dio().put(
        url,
        data: json.encode(clienteMap),
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          }, // Especificar el tipo de contenido
        ),
      );

      // Navigator.of(context).pop();
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
        // Manejar otros errores de manera más general
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

  void _filtrarClientes(String query) {
    setState(() {
      if (query.isEmpty) {
        _ServicioEmpleadoProvider.filtrarEmpleados(null);
      } else {
        _ServicioEmpleadoProvider.filtrarEmpleados(query.toLowerCase());
      }
    });
  }
}
