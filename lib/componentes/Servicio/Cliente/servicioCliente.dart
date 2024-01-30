import 'package:flutter/material.dart';
import 'package:proyecto/models/cliente.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/servicioClienteProvider.dart';

class ServicioClienteBox extends StatefulWidget {
  final Function(Cliente) onClienteSelected;

  ServicioClienteBox({required this.onClienteSelected});

  @override
  _ServicioClienteBoxState createState() => _ServicioClienteBoxState();
}

class _ServicioClienteBoxState extends State<ServicioClienteBox> {
  late Future<void> _dataLoadingFuture;

  @override
  void initState() {
    super.initState();
    // Llama a localCliente() cuando se inicializa el estado
    _dataLoadingFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<ServicioClienteProvider>(context, listen: false)
        .localCliente();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Selecciona Cliente'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<ServicioClienteProvider>(
              builder: (context, clienteProvider, child) {
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: clienteProvider.clientes.length,
                    itemBuilder: (context, index) {
                      Cliente cliente = clienteProvider.clientes[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            cliente.nombres ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: cliente.apellidoPaterno != null
                              ? Text(cliente.apellidoMaterno!)
                              : null,
                          onTap: () {
                            widget.onClienteSelected(cliente);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // Implementa la lógica para añadir nuevo tipo de servicio
            // Puedes abrir otro diálogo o navegar a una nueva pantalla.
            // Ejemplo: Navigator.of(context).pushNamed('/nuevo_tipo_servicio');
          },
          child: Text('Añadir Nuevo Cliente'),
        )
      ],
    );
  }
}
