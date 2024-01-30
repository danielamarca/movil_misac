import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto/provider/server.dart';
import 'package:proyecto/provider/engine.dart';
import 'package:proyecto/models/usuario.dart';
import 'package:bcrypt/bcrypt.dart';

class Authentication {
  Usuario user;
  String token;
  Authentication({required this.user, required this.token});
}

class LogginProvider with ChangeNotifier {
  late final DatabaseManager _databaseDB;
  List<Usuario> _usuarios = [];
  List<Usuario> get usuarios => _usuarios;
  Usuario? _user;
  Authentication? _authenticacion;
  bool _logged = false;
  Usuario? get user => _user;
  bool get logged => _logged;
  Authentication? get authenticacion => _authenticacion;
  LogginProvider() {
    _databaseDB = DatabaseManager();
    initializeDatabase();
  }

  Future<void> initializeDatabase() async {
    await _databaseDB.initDatabase();
  }

  Future<void> syncServerTable() async {
    await initializeDatabase();
    try {
      final equipoResponse = await Dio().get('${Server().url}/sync/usuario');
      if (equipoResponse.statusCode != 200) {
        throw Exception('Error en la respuesta Usuario');
      }
      await _databaseDB.deleteTable('usuario');
      final List<dynamic> dataList = equipoResponse.data;
      await _databaseDB.database.then((db) async {
        var batch = db.batch();
        for (final dynamic data in dataList) {
          batch.insert('usuario', data);
        }
        batch.commit();
      });
      final usuariosLocal = await _databaseDB.getData('usuario');
      _usuarios =
          usuariosLocal.map((result) => Usuario.fromJson(result)).toList() ??
              [];
    } catch (e) {
      throw Exception('Error en la respuesta de usuario');
    }
  }

  void setUser(Usuario username) {
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
    // Intentar autenticación en el servidor
    // var serverAuthResult = await _authenticateOnServer(username, password);
    var serverAuthResult = await _authenticateOnServer('daniel', 'daniel');
    if (serverAuthResult == 0) {
      // Autenticación en el servidor exitosa
      return 0;
    }

    // Si la autenticación en el servidor falla, intentar autenticación local
    var localAuthResult = await _checkLocalAuthentication(username, password);
    if (localAuthResult == 0) {
      // Autenticación local exitosa
      return 0;
    } else {
      // Manejar otros códigos de resultado para la autenticación local
      return localAuthResult;
    }
  }

  Future<int> _checkLocalAuthentication(
      String username, String password) async {
    // Realizar la autenticación local usando SQLite
    var localUser = await _databaseDB.getUserByUsername(username);

    if (localUser.isNotEmpty) {
      var storedPasswordHash =
          localUser.first['password']; // Ajusta según tu estructura de datos
      if (BCrypt.checkpw(password, storedPasswordHash)) {
        // Autenticación local exitosa
        var auth = Authentication(
          user: Usuario.fromJson(localUser.first),
          token: "local_token",
        );
        setAuthentication(auth);
        setUser(Usuario.fromJson(localUser.first));
        setLogged(true);
        return 0;
      } else {
        // Contraseña incorrecta
        return 1;
      }
    } else {
      // Usuario no encontrado
      return 1;
    }
  }

  Future<int> _authenticateOnServer(String username, String password) async {
    // Autenticación en el servidor, similar a tu función original
    var url = Uri.parse('${Server().url}/auth');
    var headers = {"Content-Type": "application/json"};
    var body = json.encode({'username': username, 'password': password});
    try {
      var response = await Dio().post(
        url.toString(),
        options: Options(headers: headers),
        data: body,
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(response.toString());

        // Asumiendo que la respuesta contiene los campos necesarios
        var user = Usuario(
          id: responseData['user']['id'],
          username: responseData['user']['username'],
          password: responseData['user']['password'],
          privilegio: responseData['user']['privilegio'],
          id_empleado: responseData['user']['id_empleado'],
        );

        var token = responseData['token'];
        var auth = Authentication(user: user, token: token);
        setAuthentication(auth);
        setUser(user);
        setLogged(true);
        return 0;
      } else {
        // Maneja otros códigos de estado HTTP
        return 1;
      }
    } catch (dioError) {
      // Manejar errores específicos de Dio, como falta de conexión
      if (dioError is DioError) {
        print(
            'Error de conexión: No hay conexión al servidor. Intentando autenticación local.');
        return 2;
      }
      // Manejar otros errores
      print('Error de conexión: ${dioError.toString()}');
      return 3;
    }
  }
}
