import 'package:flutter/material.dart';
import 'package:proyecto/models/empleado.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/servicioEmpleadoProvider.dart';

class ServicioTecnicoBox extends StatefulWidget {
  final Function(TecnicoDetalle) onTecnicoSelected;

  ServicioTecnicoBox({required this.onTecnicoSelected});

  @override
  _ServicioTecnicoBoxState createState() => _ServicioTecnicoBoxState();
}

class _ServicioTecnicoBoxState extends State<ServicioTecnicoBox> {
  late Future<void> _dataLoadingFuture;

  @override
  void initState() {
    super.initState();
    // Llama a localTecnico() cuando se inicializa el estado
    _dataLoadingFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<ServicioEmpleadoProvider>(context, listen: false)
        .localTecnico();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Selecciona Técnico Responsable'),
      content: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al cargar datos: ${snapshot.error}');
          } else {
            return Consumer<ServicioEmpleadoProvider>(
              builder: (context, tecnicoProvider, child) {
                print(
                    'tecnicoccccc ${tecnicoProvider.tecnicoDetalle[0].id_empleado?.nombres}');
                return Container(
                  height: 300, // Ajusta la altura según tus necesidades
                  width: 300, // Ajusta el ancho según tus necesidades
                  child: ListView.builder(
                    itemCount: tecnicoProvider.tecnicoDetalle.length,
                    itemBuilder: (context, index) {
                      TecnicoDetalle tecnico =
                          tecnicoProvider.tecnicoDetalle[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: ListTile(
                          title: Text(
                            tecnico.especialidad ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: tecnico.id_empleado?.nombreCompleto != null
                              ? Text(tecnico.id_empleado?.nombreCompleto! ?? '')
                              : null,
                          onTap: () {
                            widget.onTecnicoSelected(tecnico);
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
          child: Text('Añadir Nuevo Tecnico'),
        )
      ],
    );
  }
}
