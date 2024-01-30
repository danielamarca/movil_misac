import 'package:flutter/material.dart';
import 'package:proyecto/models/servicio.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/servicioServicioProvider.dart';

class ServicioTipoBox extends StatefulWidget {
  final Function(ServicioTipo) onServicioTipoSelected;

  ServicioTipoBox({required this.onServicioTipoSelected});

  @override
  _ServicioTipoBoxState createState() => _ServicioTipoBoxState();
}

class _ServicioTipoBoxState extends State<ServicioTipoBox> {
  late Future<void> _dataLoadingFuture;

  @override
  void initState() {
    super.initState();
    // Llama a localServicioTipo() cuando se inicializa el estado
    _dataLoadingFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<ServicioServicioProvider>(context, listen: false)
        .localServicioTipo();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Selecciona Tipo'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<ServicioServicioProvider>(
              builder: (context, servicioProvider, child) {
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: servicioProvider.servicioTipo.length,
                    itemBuilder: (context, index) {
                      ServicioTipo servicioTipo =
                          servicioProvider.servicioTipo[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            servicioTipo.tipo ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: servicioTipo.descripcion != null
                              ? Text(servicioTipo.descripcion!)
                              : null,
                          onTap: () {
                            widget.onServicioTipoSelected(servicioTipo);
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
          child: Text('Añadir Nuevo Tipo de Servicio'),
        )
      ],
    );
  }
}
