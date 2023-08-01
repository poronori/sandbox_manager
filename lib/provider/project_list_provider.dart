import 'package:flutter/material.dart';

import '../model/data_model_project.dart';
import '../model/database_manager.dart';
import '../model/database_manager_project.dart';

// データリストの状態管理用
class ProjectListProvider extends ChangeNotifier {

  List<DataModelProject> dataList = <DataModelProject>[];

  // 初期化　データベースから値を取得
  Future<void> init() async {
    dataList = await DatabaseManagerProject.getData();
    notifyListeners();
  }

  // データ追加
  void addDataList(DataModelProject data) async {
    await DatabaseManagerProject.insertData(data);
    await init();
    // 挿入時に採番されたIDを取得
    int id = dataList[dataList.length - 1].id!;
    // テーブルを作成
    DatabaseManager.createTable('table${id.toString()}');
  }

  // データ削除
  void deleteDataList(DataModelProject data) async {
    await DatabaseManagerProject.deleteData(data.id!);
    init();
    // テーブルも削除
    DatabaseManager.deleteTable('table${data.id.toString()}');
  }

  // データ更新
  void updateDataList(DataModelProject data) async {
    await DatabaseManagerProject.updateData(data);
    init();
  }
}