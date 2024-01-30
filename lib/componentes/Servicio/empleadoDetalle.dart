import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/servicioClienteProvider.dart';
import 'package:proyecto/models/empleado.dart';
import 'package:dio/dio.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/componentes/Empleado/empleadoModificar.dart';
import 'dart:convert';

class EmpleadoDetalle extends StatefulWidget {
  Empleado empleado;
  EmpleadoDetalle(this.empleado);

  @override
  _ClienteDetalleState createState() => _ClienteDetalleState();
}

class _ClienteDetalleState extends State<EmpleadoDetalle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Detalles del Empleado'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDatosPersonales(),
            _buildTarjeta('Productos Comprados', _buildListaProductos()),
            _buildTarjeta('Servicios Adquiridos', _buildListaServicios()),
          ],
        ),
      ),
    );
  }

  Widget _buildDatosPersonales() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos Personales',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text('Nombre: ${widget.empleado.nombres}'),
          Text('Apellido Paterno: ${widget.empleado.apellidoPaterno}'),
          Text('Apellido Materno: ${widget.empleado.apellidoMaterno}'),
          // Agregar más detalles según sea necesario
        ],
      ),
    );
  }

  Widget _buildTarjeta(String titulo, Widget contenido) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              contenido,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListaProductos() {
    return Column(
      children: [
        ListTile(
          title: Text('Producto 1'),
          subtitle: Text('Detalles del Producto 1'),
        ),
        ListTile(
          title: Text('Producto 2'),
          subtitle: Text('Detalles del Producto 2'),
        ),
        // Puedes agregar más elementos según sea necesario
      ],
    );
  }

  Widget _buildListaServicios() {
    return Column(
      children: [
        ListTile(
          title: Text('Servicio 1'),
          subtitle: Text('Detalles del Servicio 1'),
        ),
        ListTile(
          title: Text('Servicio 2'),
          subtitle: Text('Detalles del Servicio 2'),
        ),
        ListTile(
          title: Text('Servicio 1'),
          subtitle: Text('Detalles del Servicio 1'),
        ),
        ListTile(
          title: Text('Servicio 2'),
          subtitle: Text('Detalles del Servicio 2'),
        ),
        ListTile(
          title: Text('Servicio 1'),
          subtitle: Text('Detalles del Servicio 1'),
        ),
        ListTile(
          title: Text('Servicio 2'),
          subtitle: Text('Detalles del Servicio 2'),
        ),
        // Puedes agregar más elementos según sea necesario
      ],
    );
  }
}
