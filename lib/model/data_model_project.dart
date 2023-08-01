// プロジェクト用のデータモデル
class DataModelProject {
  final int? id;
  String projectName;

  DataModelProject({
    this.id,
    required this.projectName,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
    };
  }
}