import 'package:flutter/material.dart';

import '../model/data_model.dart';
import '../model/database_manager.dart';

// データリストの状態管理用
class DataListProvider extends ChangeNotifier {

  String currentProject = '';
  String currentTableName = '';
  List<DataModel> dataList = <DataModel>[];

  // 初期化　データベースから値を取得
  Future<void> init() async {
    dataList = await DatabaseManager.getData(currentTableName);
    notifyListeners();
  }

  /*
  DB側でIDが振られるので、更新がある度に
  DBからデータを取得する
  */
  // データ追加
  void addDataList(DataModel data) async {
    await DatabaseManager.insertData(data, currentTableName);
    init();
  }

  // データ削除
  void deleteDataList(DataModel data) async {
    await DatabaseManager.deleteData(data.id!, currentTableName);
    init();
  }

  // データ更新
  void updateDataList(DataModel data) async {
    await DatabaseManager.updateData(data, currentTableName);
    init();
  }

  // テーブル名のセット
  // table + id の名前にする
  void setTable(int id) {
    currentTableName = 'table${id.toString()}';
    init();
  }

  void setProject(String projectName) {
    currentProject = projectName;
    notifyListeners();
  }

  void initProject() {
    currentTableName = '';
    currentProject = '';
    dataList =  <DataModel>[];
    notifyListeners();
  }
}