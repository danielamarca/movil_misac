import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:proyecto/provider/engine.dart';
import 'package:proyecto/models/producto.dart';
import 'package:proyecto/provider/server.dart';

class ServicioEquipoProvider extends ChangeNotifier {
  final String tableEquipo = 'equipo';
  final String tableProveedor = 'proveedor';
  List<Equipo> _equipo = [];
  List<EquipoCategoria> _equipoCategoria = [];
  List<EquipoCodigo> _equipoCodigo = [];
  List<EquipoFoto> _equipoFoto = [];
  List<Proveedor> _proveedor = [];
  late final DatabaseManager _databaseDB;

  List<Equipo> get equipos => _equipo;
  List<EquipoCategoria> get equipoCategoria => _equipoCategoria;
  List<EquipoCodigo> get equipoCofigo => _equipoCodigo;
  List<EquipoFoto> get equipoFoto => _equipoFoto;
  List<Proveedor> get proveedor => _proveedor;
  ServicioEquipoProvider() {
    _databaseDB = DatabaseManager();
    initializeDatabase();
  }
  Future<void> initializeDatabase() async {
    await _databaseDB.initDatabase();
  }

  Future<void> syncServerTable(String tableName, {String? endpoint}) async {
    await initializeDatabase();
    try {
      final equipoResponse =
          await Dio().get('${Server().url}/sync/${endpoint ?? tableName}');
      _equipo.clear();
      print('Equipos: $equipoResponse');
      if (equipoResponse.statusCode != 200)
        throw Exception('Error en la respuesta $tableName');
      await _databaseDB.deleteTable(tableName);
      final List<dynamic> dataList = equipoResponse.data;
      await _databaseDB.database.then((db) async {
        var batch = db.batch();
        for (final dynamic data in dataList) {
          batch.insert(tableName, data);
        }
        batch.commit();
      });
      final equipoLocal = await _databaseDB.getData(tableName);
      _equipo = equipoLocal.map((result) {
        return Equipo.fromJson(result);
      }).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Error en la respuesta de ${tableName}');
    }
  }

  Future<void> syncEquipo() async {
    await syncServerTable('equipo');
  }

  Future<void> syncEquipoCategoria() async {
    await syncServerTable('equipo_categoria');
  }

  Future<void> syncProveedor() async {
    await syncServerTable('proveedor');
  }

  Future<void> syncEquipoCodigo() async {
    await syncServerTable('equipo_codigo');
  }

  Future<void> syncEquipoFoto() async {
    await syncServerTable('equipo_foto');
  }

  Future<void> fetchLocalData(String tableName) async {
    await initializeDatabase();
    final equipoLocal = await _databaseDB.getData(tableName);
    _equipo = equipoLocal.map((result) {
      return Equipo.fromJson(result);
    }).toList();
    notifyListeners();
  }

  Future<void> localEquipo() async {
    await fetchLocalData('equipo');
  }

  Future<void> localEquipoCategoria() async {
    await fetchLocalData('equipo_categoria');
  }

  Future<void> localProveedor() async {
    await fetchLocalData('proveedor');
  }

  Future<void> localEquipoCodigo() async {
    await fetchLocalData('equipo_codigo');
  }

  Future<void> localEquipoFoto() async {
    await fetchLocalData('equipo_foto');
  }

  // Future<void> localEquipoDetalle() async {
  //   final equipoDetalle = _databaseDB.getDataEquipoWithDetails();
  //   print('equipoDetalle $equipoDetalle');
  // }
}
