class DataModel {
  final int? id;
  String xAxis;
  String yAxis;
  String zAxis;
  String? memo = '';
  String? image = '';

  DataModel({
    this.id,
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
    this.memo,
    this.image,
  });


  Map<String, dynamic> toMap() {
    return {
      'xAxis': xAxis,
      'yAxis': yAxis,
      'zAxis': zAxis,
      'memo': memo,
      'image': image,
    };
  }
}