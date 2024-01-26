import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/server.dart';
import 'package:http/http.dart' as http;

import 'package:proyecto/componentes/Equipo/entidades.dart';

// class Equipo {
//   String? id;
//   String? nombre;
//   String? descripcion;
//   double? precio;
//   double? stock;
//   Equipo({
//     required this.nombre,
//     required this.descripcion,
//     required this.precio,
//     required this.stock,
//   });
// }

class CrearEquipo with ChangeNotifier {
  Equipo? _producto;
  Future<int> login(String nombre, String descripcion) async {
    var url = Uri.parse('${Server().url}/producto');
    var headers = {"Content-Type": "application/json"};
    var body = json.encode({'nombre': nombre, 'descripcion': descripcion});
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var responseData = json.decode(response.body);
        print(responseData);
        return 0;
      } else {
        // Maneja otros códigos de estado HTTP
        return 1;
      }
    } catch (e) {
      // Manejar la excepción
      print('Error de conexión: ${e.toString()}');
      return 2;
    }
  }
}
