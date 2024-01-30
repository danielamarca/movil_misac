import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:proyecto/provider/engine.dart';
import 'package:proyecto/models/cliente.dart';
import 'package:proyecto/provider/server.dart';

class ServicioClienteProvider extends ChangeNotifier {
  List<Cliente> _cliente = [];

  late final DatabaseManager _databaseDB;

  List<Cliente> get clientes => _cliente;

  ServicioClienteProvider() {
    _databaseDB = DatabaseManager();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    await _databaseDB.initDatabase();
  }

  Future<void> syncServerTable(String tableName, {String? endpoint}) async {
    await initializeDatabase();
    try {
      final clienteResponse =
          await Dio().get('${Server().url}/sync/${endpoint ?? tableName}');
      if (clienteResponse.statusCode != 200) {
        throw Exception('Error en la respuesta $tableName');
      }

      await _databaseDB.deleteTable(tableName);
      final List<dynamic> dataList = clienteResponse.data;
      await _databaseDB.database.then((db) async {
        var batch = db.batch();
        for (final dynamic data in dataList) {
          batch.insert(tableName, data);
        }
        batch.commit();
      });
      final clienteLocal = await _databaseDB.getData(tableName);
      await _updateTableList(tableName, localData: clienteLocal);
      notifyListeners();
    } catch (e) {
      throw Exception('Error en la respuesta de ${tableName}');
    }
  }

  Future<void> syncCliente() async {
    await syncServerTable('cliente');
  }

  Future<void> fetchLocalData(String tableName) async {
    await initializeDatabase();
    final clienteLocal = await _databaseDB.getData(tableName);
    await _updateTableList(tableName, localData: clienteLocal);
  }

  Future<void> localCliente() async {
    await fetchLocalData('cliente');
  }

  Future<void> _updateTableList(String tableName,
      {List<dynamic>? localData}) async {
    switch (tableName) {
      case 'cliente':
        _cliente =
            localData?.map((result) => Cliente.fromJson(result)).toList() ?? [];
        break;
    }
    notifyListeners();
  }

  Future<void> filtrarClientes(String? query) async {
    // Obtener la lista completa de clientes desde la base de datos local
    final List<Cliente> clienteLocal = (await _databaseDB.getData('cliente'))
        .map((result) => Cliente.fromJson(result as Map<String, dynamic>))
        .toList();

    // Filtrar la lista de clientes según la consulta
    if (query != null && query.isNotEmpty) {
      _cliente = clienteLocal
          .where((cliente) => (cliente.nombreCompleto?.toLowerCase() ?? "")
              .contains(query.toLowerCase()))
          .toList();
    } else {
      // Si la consulta está vacía, mostrar todos los clientes
      _cliente = clienteLocal;
    }

    notifyListeners();
  }
}

