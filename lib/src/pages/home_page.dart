import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';
import 'package:qrreaderapp/src/pages/mapas_pages.dart';

import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scanBloc = new ScansBloc();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scanBloc.borrarScanTodos,
          ),
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNAvigationBar(),
      floatingActionButton: _crearFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _crearBottomNAvigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapas')),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Direcciones')),
      ],
    );
  }

  Widget _callPage(int pagainaActual) {
    switch (pagainaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  Widget _crearFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: () => _scanQR(context),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  void _scanQR(BuildContext context) async {
    String futureString = 'https://www.floristeriaanthony.com';
    String futureString2 = 'geo:74.24426803763072,-2.2507114487818853';

    // try {
    //   futureString = await new QRCodeReader().scan();
    // } catch (e) {
    //   futureString = e.toString();
    // }

    if (futureString != null) {
      final nuevoScan = ScanModel(valor: futureString);
      scanBloc.agregarScan(nuevoScan);

      final nuevoScan2 = ScanModel(valor: futureString2);
      scanBloc.agregarScan(nuevoScan2);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.abrirScan(context, nuevoScan);
        });
      } else {
        utils.abrirScan(context, nuevoScan);
      }
    }
  }
}
