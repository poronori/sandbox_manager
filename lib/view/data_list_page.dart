import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandbox_manager/view/edit_data_page.dart';

import '../model/data_model.dart';
import '../model/image_manager.dart';
import '../provider/data_list_provider.dart';
import '../provider/project_list_provider.dart';

class DataListPage extends StatelessWidget {
  const DataListPage({super.key});

  @override
  Widget build(BuildContext context) {
    DataListProvider provider = context.watch<DataListProvider>();
    ProjectListProvider projectProvider = context.watch<ProjectListProvider>();

    if (projectProvider.dataList.isEmpty) {
      return const Center(child:Text('左上のメニューボタンよりプロジェクトを作成してください'));
    } else if (provider.currentProject.isEmpty) {
      return const Center(child:Text('左上のメニューボタンよりプロジェクトを選択してください'));
    } else if (provider.dataList.isEmpty) {
      return const Center(child:Text('右上の+ボタンよりデータを追加してください'));
    } else {
    return ListView.builder(
        itemCount: provider.dataList.length,
        itemBuilder: (context, index) {
          DataModel data = provider.dataList[index];

          Icon icon;
          if (data.type == TypeList.home.name) {
            icon = TypeList.home.icon;
          } else if (data.type == TypeList.homeSub.name) {
            icon = TypeList.homeSub.icon;
          } else if (data.type == TypeList.village.name) {
            icon = TypeList.village.icon;
          } else if (data.type == TypeList.building.name) {
            icon = TypeList.building.icon;
          } else if (data.type == TypeList.cave.name) {
            icon = TypeList.cave.icon;
          } else if (data.type == TypeList.biome.name) {
            icon = TypeList.biome.icon;
          } else {
            icon = TypeList.others.icon;
          }

          return Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              provider.deleteDataList(data);
              // 画像が設定されていれば削除
              String image = data.image ?? '';
              if (image.isNotEmpty) {
                ImageManager.deleteImage(image);
              }
            },
            // 削除時の確認ダイアログ
            confirmDismiss: (direction) async {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                      title: const Text("確認"),
                      content: const Text("スワイプしたデータを削除します"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('キャンセル'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('OK'),
                        ),
                      ]);
                },
              );
            },

            // 表示項目
            child: Card(
              child: ListTile(
                // メモ
                title: Text(
                  data.memo ?? '', // nullの場合は空文字
                  style: const TextStyle(fontSize: 25),
                  overflow: TextOverflow.ellipsis, // 名前が長すぎる場合は切る
                ),
                // 座標
                subtitle: Text(
                  '${data.xAxis}, ${data.yAxis}, ${data.zAxis}',
                  style: const TextStyle(fontSize: 15),
                ),
                leading: icon,
                onTap:() {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    builder: (context) => EditDataPage(data: data),
                  );
                },
              ),
            ),
          );
        });
    }
  }
}
