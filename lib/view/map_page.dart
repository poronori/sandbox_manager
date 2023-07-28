import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:provider/provider.dart';

import '../model/data_model.dart';
import '../provider/data_list_provider.dart';
import 'edit_data_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  // タイル
  Widget _buildTile(BuildContext context, Widget tileWidget, TileImage tile) {

    // zoom値16を起点にして、ピクセル座標を計算する
    int zoom = tile.coordinates.z;
    num xAxis = pow(2, (16 - zoom)) * tile.coordinates.x * 256;
    num zAxis = pow(2, (16 - zoom)) * tile.coordinates.y * -256;

    return Stack(
      fit: StackFit.expand, // zoomしたときの歪みを消す
      children: [
        Image(image: tile.imageProvider, fit: BoxFit.cover,),
        Text('(${xAxis.toString()}, ${zAxis.toString()})'),
      ],);
  }

  @override
  Widget build(BuildContext context) {
    latLng.LatLng center = latLng.LatLng(0,0);
    DataListProvider provider = context.watch<DataListProvider>();
    CrsSimple crs = CrsSimple(); // 平面地図を使う

    // 拠点が設定されていればセンターにもってくる
    for (var data in provider.dataList) {
      if (data.type == TypeList.home.name) {
        latLng.LatLng? newCenter = crs.pointToLatLng(CustomPoint(double.parse(data.xAxis), double.parse(data.zAxis) * -1), 16);
        center = newCenter ?? latLng.LatLng(0, 0);
      }
    }

    return FlutterMap(
      options: MapOptions(
        center: center,
        zoom: 15.0,
        maxZoom: 18.0,
        minZoom: 2.0,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag, // 回転しないようにする
        crs: crs,
      ),
      children: [
        TileLayer(
          // グリッド線を表示する
          urlTemplate: "assets/grid.png",
          tileProvider: AssetTileProvider(),
          tileBuilder: _buildTile,
        ),
        MarkerLayer(
          markers: provider.dataList.map((DataModel data){

            double xAxis = double.parse(data.xAxis);
            double zAxis = double.parse(data.zAxis) * -1; // タイルの左上が0点になるため反転させる
            // ズーム値16.0の時に1タイルの1辺256mとして描画
            latLng.LatLng? xy = crs.pointToLatLng(CustomPoint(xAxis, zAxis), 16);

            String memo = data.memo ?? '';
            String type = data.type ?? TypeList.others.name;

            Marker marker(Icon icon) {
              return Marker(
                width: 60,
                height: 60,
                point: xy!,
                builder: (ctx) { 
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap:() {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            ),
                            builder: (context) => EditDataPage(data: data),
                          );
                        },
                        child: icon,
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          memo, 
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              );
            }

            // switchでやるとエラーになるのでif-else
            if (type == TypeList.home.name) {
              return marker(TypeList.home.icon);
            } else if (type == TypeList.homeSub.name) {
              return marker(TypeList.homeSub.icon);
            } else if (type == TypeList.village.name) {
              return marker(TypeList.village.icon);
            } else if (type == TypeList.building.name) {
              return marker(TypeList.building.icon);
            } else if (type == TypeList.biome.name) {
              return marker(TypeList.biome.icon);
            } else if (type == TypeList.cave.name) {
              return marker(TypeList.cave.icon);
            } else {
              return marker(TypeList.others.icon);
            }
          }).toList(),
        ),
      ],
    );
  }
}