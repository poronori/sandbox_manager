import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data_model.dart';

class DatabaseManager {
  
  // データベース接続
  static Future<Database> get database async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'sandbox_database.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブル作成
          "CREATE TABLE sandbox(id INTEGER PRIMARY KEY AUTOINCREMENT, xAxis TEXT, yAxis TEXT, zAxis TEXT, memo TEXT, image TEXT, type TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  // 挿入
  static Future<void> insertData(DataModel data) async {

    final Database db = await database;
    await db.insert(
      'sandbox',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 取得
  static Future<List<DataModel>> getData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sandbox');
    List<DataModel> dataList = List.generate(maps.length, (i) {
      return DataModel(
        id: maps[i]['id'],
        xAxis: maps[i]['xAxis'],
        yAxis: maps[i]['yAxis'],
        zAxis: maps[i]['zAxis'],
        memo: maps[i]['memo'],
        image: maps[i]['image'],
        type: maps[i]['type'],
      );
    });
    // 新しい順に表示するために逆順にする
    return List.from(dataList.reversed); 
  }

  // 更新
  static Future<void> updateData(DataModel data) async {
    final db = await database;
    await db.update(
      'sandbox',
      data.toMap(),
      where: "id = ?",
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // 削除
  static Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete(
      'sandbox',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}