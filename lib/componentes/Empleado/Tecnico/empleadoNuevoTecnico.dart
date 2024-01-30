import 'package:flutter/material.dart';
import 'package:proyecto/provider/server.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto/models/empleado.dart';

class ListaTecnicoAlert extends StatefulWidget {
  final Function(Tecnico) onTecnicoSelected;
  ListaTecnicoAlert({required this.onTecnicoSelected});
  @override
  _ListaTecnicoAlertState createState() => _ListaTecnicoAlertState();
}

class _ListaTecnicoAlertState extends State<ListaTecnicoAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Selecionar Especialidad'),
        content: SingleChildScrollView(
          child: Text('Holaaa esta lista'),
        ));
  }
}
