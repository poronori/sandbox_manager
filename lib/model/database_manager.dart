import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data_model.dart';

class DatabaseManager {
  
  // データベース接続
  static Future<Database> database(String tableName) async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'sandbox_database.db'),
      /*
      onCreate: (db, version) {
        return db.execute(
          // テーブル作成
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, xAxis TEXT, yAxis TEXT, zAxis TEXT, memo TEXT, image TEXT, type TEXT)',
        );
      },
      */
      version: 1,
    );
    return database;
  }

  // 挿入
  static Future<void> insertData(DataModel data, String tableName) async {

    final Database db = await database(tableName);
    await db.insert(
      tableName,
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 取得
  static Future<List<DataModel>> getData(String tableName) async {
    final Database db = await database(tableName);
    final List<Map<String, dynamic>> maps = await db.query(tableName);
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
  static Future<void> updateData(DataModel data, String tableName) async {
    final db = await database(tableName);
    await db.update(
      tableName,
      data.toMap(),
      where: "id = ?",
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // 削除
  static Future<void> deleteData(int id, String tableName) async {
    final db = await database(tableName);
    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // テーブル作成
  static Future<void> createTable(String tableName) async {
    final Database db = await database(tableName);
    await db.execute(
      'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, xAxis TEXT, yAxis TEXT, zAxis TEXT, memo TEXT, image TEXT, type TEXT)',
    );
  }

  // テーブル削除
  static Future<void> deleteTable(String tableName) async {
    final Database db = await database(tableName);
    await db.execute(
      'DROP TABLE IF EXISTS $tableName',
    );
  }
}