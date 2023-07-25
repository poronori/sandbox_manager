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
        center: latLng.LatLng(32.74472, 129.87361),
        zoom: 16.0,
        maxZoom: 17.0,
        minZoom: 3.0,
      ),
      children: [
        TileLayer(
          //urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          tileProvider: AssetTileProvider(),
          subdomains: const ['a', 'b', 'c'],
          retinaMode: true,
        ),
      ],
    );
  }
}