import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvier {
  static Database _database;
  static final DBProvier db = DBProvier._();

  DBProvier._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE TABLE Scans ('
            'id INTEGER PRIMARY KEY,'
            'tipo TEXT,'
            'valor TEXT'
            ')');
      },
    );
  }

  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.rawInsert("INSERT INTO Scans (id, tipo, valor) "
        "VALUES ( ${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor})'");

    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  Future<ScanModel> getScanID(int id) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    List<ScanModel> list =
        res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];

    return list;
  }

  Future<List<ScanModel>> getTodosScansTipo(String tipo) async {
    final db = await database;

    final res = await db.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);

    List<ScanModel> list =
        res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];

    return list;
  }

  Future<int> uodateScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);

    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;

    final res = db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteAllScan() async {
    final db = await database;

    final res = db.delete('Scans');

    return res;
  }
}
