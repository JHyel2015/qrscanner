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
  final mapController = new MapController();
  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                mapController.move(scan.getLatLng(), 17);
              }),
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(center: scan.getLatLng(), zoom: 17),
      layers: [_crearMapa(), _crearMarcadores(scan)],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
          '{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
      additionalOptions: {
        'accessToken':
            'pk.eyJ1IjoicmljaGpvdGFlZGdlIiwiYSI6ImNrYXVldHlxYTFsdXoyd3BsbnhzdWI4aDgifQ.U46WiA5K8owiRK0cFhhu1g',
        'id': 'mapbox/$tipoMapa',
      },
    );
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
                child: Icon(
                  Icons.location_on,
                  size: 50.0,
                  color: Theme.of(context).primaryColor,
                ),
              ))
    ]);
  }

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.repeat),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          // streets-v11, dark-v10, light-v10, outdoors-v11, satellite-v9
          if (tipoMapa == 'streets-v11') {
            tipoMapa = 'dark-v10';
          } else if (tipoMapa == 'dark-v10') {
            tipoMapa = 'light-v10';
          } else if (tipoMapa == 'light-v10') {
            tipoMapa = 'outdoors-v11';
          } else if (tipoMapa == 'outdoors-v11') {
            tipoMapa = 'satellite-v9';
          } else {
            tipoMapa = 'streets-v11';
          }
          setState(() {});
        });
  }
}
