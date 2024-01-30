import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:proyecto/componentes/Equipo/entidades.dart';

abstract class DatabaseTable {
  String get tableName;

  String get createTableQuery;

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS $tableName');
      await txn.execute(createTableQuery);
    });
  }
}

class SyncTable extends DatabaseTable {
  @override
  String get tableName => 'sync';

  @override
  String get createTableQuery => '''
   CREATE TABLE IF NOT EXISTS sync(
      id INTEGER PRIMARY KEY,
      tabla TEXT,
      action TEXT,
      id_tabla TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS sync');
      await txn.execute(createTableQuery);
    });
  }
}

class ServerTable extends DatabaseTable {
  @override
  String get tableName => 'server';

  @override
  String get createTableQuery => '''
   CREATE TABLE IF NOT EXISTS server(
      ip TEXT,
      mode TEXT,
      dateSync TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS server');
      await txn.execute(createTableQuery);
    });
  }

  Future<void> updateSyncDate(Database db, String dateSync) async {
    await db.update(
      tableName,
      {'dateSync': dateSync},
    );
  }
}

class SyncLocalTable extends DatabaseTable {
  @override
  String get tableName => 'sync_local';

  @override
  String get createTableQuery => '''
   CREATE TABLE IF NOT EXISTS sync_local(
      id INTEGER PRIMARY KEY,
      tabla TEXT,
      action TEXT,
      id_tabla TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS sync_local');
      await txn.execute(createTableQuery);
    });
  }
}

class UsuarioTable extends DatabaseTable {
  @override
  String get tableName => 'usuario';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS usuario(
      id TEXT PRIMARY KEY,
      id_empleado TEXT REFERENCES empleado(id),
      username TEXT UNIQUE,
      privilegio INTEGER,
      password TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS usuario');
      await txn.execute(createTableQuery);
    });
  }
}

class ClienteTable extends DatabaseTable {
  @override
  String get tableName => 'cliente';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cliente(
      id TEXT PRIMARY KEY,
      cod_cliente TEXT,
      nombres TEXT,
      apellidoPaterno TEXT,
      apellidoMaterno TEXT,
      nombreCompleto TEXT UNIQUE,
      ci TEXT,
      direccion TEXT,
      telefono TEXT,
      correo TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cliente');
      await txn.execute(createTableQuery);
    });
  }
}

class EmpleadoTable extends DatabaseTable {
  @override
  String get tableName => 'empleado';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS empleado(
      id TEXT PRIMARY KEY,
      rol TEXT,
      salario REAL,
      nombres TEXT,
      apellidoPaterno TEXT,
      apellidoMaterno TEXT,
      nombreCompleto TEXT UNIQUE,
      ci TEXT,
      direccion TEXT,
      telefono TEXT,
      correo TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS empleado');
      await txn.execute(createTableQuery);
    });
  }
}

class TecnicoTable extends DatabaseTable {
  @override
  String get tableName => 'tecnico';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS tecnico(
      id TEXT PRIMARY KEY,
      id_empleado TEXT REFERENCES empleado(id),
      especialidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS tecnico');
      await txn.execute(createTableQuery);
    });
  }
}

class ProveedorTable extends DatabaseTable {
  @override
  String get tableName => 'proveedor';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS proveedor (
      id TEXT PRIMARY KEY,
      nombre TEXT UNIQUE,
      descripcion TEXT,
      direccion TEXT,
      contacto TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS proveedor');
      await txn.execute(createTableQuery);
    });
  }
}

class EquipoCategoriaTable extends DatabaseTable {
  @override
  String get tableName => 'equipo_categoria';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo_categoria (
      id TEXT PRIMARY KEY,
      nombre TEXT UNIQUE,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo_categoria');
      await txn.execute(createTableQuery);
    });
  }
}

class EquipoTable extends DatabaseTable {
  @override
  String get tableName => 'equipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo(
      id TEXT PRIMARY KEY,
      id_proveedor TEXT,
      id_equipo_categoria TEXT,
      nombre TEXT,
      descripcion TEXT,
      precio REAL,
      stock INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo');
      await txn.execute(createTableQuery);
    });
  }
}

class EquipoCodigoTable extends DatabaseTable {
  @override
  String get tableName => 'equipo_codigo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo_codigo (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      id_servicio TEXT,
      id_venta TEXT,
      codigo TEXT,
      estado TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo_codigo');
      await txn.execute(createTableQuery);
    });
  }
}

class EquipoFotoTable extends DatabaseTable {
  @override
  String get tableName => 'equipo_foto';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS equipo_foto (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      archivoUrl TEXT,
      formato TEXT,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS equipo_foto');
      await txn.execute(createTableQuery);
    });
  }
}

class HerramientaTable extends DatabaseTable {
  @override
  String get tableName => 'herramienta';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS herramienta (
      id TEXT PRIMARY KEY,
      nombre TEXT UNIQUE,
      descripcion TEXT,
      stock INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS herramienta');
      await txn.execute(createTableQuery);
    });
  }
}

class HerramientaFotoTable extends DatabaseTable {
  @override
  String get tableName => 'herramienta_foto';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS herramienta_foto (
      id TEXT PRIMARY KEY,
      id_herramienta TEXT REFERENCES herramienta(id),
      archivoUrl TEXT,
      formato TEXT,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS herramienta_foto');
      await txn.execute(createTableQuery);
    });
  }
}

class InsumoTable extends DatabaseTable {
  @override
  String get tableName => 'insumo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS insumo (
      id TEXT PRIMARY KEY,
      id_proveedor TEXT REFERENCES proveedor(id),
      nombre TEXT,
      descripcion TEXT,
      costo REAL,
      stock INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS insumo');
      await txn.execute(createTableQuery);
    });
  }
}

class InsumoFotoTable extends DatabaseTable {
  @override
  String get tableName => 'insumo_foto';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS insumo_foto (
      id TEXT PRIMARY KEY,
      id_insumo TEXT REFERENCES insumo(id),
      archivoUrl TEXT,
      formato TEXT,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS insumo_foto');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioTipoTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_tipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_tipo (
      id TEXT PRIMARY KEY,
      tipo TEXT UNIQUE,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_tipo');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioTable extends DatabaseTable {
  @override
  String get tableName => 'servicio';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio (
      id TEXT PRIMARY KEY,
      id_servicio_tipo TEXT REFERENCES servicio_tipo(id),
      id_cliente TEXT REFERENCES cliente(id),
      id_tecnico TEXT REFERENCES tecnico(id),
      descripcion TEXT,
      estado TEXT,
      fechaInicio TEXT,
      fechaFin TEXT,
      fechaProgramada TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioInspeccionTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_inspeccion';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_inspeccion (
      id TEXT PRIMARY KEY,
      id_servicio TEXT REFERENCES servicio(id),
      estado TEXT UNIQUE,
      costo REAL,
      observacion TEXT,
      fechaInspeccion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_inspeccion');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioEquipoTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_equipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_equipo (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      id_servicio TEXT REFERENCES servicio(id),
      cantidad INTEGER,
      codigo TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_equipo');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioHerramientaTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_herramienta';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_herramienta (
      id TEXT PRIMARY KEY,
      id_herramienta TEXT REFERENCES herramienta(id),
      id_servicio TEXT REFERENCES servicio(id),
      costo REAL,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_herramienta');
      await txn.execute(createTableQuery);
    });
  }
}

class ServicioInsumoTable extends DatabaseTable {
  @override
  String get tableName => 'servicio_insumo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS servicio_insumo (
      id TEXT PRIMARY KEY,
      id_insumo TEXT REFERENCES insumo(id),
      id_servicio TEXT REFERENCES servicio(id),
      cantidad INTEGER,
      unidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS servicio_insumo');
      await txn.execute(createTableQuery);
    });
  }
}

class TareaTable extends DatabaseTable {
  @override
  String get tableName => 'tarea';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS tarea (
      id TEXT PRIMARY KEY,
      id_servicio TEXT REFERENCES servicio(id),
      descripcion TEXT,
      estado INTEGER,
      comentarios TEXT,
      costo REAL,
      fechaInicio TEXT,
      fechaFin TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS tarea');
      await txn.execute(createTableQuery);
    });
  }
}

class TareaFotoTable extends DatabaseTable {
  @override
  String get tableName => 'tarea_foto';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS tarea_foto (
      id TEXT PRIMARY KEY,
      id_tarea TEXT REFERENCES tarea(id),
      archivoUrl TEXT,
      formato TEXT,
      descripcion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS tarea_foto');
      await txn.execute(createTableQuery);
    });
  }
}

class VentaTable extends DatabaseTable {
  @override
  String get tableName => 'venta';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta (
      id TEXT PRIMARY KEY,
      id_cliente TEXT REFERENCES cliente(id),
      tipo TEXT,
      estado TEXT,
      fecha TEXT,
      total REAL,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta');
      await txn.execute(createTableQuery);
    });
  }
}

class VentaPagoTable extends DatabaseTable {
  @override
  String get tableName => 'venta_pago';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta_pago (
      id TEXT PRIMARY KEY,
      id_venta TEXT REFERENCES venta(id),
      fecha TEXT,
      monto REAL,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta_pago');
      await txn.execute(createTableQuery);
    });
  }
}

class VentaEquipoTable extends DatabaseTable {
  @override
  String get tableName => 'venta_equipo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta_equipo (
      id TEXT PRIMARY KEY,
      id_equipo TEXT REFERENCES equipo(id),
      id_venta TEXT REFERENCES venta(id),
      cantidad INTEGER,
      unidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta_equipo');
      await txn.execute(createTableQuery);
    });
  }
}

class VentaInsumoTable extends DatabaseTable {
  @override
  String get tableName => 'venta_insumo';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS venta_insumo (
      id TEXT PRIMARY KEY,
      id_insumo TEXT REFERENCES insumo(id),
      id_venta TEXT REFERENCES venta(id),
      cantidad INTEGER,
      unidad TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS venta_insumo');
      await txn.execute(createTableQuery);
    });
  }
}

class CotizacionTable extends DatabaseTable {
  @override
  String get tableName => 'cotizacion';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cotizacion (
      id TEXT PRIMARY KEY,
      id_cliente TEXT REFERENCES cliente(id),
      fechaCreacion TEXT,
      fechaValidez TEXT,
      monto REAL,
      estado INTEGER,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cotizacion');
      await txn.execute(createTableQuery);
    });
  }
}

class CotizacionServicioTable extends DatabaseTable {
  @override
  String get tableName => 'cotizacion_servicio';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cotizacion_servicio (
      id TEXT PRIMARY KEY,
      id_cotizacion TEXT REFERENCES cotizacion(id),
      id_servicio TEXT REFERENCES servicio(id),
      fechaCreacion TEXT,
      fechaValidez TEXT,
      monto REAL,
      observacion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cotizacion_servicio');
      await txn.execute(createTableQuery);
    });
  }
}

class CotizacionVentaTable extends DatabaseTable {
  @override
  String get tableName => 'cotizacion_venta';

  @override
  String get createTableQuery => '''
    CREATE TABLE IF NOT EXISTS cotizacion_venta (
      id TEXT PRIMARY KEY,
      id_cotizacion TEXT REFERENCES cotizacion(id),
      id_venta TEXT REFERENCES venta(id),
      fechaCreacion TEXT,
      fechaValidez TEXT,
      monto REAL,
      observacion TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''';

  Future<void> deleteTable(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS cotizacion_venta');
      await txn.execute(createTableQuery);
    });
  }
}

class DatabaseManager {
  late Database _database;
  late List<DatabaseTable> tables = [
    ServerTable(),
    SyncTable(),
    SyncLocalTable(),
    ClienteTable(),
    EmpleadoTable(),
    TecnicoTable(),
    UsuarioTable(),
    ProveedorTable(),
    EquipoCategoriaTable(),
    EquipoTable(),
    EquipoCodigoTable(),
    EquipoFotoTable(),
    HerramientaTable(),
    HerramientaFotoTable(),
    InsumoTable(),
    InsumoFotoTable(),
    ServicioTable(),
    ServicioTipoTable(),
    ServicioInspeccionTable(),
    ServicioEquipoTable(),
    ServicioHerramientaTable(),
    ServicioInspeccionTable(),
    TareaTable(),
    TareaFotoTable(),
    VentaTable(),
    VentaPagoTable(),
    VentaEquipoTable(),
    VentaInsumoTable(),
    CotizacionTable(),
    CotizacionServicioTable(),
    CotizacionVentaTable()
  ];

  DatabaseManager() {
    initDatabase();
  }
  Future<Database> get database async {
    if (_database == null) {
      throw Exception("Database not initialized. Call initDatabase() first.");
    }
    return _database;
  }

  Future<void> deleteTable(String tableName) async {
    final db = await database;
    final table =
        tables.firstWhere((element) => element.tableName == tableName);
    await table.deleteTable(db);
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'proyecto.db');
    print('path ${path}');
    bool exists = await databaseExists(path);
    print('exists $exists');
    if (!exists) {
      // Si no existe, crea la base de datos
      print('Creando la base de datos por primera vez');
      _database =
          await openDatabase(path, version: 1, onCreate: (db, version) async {
        print('db ${db}');
        print('version ${version}');
        for (var table in tables) {
          print('Creando tabla ${table.tableName}');
          await db.execute(table.createTableQuery);
        }
      });
    } else {
      // Si la base de datos ya existe, simplemente ábrela
      print('Abriendo la base de datos existente');
      _database = await openDatabase(path);
    }

    return _database;
  }

  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> getData(String tableName) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM $tableName
    ''');
  }

  Future<List<Map<String, dynamic>>> getDataID(
      String tableName, String id) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT * FROM $tableName WHERE id=?
    ''', [id]);
  }

  Future<void> closeDatabase() async {
    if (_database.isOpen) {
      await _database.close();
    }
  }

  Future<List<Map<String, dynamic>>> getDataEquipoWithDetails() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT
      equipo.id AS id,
      equipo.id_proveedor AS id_proveedor_id,
      proveedor.nombre AS id_proveedor_nombre,
      proveedor.descripcion AS id_proveedor_descripcion,
      equipo.id_equipo_categoria AS id_equipo_categoria,
      equipo.nombre AS nombre,
      equipo.descripcion AS descripcion,
      equipo.stock AS stock,
      equipo.precio AS precio,
      equipo.createdAt AS createdAt,
      equipo.updatedAt AS updatedAt,
      proveedor.id AS proveedors_id,
      proveedor.nombre AS proveedors_nombre,
      proveedor.descripcion AS proveedors_descripcion,
      proveedor.direccion AS proveedors_direccion,
      proveedor.contacto AS proveedors_contacto,
      proveedor.createdAt AS proveedors_createdAt,
      proveedor.updatedAt AS proveedors_updatedAt,
      equipo_categoria.id AS equipoCategorias_id,
      equipo_categoria.nombre AS equipoCategorias_nombre,
      equipo_categoria.descripcion AS equipoCategorias_descripcion,
      equipo_categoria.createdAt AS equipoCategorias_createdAt,
      equipo_categoria.updatedAt AS equipoCategorias_updatedAt,
      equipo_foto.id AS equipoFoto_id,
      equipo_foto.id_equipo AS equipoFoto_id_equipo,
      equipo_foto.archivoUrl AS equipoFoto_archivoUrl,
      equipo_foto.formato AS equipoFoto_formato,
      equipo_foto.descripcion AS equipoFoto_descripcion,
      equipo_foto.createdAt AS equipoFoto_createdAt,
      equipo_foto.updatedAt AS equipoFoto_updatedAt
    FROM equipo AS equipo
    LEFT JOIN proveedor ON equipo.id_proveedor = proveedor.id
    LEFT JOIN equipo_categoria ON equipo.id_equipo_categoria = equipo_categoria.id
    LEFT JOIN equipo_foto ON equipo.id = equipo_foto.id_equipo
  ''');
  }

  Future<List<Map<String, dynamic>>> getDataServicioWithDetails() async {
    final db = await database;
    return await db.rawQuery('''
    SELECT
      servicio.id AS id,
      servicio.id_servicio_tipo AS id_servicio_tipo_id,
      servicio.id_cliente AS id_cliente_id,
      servicio.id_tecnico AS id_tecnico_id,
      servicio.descripcion AS descripcion,
      servicio.estado AS estado,
      servicio.fechaInicio AS fechaInicio,
      servicio.fechaFin AS fechaFin,
      servicio.fechaProgramada AS fechaProgramada,
      servicio.createdAt AS createdAt,
      servicio.updatedAt AS updatedAt,
      servicio_tipo.id AS servicio_tipo_id,
      servicio_tipo.tipo AS servicio_tipo_tipo,
      servicio_tipo.descripcion AS servicio_tipo_descripcion,
      servicio_tipo.createdAt AS servicio_tipo_createdAt,
      servicio_tipo.updatedAt AS servicio_tipo_updatedAt,
      cliente.id AS cliente_id,
      cliente.cod_cliente AS cliente_cod_cliente,
      cliente.nombres AS cliente_nombres,
      cliente.apellidoPaterno AS cliente_apellido_paterno,
      cliente.apellidoMaterno AS cliente_apellido_materno,
      cliente.nombreCompleto AS cliente_nombreCompleto,
      cliente.ci AS cliente_ci,
      cliente.direccion AS cliente_direccion,
      cliente.telefono AS cliente_telefono,
      cliente.correo AS cliente_correo,
      cliente.createdAt AS cliente_createdAt,
      cliente.updatedAt AS cliente_updatedAt,
      tecnico.id AS tecnico_id,
      tecnico.id_empleado AS tecnico_id_empleado_id,
      tecnico.especialidad AS tecnico_especialidad,
      tecnico.createdAt AS tecnico_createdAt,
      tecnico.updatedAt AS tecnico_updatedAt,
      empleado.id AS empleado_id,
      empleado.rol AS empleado_rol,
      empleado.salario AS empleado_salario,
      empleado.nombres AS empleado_nombres,
      empleado.apellidoPaterno AS empleado_apellido_paterno,
      empleado.apellidoMaterno AS empleado_apellido_materno,
      empleado.nombreCompleto AS empleado_nombreCompleto,
      empleado.ci AS empleado_ci,
      empleado.direccion AS empleado_direccion,
      empleado.telefono AS empleado_telefono,
      empleado.correo AS empleado_correo,
      empleado.createdAt AS empleado_createdAt,
      empleado.updatedAt AS empleado_updatedAt
    FROM servicio
    LEFT JOIN servicio_tipo ON servicio.id_servicio_tipo = servicio_tipo.id
    LEFT JOIN cliente ON servicio.id_cliente = cliente.id
    LEFT JOIN tecnico ON servicio.id_tecnico = tecnico.id
    LEFT JOIN empleado ON tecnico.id_empleado = empleado.id
  ''');
  }

  Future<List<Map<String, dynamic>>> getDataTecnicoWithDetails() async {
    final db = await database;
    return await db.rawQuery('''
  SELECT
  tecnico.id AS id,
  tecnico.id_empleado AS id_empleado_id,
  tecnico.especialidad AS especialidad,
  tecnico.createdAt AS createdAt,
  tecnico.updatedAt AS updatedAt,
  empleado.id AS empleado_id,
  empleado.rol AS empleado_rol,
  empleado.salario AS empleado_salario,
  empleado.nombres AS empleado_nombres,
  empleado.apellidoPaterno AS empleado_apellido_paterno,
  empleado.apellidoMaterno AS empleado_apellido_materno,
  empleado.nombreCompleto AS empleado_nombreCompleto,
  empleado.ci AS empleado_ci,
  empleado.direccion AS empleado_direccion,
  empleado.telefono AS empleado_telefono,
  empleado.correo AS empleado_correo,
  empleado.createdAt AS empleado_createdAt,
  empleado.updatedAt AS empleado_updatedAt
  FROM tecnico AS tecnico
  LEFT JOIN empleado ON tecnico.id_empleado=empleado.id
''');
  }

  Future<List<Map<String, dynamic>>> getUserByUsername(String username) async {
    var db = await database;
    return await db
        .query('usuario', where: 'username = ?', whereArgs: [username]);
  }
}
