import 'dart:async';

import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc {
  static final ScansBloc _singleton = ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream;

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvier.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async {
    await DBProvier.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvier.db.deleteScan(id);

    obtenerScans();
  }

  borrarScanTodos() async {
    await DBProvier.db.deleteAllScan();
    obtenerScans();
  }
}
