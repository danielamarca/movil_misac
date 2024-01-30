class Equipo {
  final String? id;
  final String nombre;
  final String? descripcion;
  final double? precio;
  final int? stock;
  final String? id_proveedor;
  final String? id_equipo_categoria;

  Equipo(
      {required this.nombre,
      this.id,
      this.descripcion,
      this.precio,
      this.stock,
      this.id_proveedor,
      this.id_equipo_categoria});

  factory Equipo.fromJson(Map<String, dynamic> json) {
    return Equipo(
      id: json["id"] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? 'sin descripción',
      precio: json['precio'] != null ? json['precio'].toDouble() : null,
      stock: json['stock'] != null
          ? json['stock'] as int
          : 0, // Set default value to 0
      id_proveedor: json['id_proveedor'],
      id_equipo_categoria: json['id_equipo_categoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'id_proveedor': id_proveedor,
      'id_equipo_categoria': id_equipo_categoria,
      'precio': precio,
      'descripcion': descripcion,
      'stock': stock,
    };
  }
}

class Proveedor {
  final String? id;
  final String? nombre;
  final String? descripcion;
  final String? direccion;
  final String? contacto;
  Proveedor(
      {this.nombre, this.id, this.descripcion, this.contacto, this.direccion});
  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      direccion: json['direccion'] ?? '',
      contacto: json['contacto'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'direccion': direccion,
      'contacto': contacto,
    };
  }
}

class EquipoCategoria {
  final String? id;
  final String? nombre;
  final String? descripcion;

  EquipoCategoria({
    this.nombre,
    this.id,
    this.descripcion,
  });
  factory EquipoCategoria.fromJson(Map<String, dynamic> json) {
    return EquipoCategoria(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}

class EquipoCodigo {
  final String? id;
  final String? id_equipo;
  final String? id_venta;
  final String? id_servicio;
  final String? estado;
  final String? codigo;

  EquipoCodigo({
    this.id,
    this.id_venta,
    this.id_equipo,
    this.id_servicio,
    this.estado,
    this.codigo,
  });
  factory EquipoCodigo.fromJson(Map<String, dynamic> json) {
    return EquipoCodigo(
      id: json['id'] ?? '',
      id_equipo: json['id_equipo'],
      id_servicio: json['id_servicio'],
      id_venta: json['id_venta'],
      estado: json['estado'] ?? '',
      codigo: json['codigo'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_equipo': id_equipo,
      'id_servicio': id_servicio,
      'id_venta': id_venta,
      'estado': estado,
      'codigo': codigo,
    };
  }
}

class EquipoFoto {
  final String? id;
  final String? id_equipo;
  final String? archivoUrl;
  final String? formato;
  final String? descripcion;
  EquipoFoto(
      {this.id,
      this.id_equipo,
      this.archivoUrl,
      this.formato,
      this.descripcion});
  factory EquipoFoto.fromJson(Map<String, dynamic> json) {
    return EquipoFoto(
      id: json['id'] ?? '',
      id_equipo: json['id_equipo'],
      archivoUrl: json['archivo_url'] ?? '',
      formato: json['formato'] ?? '',
      descripcion: json['descripcion'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_equipo': id_equipo,
      'archivoUrl': archivoUrl,
      'formato': formato,
      'descripcion': descripcion
    };
  }
}

class EquipoDetalle extends Equipo {
  final Proveedor? proveedors;
  final EquipoCategoria? equipoCategorias;
  final EquipoFoto? equipoFoto;

  EquipoDetalle({
    String? id,
    required String nombre,
    String? descripcion,
    double? precio,
    int? stock,
    this.proveedors,
    this.equipoCategorias,
    this.equipoFoto,
  }) : super(
          id: id,
          nombre: nombre,
          descripcion: descripcion,
          precio: precio,
          stock: stock,
          id_proveedor: proveedors?.id,
          id_equipo_categoria: equipoCategorias?.id,
        );

  factory EquipoDetalle.fromMap(Map<String, dynamic> map) {
    return EquipoDetalle(
      id: map["id"],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'] != null ? map['precio'].toDouble() : null,
      stock: map['stock'],
      proveedors: map['id_proveedor_id'] != null
          ? Proveedor(
              id: map['id_proveedor_id'],
              nombre: map['id_proveedor_nombre'],
              descripcion: map['id_proveedor_descripcion'],
              // ... otros campos de Proveedor
            )
          : null,
      equipoCategorias: map['id_equipo_categoria'] != null
          ? EquipoCategoria(
              id: map['id_equipo_categoria'],
              nombre: map['equipoCategorias_nombre'],
              descripcion: map['equipoCategorias_descripcion'],
              // ... otros campos de EquipoCategoria
            )
          : null,
      equipoFoto: map['equipoFoto_id'] != null
          ? EquipoFoto(
              id: map['equipoFoto_id'],
              id_equipo: map['equipoFoto_id_equipo'],
              archivoUrl: map['equipoFoto_archivoUrl'],
              formato: map['equipoFoto_formato'],
              descripcion: map['equipoFoto_descripcion'],
              // ... otros campos de EquipoFoto
            )
          : null,
    );
  }
}
