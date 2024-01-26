import 'package:flutter/material.dart';

class NuevoEmpleado extends StatefulWidget {
  final VoidCallback onEmpleadoUpdated;
  NuevoEmpleado({Key? key, required this.onEmpleadoUpdated}) : super(key: key);
  @override
  _NuevoEmpleadoState createState() => _NuevoEmpleadoState();
}

class _NuevoEmpleadoState extends State<NuevoEmpleado> {
  final _nombreController = TextEditingController();
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
          children: [
            _buildTextField(controller: _nombreController, label: 'Nombre'),
            _buildTextField(
                controller: _apellidoPaternoController,
                label: 'ApellidoPaterno'),
            _buildTextField(
                controller: _apellidoMaternoController,
                label: 'ApellidoMaterno'),
            _buildTextField(controller: _ciController, label: 'C.I.'),
            _buildTextField(
              controller: _direccionController,
              label: 'Direccion',
              keyboardType: TextInputType.multiline,
              maxLines: 3,
            ),
            _buildTextField(
              controller: _telefonoController,
              label: 'telefono',
              keyboardType: TextInputType.numberWithOptions(decimal: false),
            ),
            _buildTextField(
                controller: _correoController, label: 'Correo Electronico')
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        textCapitalization: TextCapitalization.characters,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }
}
