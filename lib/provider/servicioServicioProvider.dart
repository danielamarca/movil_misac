import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:proyecto/provider/engine.dart';
import 'package:proyecto/models/servicio.dart';
import 'package:proyecto/provider/server.dart';

class ServicioServicioProvider extends ChangeNotifier {
  List<Servicio> _servicio = [];
  List<ServicioDetalle> _servicioDetalle = [];
  List<ServicioTipo> _servicioTipo = [];

  late final DatabaseManager _databaseDB;
  List<Servicio> get servicio => _servicio;
  List<ServicioDetalle> get servicioDetalle => _servicioDetalle;
  List<ServicioTipo> get servicioTipo => _servicioTipo;

  ServicioServicioProvider() {
    _databaseDB = DatabaseManager();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    await _databaseDB.initDatabase();
  }

  Future<void> syncServerTable(String tableName, {String? endpoint}) async {
    await initializeDatabase();
    try {
      final servicioResponse =
          await Dio().get('${Server().url}/sync/${endpoint ?? tableName}');
      if (servicioResponse.statusCode != 200) {
        throw Exception('Error en la respuesta $tableName');
      }
      print('servicioo lista syncro: ${tableName} ${servicioResponse}');
      await _databaseDB.deleteTable(tableName);
      final List<dynamic> dataList = servicioResponse.data;
      await _databaseDB.database.then((db) async {
        var batch = db.batch();
        for (final dynamic data in dataList) {
          batch.insert(tableName, data);
        }
        batch.commit();
      });
      final servicioLocal = await _databaseDB.getData(tableName);
      await _updateTableList(tableName, localData: servicioLocal);
      notifyListeners();
    } catch (e) {
      throw Exception('Error en la respuesta de ${tableName}');
    }
  }

  Future<void> syncServicio() async {
    await syncServerTable('servicio');
  }

  Future<void> syncServicioTipo() async {
    await syncServerTable('servicio_tipo');
  }

  Future<void> fetchLocalData(String tableName) async {
    await initializeDatabase();
    final servicioLocal = await _databaseDB.getData(tableName);
    await _updateTableList(tableName, localData: servicioLocal);
    notifyListeners();
  }

  Future<void> localServicio() async {
    await fetchLocalData('servicio');
  }

  Future<void> localServicioTipo() async {
    await fetchLocalData('servicio_tipo');
  }

  Future<void> localServicioDetalle() async {
    final List<Map<String, dynamic>> datos =
        await _databaseDB.getDataServicioWithDetails();
    _servicioDetalle =
        datos.map((map) => ServicioDetalle.fromMapDetalle(map)).toList();
  }

  Future<void> _updateTableList(String tableName,
      {List<dynamic>? localData}) async {
    switch (tableName) {
      case 'servicio':
        _servicio =
            localData?.map((result) => Servicio.fromJson(result)).toList() ??
                [];
        await localServicioDetalle();
        break;
      case 'servicio_tipo':
        _servicioTipo = localData
                ?.map((result) => ServicioTipo.fromJson(result))
                .toList() ??
            [];
        await localServicioDetalle();
        break;
    }
    notifyListeners();
  }

  Future<void> filtrarServicios(String? query) async {
    final List<Servicio> servicioLocal = (await _databaseDB.getData('servicio'))
        .map((result) => Servicio.fromJson(result as Map<String, dynamic>))
        .toList();
    if (query != null && query.isNotEmpty) {
      _servicio = servicioLocal
          .where((servicio) => (servicio.descripcion?.toLowerCase() ?? "")
              .contains(query.toLowerCase()))
          .toList();
    } else {
      _servicio = servicioLocal;
    }
    notifyListeners();
  }
}
