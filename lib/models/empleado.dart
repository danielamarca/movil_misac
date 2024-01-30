class Empleado {
  String? id;
  String? rol;
  double? salario;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? nombreCompleto;
  String? ci;
  String? direccion;
  String? telefono;
  String? correo;

  Empleado(
      {this.id,
      this.rol,
      this.salario,
      this.nombres,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.nombreCompleto,
      this.ci,
      this.direccion,
      this.telefono,
      this.correo});

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json["id"] ?? '',
      rol: json['rol'] ?? '',
      salario: json['salario'] != null ? json['salario'].toDouble() : null,
      nombres: json['nombres'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      nombreCompleto: json['nombreCompleto'] ?? '',
      ci: json['ci'] ?? 'sin Carnet de Identidad',
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? 'sin Correo',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rol': rol,
      'salario': salario,
      'nombres': nombres,
      'apellidoPaterno': apellidoPaterno,
      'apellidoMaterno': apellidoMaterno,
      'nombreCompleto': nombreCompleto,
      'ci': ci,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
    };
  }

  void modificar({
    String? id,
    String? rol,
    String? nombres,
    double? salario,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? nombreCompleto,
    String? ci,
    String? direccion,
    String? telefono,
    String? correo,
  }) {
    this.id = id ?? this.id;
    this.rol = rol ?? this.rol;
    this.salario = salario ?? this.salario;
    this.nombres = nombres ?? this.nombres;
    this.apellidoPaterno = apellidoPaterno ?? this.apellidoPaterno;
    this.apellidoMaterno = apellidoMaterno ?? this.apellidoMaterno;
    this.nombreCompleto = nombreCompleto ?? this.nombreCompleto;
    this.ci = ci ?? this.ci;
    this.direccion = direccion ?? this.direccion;
    this.telefono = telefono ?? this.telefono;
    this.correo = correo ?? this.correo;
  }
}

class Tecnico {
  String? id;
  String? id_empleado;
  String? especialidad;
  Tecnico({this.id, this.id_empleado, this.especialidad});
  factory Tecnico.fromJson(Map<String, dynamic> json) {
    return Tecnico(
      id: json["id"] ?? '',
      id_empleado: json['id_empleado'] ?? '',
      especialidad: json['especialidad'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_empleado': id_empleado,
      'especialidad': especialidad,
    };
  }

  void modificar({
    String? id,
    String? id_empleado,
    String? especialidad,
  }) {
    this.id = id ?? this.id;
    this.id_empleado = id_empleado ?? this.id_empleado;
    this.especialidad = especialidad ?? this.especialidad;
  }
}

class TecnicoDetalle {
  String? id;
  Empleado? id_empleado;
  String? especialidad;

  TecnicoDetalle({this.id, this.id_empleado, this.especialidad});

  factory TecnicoDetalle.fromJson(Map<String, dynamic> json) {
    return TecnicoDetalle(
      id: json["id"] ?? '',
      id_empleado: json['id_empleado'] != null
          ? Empleado.fromJson(json['id_empleado'])
          : null,
      especialidad: json['especialidad'] ?? '',
    );
  }

  factory TecnicoDetalle.fromMapDetalle(Map<String, dynamic> map) {
    return TecnicoDetalle(
      id: map["id"],
      id_empleado: map['id_empleado_id'] != null
          ? Empleado(
              id: map["empleado_id"] ?? '',
              rol: map['empleado_rol'] ?? '',
              salario: map['empleado_salario'] != null
                  ? map['empleado_salario'].toDouble()
                  : null,
              nombres: map['empleado_nombres'] ?? '',
              apellidoPaterno: map['empleado_apellidoPaterno'] ?? '',
              apellidoMaterno: map['empleado_apellidoMaterno'] ?? '',
              nombreCompleto: map['empleado_nombreCompleto'] ?? '',
              ci: map['empleado_ci'] ?? 'sin Carnet de Identidad',
              direccion: map['empleado_direccion'] ?? '',
              telefono: map['empleado_telefono'] ?? '',
              correo: map['empleado_correo'] ?? 'sin Correo',
            )
          : null,
      especialidad: map['especialidad'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_empleado': id_empleado != null ? id_empleado!.toMap() : null,
      'especialidad': especialidad,
    };
  }

  void modificar({
    String? id,
    Empleado? id_empleado,
    String? especialidad,
  }) {
    this.id = id ?? this.id;
    this.id_empleado = id_empleado ?? this.id_empleado;
    this.especialidad = especialidad ?? this.especialidad;
  }
}
