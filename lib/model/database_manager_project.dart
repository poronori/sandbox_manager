import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'data_model_project.dart';

// プロジェクト用のデータベース
class DatabaseManagerProject {
  
  // データベース接続
  static Future<Database> get database async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'project_database.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブル作成
          'CREATE TABLE project(id INTEGER PRIMARY KEY AUTOINCREMENT, projectName TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  // 挿入
  static Future<void> insertData(DataModelProject data) async {

    final Database db = await database;
    await db.insert(
      'project',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 取得
  static Future<List<DataModelProject>> getData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('project');
    List<DataModelProject> dataList = List.generate(maps.length, (i) {
      return DataModelProject(
        id: maps[i]['id'],
        projectName: maps[i]['projectName'],
      );
    });
    return dataList; 
  }

  // 更新
  static Future<void> updateData(DataModelProject data) async {
    final db = await database;
    await db.update(
      'project',
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
      'project',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}