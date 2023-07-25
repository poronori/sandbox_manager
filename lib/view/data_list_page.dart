import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/data_model.dart';
import '../provider/data_list_provider.dart';

class DataListPage extends StatelessWidget {
  const DataListPage({super.key});

  @override
  Widget build(BuildContext context) {
    DataListProvider provider = context.watch<DataListProvider>();

    return ListView.builder(
        itemCount: provider.dataList.length,
        itemBuilder: (context, index) {
          DataModel data = provider.dataList[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (DismissDirection direction) {
              provider.deleteDataList(data);
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
                  style: const TextStyle(fontSize: 30),
                  overflow: TextOverflow.ellipsis, // 名前が長すぎる場合は切る
                ),
                // 座標
                subtitle: Text(
                  '${data.xAxis}, ${data.yAxis}, ${data.zAxis}',
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            ),
          );
        });
  }
}
