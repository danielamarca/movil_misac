import 'package:proyecto/models/cliente.dart';
import 'package:proyecto/models/empleado.dart';

class Servicio {
  String? id;
  String? id_servicio_tipo;
  String? id_cliente;
  String? id_tecnico;
  String? descripcion;
  String? estado;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  DateTime? fechaProgramada;

  Servicio({
    this.id,
    this.id_servicio_tipo,
    this.id_cliente,
    this.id_tecnico,
    this.descripcion,
    this.estado,
    this.fechaInicio,
    this.fechaFin,
    this.fechaProgramada,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json["id"] ?? '',
      id_servicio_tipo: json['id_servicio_tipo'] ?? '',
      id_cliente: json['id_cliente'] ?? '',
      id_tecnico: json['id_tecnico'] ?? '',
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? '',
      fechaInicio: _parseDateTime(json['fechaInicio']),
      fechaFin: _parseDateTime(json['fechaFin']),
      fechaProgramada: _parseDateTime(json['fechaProgramada']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_servicio_tipo': id_servicio_tipo,
      'id_cliente': id_cliente,
      'id_tecnico': id_tecnico,
      'descripcion': descripcion,
      'estado': estado,
      'fechaInicio': fechaInicio?.toIso8601String() ?? null,
      'fechaFin': fechaFin?.toIso8601String() ?? null,
      'fechaProgramada': fechaProgramada?.toIso8601String() ?? null,
    };
  }

  void modificar({
    String? id,
    String? id_servicio_tipo,
    String? id_cliente,
    String? id_tecnico,
    String? descripcion,
    String? estado,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    DateTime? fechaProgramada,
  }) {
    this.id = id ?? this.id;
    this.id_servicio_tipo = id_servicio_tipo ?? this.id_servicio_tipo;
    this.id_cliente = id_cliente ?? this.id_cliente;
    this.id_tecnico = id_tecnico ?? this.id_tecnico;
    this.descripcion = descripcion ?? this.descripcion;
    this.estado = estado ?? this.estado;
    this.fechaInicio = fechaInicio ?? this.fechaInicio;
    this.fechaFin = fechaFin ?? this.fechaFin;
    this.fechaProgramada = fechaProgramada ?? this.fechaProgramada;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}

class ServicioTipo {
  String? id;
  String? tipo;
  String? descripcion;

  ServicioTipo({
    this.id,
    this.tipo,
    this.descripcion,
  });

  factory ServicioTipo.fromJson(Map<String, dynamic> json) {
    return ServicioTipo(
      id: json["id"] ?? '',
      tipo: json['tipo'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'descripcion': descripcion,
    };
  }

  void modificar({String? id, String? tipo, String? descripcion}) {
    this.id = id ?? this.id;
    this.tipo = tipo ?? this.tipo;
    this.descripcion = descripcion ?? this.descripcion;
  }
}

class ServicioInspeccion {
  String? id;
  String? id_servicio;
  String? estado;
  double? costo;
  String? observacion;
  DateTime? fechaInspeccion;

  ServicioInspeccion(
      {this.id,
      this.id_servicio,
      this.estado,
      this.costo,
      this.observacion,
      this.fechaInspeccion});

  factory ServicioInspeccion.fromJson(Map<String, dynamic> json) {
    return ServicioInspeccion(
      id: json["id"] ?? '',
      id_servicio: json["id_servicio"] ?? '',
      estado: json['estado'] ?? '',
      costo: json['costo'] != null
          ? double.tryParse(json['costo'].toString())
          : null,
      observacion: json['observacion'] ?? '',
      fechaInspeccion: _parseDateTime(json['fechaInspeccion']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_servicio': id_servicio,
      'estado': estado,
      'costo': costo,
      'observacion': observacion,
      'fechaInspeccion': fechaInspeccion?.toIso8601String() ?? null,
    };
  }

  void modificar({
    String? id,
    String? id_servicio,
    String? estado,
    double? costo,
    String? observacion,
    DateTime? fechaInspeccion,
  }) {
    this.id = id ?? this.id;
    this.id_servicio = id_servicio ?? this.id_servicio;
    this.estado = estado ?? this.estado;
    this.costo = costo ?? this.costo;
    this.observacion = observacion ?? this.observacion;
    this.fechaInspeccion = fechaInspeccion ?? this.fechaInspeccion;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}

class ServicioEquipo {
  String? id;
  String? id_equipo;
  String? id_servicio;
  int? cantidad;
  String? codigo;

  ServicioEquipo({
    this.id,
    this.id_equipo,
    this.id_servicio,
    this.cantidad,
    this.codigo,
  });

  factory ServicioEquipo.fromJson(Map<String, dynamic> json) {
    return ServicioEquipo(
      id: json["id"] ?? '',
      id_equipo: json["id_equipo"] ?? '',
      id_servicio: json["id_servicio"] ?? '',
      cantidad: json['cantidad'] != null
          ? int.tryParse(json['cantidad'].toString())
          : null,
      codigo: json['codigo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_equipo': id_equipo,
      'id_servicio': id_servicio,
      'cantidad': cantidad,
      'codigo': codigo,
    };
  }

  void modificar({
    String? id,
    String? id_equipo,
    String? id_servicio,
    int? cantidad,
    String? codigo,
  }) {
    this.id = id ?? this.id;
    this.id_equipo = id_servicio ?? this.id_equipo;
    this.id_servicio = id_servicio ?? this.id_servicio;
    this.cantidad = cantidad ?? this.cantidad;
    this.codigo = codigo ?? this.codigo;
  }
}

class ServicioDetalle {
  String? id;
  ServicioTipo? id_servicio_tipo;
  Cliente? id_cliente;
  TecnicoDetalle? id_tecnico;
  String? descripcion;
  String? estado;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  DateTime? fechaProgramada;
  String? createdAt;
  String? updatedAt;

  ServicioDetalle({
    this.id,
    this.id_servicio_tipo,
    this.id_cliente,
    this.id_tecnico,
    this.descripcion,
    this.estado,
    this.fechaInicio,
    this.fechaFin,
    this.fechaProgramada,
    this.createdAt,
    this.updatedAt,
  });

  factory ServicioDetalle.fromJson(Map<String, dynamic> json) {
    return ServicioDetalle(
      id: json["id"] ?? '',
      id_servicio_tipo: json['id_servicio_tipo_id'] != null
          ? ServicioTipo.fromJson(json['id_servicio_tipo'])
          : null,
      id_cliente: json['id_cliente_id'] != null
          ? Cliente.fromJson(json['id_cliente'])
          : null,
      id_tecnico: json['id_tecnico_id'] != null
          ? TecnicoDetalle.fromJson(json['id_tecnico'])
          : null,
      descripcion: json['descripcion'] ?? '',
      estado: json['estado'] ?? '',
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFin: json['fechaFin'] ?? '',
      fechaProgramada: json['fechaProgramada'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  factory ServicioDetalle.fromMapDetalle(Map<String, dynamic> map) {
    return ServicioDetalle(
      id: map["id"],
      id_servicio_tipo: ServicioTipo(
          id: map['servicio_tipo_id'],
          descripcion: map['servicio_tipo_descripcion'],
          tipo: map['servicio_tipo_tipo']),
      id_cliente: Cliente(
        id: map["cliente_id"] ?? '',
        cod_cliente: map['cliente_cod_cliente'] ?? '',
        nombres: map['cliente_nombres'] ?? '',
        apellidoPaterno: map['cliente_apellidoPaterno'] ?? '',
        apellidoMaterno: map['cliente_apellidoMaterno'] ?? '',
        nombreCompleto: map['cliente_nombreCompleto'] ?? '',
        ci: map['cliente_ci'] ?? 'sin Carnet de Identidad',
        direccion: map['cliente_direccion'] ?? '',
        telefono: map['cliente_telefono'] ?? '',
        correo: map['cliente_correo'] ?? 'sin Correo',
      ),
      id_tecnico: TecnicoDetalle(
        id: map["tecnico_id"],
        id_empleado: map['tecnico_id_empleado_id'] != null
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
        especialidad: map['tecnico_especialidad'],
      ),
      descripcion: map['descripcion'],
      estado: map['estado'],
      fechaInicio: _parseDateTime(map['fechaInicio']),
      fechaFin: _parseDateTime(map['fechaFin']),
      fechaProgramada: _parseDateTime(map['fechaProgramada']),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_servicio_tipo':
          id_servicio_tipo != null ? id_servicio_tipo!.toMap() : null,
      'id_cliente': id_cliente != null ? id_cliente!.toMap() : null,
      'id_tecnico': id_tecnico != null ? id_tecnico!.toMap() : null,
      'descripcion': descripcion,
      'estado': estado,
      'fechaInicio': fechaInicio?.toIso8601String() ?? null,
      'fechaFin': fechaFin?.toIso8601String() ?? null,
      'fechaProgramada': fechaProgramada?.toIso8601String() ?? null,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  void modificar(
      {String? id,
      ServicioTipo? id_servicio_tipo,
      Cliente? id_cliente,
      TecnicoDetalle? id_tecnico,
      String? descripcion,
      String? estado,
      DateTime? fechaInicio,
      DateTime? fechaFin,
      DateTime? fechaProgramada,
      String? createdAt,
      String? updaDateTime}) {
    this.id = id ?? this.id;
    this.id_servicio_tipo = id_servicio_tipo ?? this.id_servicio_tipo;
    this.id_cliente = id_cliente ?? this.id_cliente;
    this.id_tecnico = id_tecnico ?? this.id_tecnico;
    this.descripcion = descripcion ?? this.descripcion;
    this.estado = estado ?? this.estado;
    this.fechaInicio = fechaInicio ?? this.fechaInicio;
    this.fechaFin = fechaFin ?? this.fechaFin;
    this.fechaProgramada = fechaProgramada ?? this.fechaProgramada;
    this.createdAt = createdAt ?? this.createdAt;
    this.updatedAt = updatedAt ?? this.updatedAt;
  }

  static DateTime? _parseDateTime(String? dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      return DateTime.parse(dateString);
    }
    return null;
  }
}
