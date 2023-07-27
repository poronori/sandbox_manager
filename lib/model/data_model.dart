import 'package:flutter/material.dart';

class DataModel {
  final int? id;
  String xAxis;
  String yAxis;
  String zAxis;
  String? memo = '';
  String? image = '';
  String? type;

  DataModel({
    this.id,
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
    this.memo,
    this.image,
    this.type,
  });


  Map<String, dynamic> toMap() {
    return {
      'xAxis': xAxis,
      'yAxis': yAxis,
      'zAxis': zAxis,
      'memo': memo,
      'image': image,
      'type': type,
    };
  }
}

enum TypeList {
  home('拠点', Icon(Icons.house, color: Colors.redAccent, size: 50)),
  homeSub('サブ拠点', Icon(Icons.home, color:Colors.blueAccent, size: 30)),
  village('村', Icon(Icons.holiday_village, color:Colors.brown, size: 30)),
  building('建造物', Icon(Icons.question_mark, color:Colors.greenAccent, size: 30)),
  cave('洞窟', Icon(Icons.trip_origin, color:Colors.amber, size: 30)),
  biome('バイオーム', Icon(Icons.area_chart, color:Colors.pinkAccent, size: 30)),
  others('その他', Icon(Icons.location_pin, size: 30)),
  ;

  const TypeList(this.name, this.icon);
  final String name;
  final Icon icon;
}