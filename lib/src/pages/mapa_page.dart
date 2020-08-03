import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';
import 'package:latlong/latlong.dart';

class MapaPage extends StatefulWidget {
  MapaPage({Key key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.my_location), onPressed: () {}),
        ],
      ),
      body: _crearFlutterMap(scan),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      options: MapOptions(center: scan.getLatLng(), zoom: 3),
      layers: [
        _crearMapa(),
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
          '{id}/{z}/{x}/{y}@2x?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoicmljaGpvdGFlZGdlIiwiYSI6ImNrYXVldHlxYTFsdXoyd3BsbnhzdWI4aDgifQ.U46WiA5K8owiRK0cFhhu1g',
        'id': 'mapbox/streets-v11/tiles',
      },
    );
  }
}
