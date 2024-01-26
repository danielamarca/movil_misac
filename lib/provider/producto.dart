import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/engine.dart';
import 'package:dio/dio.dart';
import 'package:proyecto/provider/server.dart';
// import 'package:proyecto/componentes/Equipo/entidades.dart';
import 'package:proyecto/models/producto.dart';

class ProveedorGlobal with ChangeNotifier {
  List<Equipo> _equipos = [];
  final DatabaseManager _databaseDB = DatabaseManager();

  List<Equipo> get equipos => _equipos;

  Future<void> syncDataFromServer() async {
    try {
      final equipoResponse = await Dio().get('${Server().url}/equipo');
      _equipos.clear();

      print('data ${equipoResponse}');
      if (equipoResponse.statusCode == 200) {
        await _databaseDB.deleteTable('equipo');
        final List<dynamic> dataList = equipoResponse.data['data'];

        // Usar batch para realizar las inserciones de manera eficiente
        await _databaseDB.database.then((db) async {
          var batch = db.batch();
          for (final dynamic data in dataList) {
            batch.insert('equipo', data);
          }
          await batch.commit();
        });
        print('data equipos local ${equipoResponse.data['data']}');
        final equiposData = await _databaseDB.getData('equipo');
        final equiposData1 = await _databaseDB.getData('cliente');
        print('Equipos $equiposData ');
        print('Cliente $equiposData1');
        print('hora actual ${DateTime.now().toIso8601String()}');
        _equipos = equiposData.map((result) {
          return Equipo.fromJson(result);
        }).toList();

        notifyListeners();
      } else {
        throw Exception('Error al cargar equipos');
      }
    } catch (error) {
      print('Error al cargar equipos: $error');
      // Handle error as needed
    }
  }

  Future<void> fetchLocalData() async {
    final resultados = await _databaseDB.getData('equipo');
    _equipos = resultados.map((result) {
      return Equipo.fromJson(result);
    }).toList();
    notifyListeners();
  }
}
