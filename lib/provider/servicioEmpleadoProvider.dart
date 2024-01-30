import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:proyecto/provider/engine.dart';
import 'package:proyecto/models/empleado.dart';
import 'package:proyecto/provider/server.dart';

class ServicioEmpleadoProvider extends ChangeNotifier {
  List<Empleado> _empleado = [];
  List<Tecnico> _tecnicos = [];
  List<TecnicoDetalle> _tecnicoDetalle = [];
  late final DatabaseManager _databaseDB;

  List<Empleado> get empleado => _empleado;
  List<Tecnico> get tecnicos => _tecnicos;
  List<TecnicoDetalle> get tecnicoDetalle => _tecnicoDetalle;

  ServicioEmpleadoProvider() {
    _databaseDB = DatabaseManager();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    await _databaseDB.initDatabase();
  }

  Future<void> syncServerTable(String tableName, {String? endpoint}) async {
    await initializeDatabase();
    try {
      final empleadoResponse =
          await Dio().get('${Server().url}/sync/${endpoint ?? tableName}');
      if (empleadoResponse.statusCode != 200) {
        throw Exception('Error en la respuesta $tableName');
      }
      print('empleadoo lista syncro: ${empleadoResponse}');
      await _databaseDB.deleteTable(tableName);
      final List<dynamic> dataList = empleadoResponse.data;
      await _databaseDB.database.then((db) async {
        var batch = db.batch();
        for (final dynamic data in dataList) {
          batch.insert(tableName, data);
        }
        batch.commit();
      });
      final empleadoLocal = await _databaseDB.getData(tableName);
      await _updateTableList(tableName, localData: empleadoLocal);
      notifyListeners();
    } catch (e) {
      throw Exception('Error en la respuesta de ${tableName}');
    }
  }

  Future<void> syncEmpleado() async {
    await syncServerTable('empleado');
  }

  Future<void> syncTecnico() async {
    await syncServerTable('tecnico');
  }

  Future<void> fetchLocalData(String tableName) async {
    await initializeDatabase();
    final empleadoLocal = await _databaseDB.getData(tableName);
    await _updateTableList(tableName, localData: empleadoLocal);
  }

  Future<void> localEmpleado() async {
    await fetchLocalData('empleado');
  }

  Future<void> localTecnico() async {
    await fetchLocalData('tecnico');
  }

  Future<void> localTecnicoDetalle() async {
    final List<Map<String, dynamic>> datos =
        await _databaseDB.getDataTecnicoWithDetails();
    _tecnicoDetalle =
        datos.map((map) => TecnicoDetalle.fromMapDetalle(map)).toList();
  }

  Future<void> _updateTableList(String tableName,
      {List<dynamic>? localData}) async {
    switch (tableName) {
      case 'empleado':
        _empleado =
            localData?.map((result) => Empleado.fromJson(result)).toList() ??
                [];
        break;
      case 'tecnico':
        _tecnicos =
            localData?.map((result) => Tecnico.fromJson(result)).toList() ?? [];
        await localTecnicoDetalle();
        break;
    }
    notifyListeners();
  }

  Future<void> filtrarEmpleados(String? query) async {
    final List<Empleado> empleadoLocal = (await _databaseDB.getData('empleado'))
        .map((result) => Empleado.fromJson(result as Map<String, dynamic>))
        .toList();
    if (query != null && query.isNotEmpty) {
      _empleado = empleadoLocal
          .where((cliente) => (cliente.nombreCompleto?.toLowerCase() ?? "")
              .contains(query.toLowerCase()))
          .toList();
    } else {
      _empleado = empleadoLocal;
    }
    notifyListeners();
  }
}
