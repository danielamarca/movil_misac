class Usuario {
  String? id;
  String? id_empleado;
  String? username;
  int? privilegio;
  String? password;
  Usuario(
      {this.id,
      this.id_empleado,
      this.username,
      this.privilegio,
      this.password});
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        id: json['id'],
        username: json['username'],
        password: json['password'],
        id_empleado: json['id_empleado'],
        privilegio: json['privilegio']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_empleado': id_empleado,
      'username': username,
      'privilegio': privilegio,
      'password': password
    };
  }
}
