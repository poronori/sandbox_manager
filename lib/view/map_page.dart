import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MapPageState();
  }
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: latLng.LatLng(0, 0),
        zoom: 15.0,
        maxZoom: 18.0,
        minZoom: 2.0,
      ),
      children: [
        TileLayer(
          urlTemplate: "assets/grid.png",
          tileProvider: AssetTileProvider(),
        ),
        /*
        0.00001度 = 1mとして考える
        */
        MarkerLayer(
          markers: [
            Marker(
              point: latLng.LatLng(0, 0),
              builder: (ctx) => const Icon(
                Icons.location_pin,
                color: Colors.redAccent,
              ),
            ),
            Marker(
              point: latLng.LatLng(0.001, 0),
              builder: (ctx) => const Icon(
                Icons.location_pin,
                color: Colors.redAccent,
              ),
            ),
            Marker(
              point: latLng.LatLng(0, 0.019),
              builder: (ctx) => const Icon(
                Icons.location_pin,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}