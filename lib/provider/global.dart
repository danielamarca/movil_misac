import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/provider/server.dart';

class User {
  String id;
  String username;
  String password;
  int privilegio;
  String id_empleado;
  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.privilegio,
      required this.id_empleado});
}

class Authentication {
  User user;
  String token;
  Authentication({required this.user, required this.token});
}

class LogginProvider with ChangeNotifier {
  User? _user;
  Authentication? _authenticacion;
  bool _logged = false;
  User? get user => _user;
  bool get logged => _logged;
  Authentication? get authenticacion => _authenticacion;
  void setUser(User username) {
    _user = username;
    notifyListeners();
  }

  void setAuthentication(Authentication authenticacion) {
    _authenticacion = authenticacion;
    notifyListeners();
  }

  void setLogged(bool estadoIngreso) {
    _logged = estadoIngreso;
    notifyListeners();
  }

  Future<int> login(String username, String password) async {
    print("login");
    var url = Uri.parse('${Server().url}/auth');
    print(url);
    var headers = {"Content-Type": "application/json"};
    var body = json.encode({'username': username, 'password': password});
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        var responseData = json.decode(response.body);

        // Asumiendo que la respuesta contiene los campos necesarios
        var user = User(
          id: responseData['user']['id'],
          username: responseData['user']['username'],
          password: responseData['user']['password'],
          privilegio: responseData['user']['privilegio'],
          id_empleado: responseData['user']['id_empleado'],
        );

        var token = responseData['token'];
        var auth = Authentication(user: user, token: token);
        print(auth);
        setAuthentication(auth);
        setUser(user);
        setLogged(true);
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
