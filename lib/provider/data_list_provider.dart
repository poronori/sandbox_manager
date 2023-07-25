import 'package:flutter/material.dart';

import '../model/data_model.dart';
import '../model/database_manager.dart';

// データリストの状態管理用
class DataListProvider extends ChangeNotifier {

  List<DataModel> dataList = <DataModel>[];

  // 初期化　データベースから値を取得
  Future<void> init() async {
    dataList = await DatabaseManager.getData();
  }

  /*
  DB側でIDが振られるので、更新がある度に
  DBからデータを取得する
  */
  // データ追加
  void addDataList(DataModel data) async {
    await DatabaseManager.insertData(data);
    await init();
    notifyListeners();
  }

  // データ削除
  void deleteDataList(DataModel data) async {
    await DatabaseManager.deleteData(data.id!);
    await init();
    notifyListeners();
  }

  // データ更新
  void updateDataList(int index, DataModel data) async {
    await DatabaseManager.updateData(data);
    await init();
    notifyListeners();
  }
}