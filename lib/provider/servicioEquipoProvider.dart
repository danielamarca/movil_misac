import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proyecto/provider/engine.dart';
import 'package:proyecto/models/producto.dart';
import 'package:proyecto/provider/server.dart';

class ServicioEquipoProvider extends ChangeNotifier {
  List<EquipoDetalle> _equipoDetalle = [];
  List<Equipo> _equipo = [];
  List<EquipoCategoria> _equipoCategoria = [];
  List<EquipoCodigo> _equipoCodigo = [];
  List<EquipoFoto> _equipoFoto = [];
  List<Proveedor> _proveedor = [];
  late final DatabaseManager _databaseDB;

  List<EquipoDetalle> get equipoDetalle => _equipoDetalle;
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
      if (equipoResponse.statusCode != 200) {
        throw Exception('Error en la respuesta $tableName');
      }

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

      // Actualizar la lista correspondiente según la tabla
      await _updateTableList(tableName, localData: equipoLocal);
    } catch (e) {
      throw Exception('Error en la respuesta de ${tableName}');
    }
  }

  Future<void> syncEquipo() async {
    await syncServerTable('equipo');
    localEquipoDetalle();
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

  Future<void> localEquipoDetalle() async {
    final List<Map<String, dynamic>> datos =
        await _databaseDB.getDataEquipoWithDetails();
    _equipoDetalle = datos.map((map) => EquipoDetalle.fromMap(map)).toList();
  }

  Future<void> fetchLocalData(String tableName) async {
    await initializeDatabase();
    final equipoLocal = await _databaseDB.getData(tableName);
    await _updateTableList(tableName, localData: equipoLocal);
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

  Future<void> _updateTableList(String tableName,
      {List<dynamic>? localData}) async {
    switch (tableName) {
      case 'equipo':
        _equipo =
            localData?.map((result) => Equipo.fromJson(result)).toList() ?? [];
        break;
      case 'equipo_categoria':
        _equipoCategoria = localData
                ?.map((result) => EquipoCategoria.fromJson(result))
                .toList() ??
            [];
        break;
      case 'equipo_codigo':
        _equipoCodigo = localData
                ?.map((result) => EquipoCodigo.fromJson(result))
                .toList() ??
            [];
        break;
      case 'equipo_foto':
        _equipoFoto =
            localData?.map((result) => EquipoFoto.fromJson(result)).toList() ??
                [];
        break;
      case 'proveedor':
        _proveedor =
            localData?.map((result) => Proveedor.fromJson(result)).toList() ??
                [];
        break;
      // Agregar más casos según las tablas necesarias
    }
    notifyListeners();
  }
}
