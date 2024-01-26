class Proveedor {
  final String? id;
  final String nombre;
  final String descripcion;
  final String direccion;
  final String contacto;

  Proveedor({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.direccion,
    required this.contacto,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'], // Este está bien porque id es String?
      nombre: json['nombre'] ??
          '', // Proporciona un valor predeterminado si es nulo
      descripcion: json['descripcion'] ??
          '', // Proporciona un valor predeterminado si es nulo
      direccion: json['direccion'] ??
          '', // Proporciona un valor predeterminado si es nulo
      contacto: json['contacto'] ??
          '', // Proporciona un valor predeterminado si es nulo
    );
  }
}

class Categoria {
  final String? id;
  final String nombre;
  final String descripcion;
  Categoria({this.id, required this.nombre, required this.descripcion});
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
        id: json['id'],
        nombre: json['nombre'] ?? '',
        descripcion: json['descripcion'] ?? '');
  }
}

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

  factory Equipo.fromDetalle(EquipoDetalle detalle) {
    return Equipo(
      id: detalle.id,
      id_proveedor: detalle.id_proveedor.id,
      id_equipo_categoria: detalle.id_equipo_categoria,
      nombre: detalle.nombre,
      descripcion: detalle.descripcion,
      stock: detalle.stock,
      precio: detalle.precio,
    );
  }
}

class EquipoDetalle {
  final String id;
  final ProveedorDetalle id_proveedor;
  final String id_equipo_categoria;
  final String nombre;
  final String descripcion;
  final int stock;
  final double precio;

  EquipoDetalle({
    required this.id,
    required this.id_proveedor,
    required this.id_equipo_categoria,
    required this.nombre,
    required this.descripcion,
    required this.stock,
    required this.precio,
  });

  factory EquipoDetalle.fromMap(Map<String, dynamic> map) {
    return EquipoDetalle(
      id: map['id'],
      id_proveedor: ProveedorDetalle.fromMap(map),
      id_equipo_categoria: map['id_equipo_categoria'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      stock: map['stock'],
      precio: map['precio'],
    );
  }
}

class ProveedorDetalle {
  final String id;
  final String nombre;
  final String descripcion;

  ProveedorDetalle({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  factory ProveedorDetalle.fromMap(Map<String, dynamic> map) {
    return ProveedorDetalle(
      id: map['id_proveedor_id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
    );
  }
}

// class EquipoDetalle extends Equipo {
//   final Proveedor? proveedors; // Objeto Proveedor en lugar de ID
//   final Categoria? equipoCategorias; // Objeto Categoria en lugar de ID
//   final EquipoFoto? equipoFoto;

//   EquipoDetalle(
//       {String? id,
//       required String nombre,
//       String? descripcion,
//       double? precio,
//       int? stock,
//       this.proveedors,
//       this.equipoCategorias,
//       this.equipoFoto})
//       : super(
//           id: id,
//           nombre: nombre,
//           descripcion: descripcion,
//           precio: precio,
//           stock: stock,
//           id_proveedor: proveedors?.id,
//           id_equipo_categoria: equipoCategorias?.id,
//         );

//   factory EquipoDetalle.fromJson(Map<String, dynamic> json) {
//     print('proveedor');
//     // print(json);
//     print(json['proveedors']);
//     return EquipoDetalle(
//       id: json["id"],
//       nombre: json['nombre'],
//       descripcion: json['descripcion'],
//       precio: json['precio'] != null ? json['precio'].toDouble() : null,
//       stock: json['stock'],
//       proveedors: json['proveedors'] != null
//           ? Proveedor.fromJson(json['proveedors'])
//           : null,
//       equipoCategorias: json['equipoCategorias'] != null
//           ? Categoria.fromJson(json['equipoCategorias'])
//           : null,
//       equipoFoto: json['equipoFoto'] != null
//           ? EquipoFoto.fromJson(json['equipoFoto'])
//           : null,
//     );
//   }
// }

class EquipoFoto {
  final String? id;
  final String? id_equipo;
  final String? archivoUrl;
  final String? formato;
  final String? descripcion;

  EquipoFoto({
    this.id_equipo,
    this.id,
    this.archivoUrl,
    this.formato,
    this.descripcion,
  });

  factory EquipoFoto.fromJson(Map<String, dynamic> json) {
    return EquipoFoto(
      id: json["id"] ?? '',
      id_equipo: json['id_equipo'] ?? '',
      descripcion: json['descripcion'] ?? 'sin descripción',
      archivoUrl: json['archivoUrl'] ?? '',
      formato: json['formato'] ?? '',
    );
  }
}
