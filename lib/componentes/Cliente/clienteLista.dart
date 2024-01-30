import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/servicioClienteProvider.dart';
import 'package:proyecto/models/cliente.dart';
import 'package:dio/dio.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/componentes/Cliente/clienteModificar.dart';
import 'dart:convert';
import 'package:proyecto/componentes/Cliente/clienteDetalle.dart';

class ListaCliente extends StatefulWidget {
  @override
  _ListaClienteState createState() => _ListaClienteState();
}

class _ListaClienteState extends State<ListaCliente> {
  late ServicioClienteProvider _ServicioClienteProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ServicioClienteProvider =
        Provider.of<ServicioClienteProvider>(context, listen: false);
    _ServicioClienteProvider.localCliente();
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
                labelText: 'Buscar Cliente',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ServicioClienteProvider>(
              builder: (context, servicioClienteProvider, child) {
                return ListView.builder(
                  itemCount: servicioClienteProvider.clientes.length,
                  itemBuilder: (context, index) {
                    Cliente cliente = servicioClienteProvider.clientes[index];
                    return Card(
                      child: InkWell(
                        onTap: () {
                          // Navegar a la nueva pantalla
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClienteDetalle(
                                  cliente), // Pasa el cliente a la nueva pantalla
                            ),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(cliente.nombres ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${cliente.apellidoPaterno} ${cliente.apellidoMaterno}',
                                  ),
                                  Text('Dirección: ${cliente.direccion}'),
                                  Text('Telefono: ${cliente.telefono}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _FormularioClienteModificar(
                                          context, cliente);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _eliminarCliente(context, cliente);
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

  void _FormularioClienteModificar(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Modificar Cliente'),
              actions: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            body: ClienteModificar(cliente, _ServicioClienteProvider),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  void _eliminarCliente(BuildContext context, Cliente cliente) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Cliente'),
          content: Text('¿Estás seguro de que deseas eliminar este cliente?'),
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
                _realizarEliminacionCliente(context, cliente);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _realizarEliminacionCliente(
      BuildContext context, Cliente cliente) async {
    try {
      if (cliente.id == null || cliente.id == '')
        throw new Exception('No tiene ID');
      String url = '${Server().url}/cliente/${cliente.id}';
      Map<String, dynamic> clienteMap = cliente.toMap();
      clienteMap.remove('nombreCompleto');
      final response = await Dio().delete(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
      _ServicioClienteProvider.syncCliente();
    } catch (e) {
      if (e is DioError &&
          e.response != null &&
          e.response!.statusCode == 409) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red,
              title: Text('Error al eliminar Cliente'),
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
              title: Text('Error al eliminar Cliente'),
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

  void _modificarCliente(BuildContext context, Cliente cliente) async {
    try {
      if (cliente.id == null || cliente.id == '')
        throw new Exception('No tiene ID');
      print('id:  ${cliente.id}');
      String url = '${Server().url}/cliente/${cliente.id}';
      Map<String, dynamic> clienteMap = cliente.toMap();
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

  void _filtrarClientes(String query) {
    setState(() {
      if (query.isEmpty) {
        _ServicioClienteProvider.filtrarClientes(null);
      } else {
        _ServicioClienteProvider.filtrarClientes(query.toLowerCase());
      }
    });
  }
}
