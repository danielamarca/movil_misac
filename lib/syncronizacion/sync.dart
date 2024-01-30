import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/provider/engine.dart';

class Syncronization extends ChangeNotifier {
  late final DatabaseManager _databaseDB;

  Syncronization() {
    _databaseDB = DatabaseManager();
    initializeDatabase();
  }
  Future<void> initializeDatabase() async {
    await _databaseDB.initDatabase();
  }

  Future<void> syncServerTable() async {
    await initializeDatabase();

    // Obtener la fecha de sincronización de la tabla 'server'
    String dateSync = await _getSyncDate();
    print('fecha actuala $dateSync');
    try {
      final equipoResponse =
          await Dio().get('${Server().url}/sync${dateSync == '' ?? dateSync}');
      print('synccc   $equipoResponse');
      if (equipoResponse.statusCode == 200) {
        List<dynamic> dataList = equipoResponse.data;
        int cantidadElementos = dataList.length;

        print('Tamaño de la lista de elementos: $cantidadElementos');

        if (cantidadElementos > 0) {
          // Obtener la propiedad "updatedAt" del último elemento
          dynamic ultimoElemento = dataList[cantidadElementos - 1];
          String updatedAt = ultimoElemento['updatedAt'];
          print('updatedAt del último elemento: $updatedAt');
        } else {
          print('La lista de elementos está vacía.');
        }
      } else {
        print('Error en la respuesta de la sincronización');
      }
      // Resto del código...
    } catch (e) {
      // Manejar errores...
    }
  }

  Future<String> _getSyncDate() async {
    final db = await _databaseDB.database;
    final serverTable = ServerTable();
    final List<Map<String, dynamic>> result =
        await db.query(serverTable.tableName);
    if (result.isNotEmpty) {
      // Obtener la fecha de sincronización de la tabla 'server'
      return result.first['dateSync'] ?? '';
    }
    return '';
  }

  // Future<void> getTableSync() async {
  //   try {
  //     final tableSync = await Dio().get('${Server().url}/sync');

  //     if (tableSync.statusCode == 200) {
  //       List<dynamic> dataList = tableSync.data;
  //       int cantidadElementos = dataList.length;

  //       print('Tamaño de la lista de elementos: $cantidadElementos');

  //       if (cantidadElementos > 0) {
  //         // Obtener la propiedad "updatedAt" del último elemento
  //         dynamic ultimoElemento = dataList[cantidadElementos - 1];
  //         String updatedAt = ultimoElemento['updatedAt'];
  //         print('updatedAt del último elemento: $updatedAt');
  //       } else {
  //         print('La lista de elementos está vacía.');
  //       }
  //     } else {
  //       print('Error en la respuesta de la sincronización');
  //     }
  //   } catch (e) {
  //     print('Error al obtener la sincronización: $e');
  //   }
  // }
}
