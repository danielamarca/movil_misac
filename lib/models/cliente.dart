class Cliente {
  String? id;
  String? cod_cliente;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? nombreCompleto;
  String? ci;
  String? direccion;
  String? telefono;
  String? correo;

  Cliente(
      {this.id,
      this.cod_cliente,
      this.nombres,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.nombreCompleto,
      this.ci,
      this.direccion,
      this.telefono,
      this.correo});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json["id"] ?? '',
      cod_cliente: json['cod_cliente'] ?? '',
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
      'cod_cliente': cod_cliente,
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
    String? cod_cliente,
    String? nombres,
    String? apellidoPaterno,
    String? apellidoMaterno,
    String? nombreCompleto,
    String? ci,
    String? direccion,
    String? telefono,
    String? correo,
  }) {
    this.id = id ?? this.id;
    this.cod_cliente = cod_cliente ?? this.cod_cliente;
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
