import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageManager {

  // アプリ内に画像を保存
  static Future<void> saveImage(File file, String fileName) async {
    String newPath = '${(await getApplicationDocumentsDirectory()).path}/$fileName';
    await file.copy(newPath);
  }

  // アプリ内に保存されている画像の取得
  static Future<File> getImage(String fileName) async {
    String documentPath = (await getApplicationDocumentsDirectory()).path;
    File imageFile = File(join(documentPath, fileName));
    return imageFile;
  }

  // アプリ内の画像を削除
  static Future<void> deleteImage(String fileName) async {
    File imageFile = await getImage(fileName);
    imageFile.delete();
  }
}