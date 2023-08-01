import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/data_model_project.dart';
import '../provider/data_list_provider.dart';
import '../provider/project_list_provider.dart';
import 'add_project_page.dart';

class ProjectListPage extends StatelessWidget {
  const ProjectListPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectListProvider provider = context.watch<ProjectListProvider>();
    return Column(
      children: [
        const SizedBox(
          width: double.infinity,
          child: DrawerHeader(
            margin: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Text(
              'プロジェクト一覧',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            itemCount: provider.dataList.length,
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (context, index) {
              DataModelProject data = provider.dataList[index];
            
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) {
                  provider.deleteDataList(data);
                  print('削除${data.id}${data.projectName}');
                  // 現在表示中のプロジェクトが削除された場合は、初期状態に戻す
                  DataListProvider dataProvider = context.read<DataListProvider>();
                  if(dataProvider.currentTableName == 'table${data.id.toString()}') {
                    dataProvider.initProject();
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
                  margin: EdgeInsets.all(2),
                  child: ListTile(
                    title: Text(
                      data.projectName,
                      style: const TextStyle(fontSize: 25),
                      overflow: TextOverflow.ellipsis, // 名前が長すぎる場合は切る
                    ),
                    onTap:() {
                      print('tap!!${data.projectName}');
                      // タップされたプロジェクトの内容を表示
                      DataListProvider dataProvider = context.read<DataListProvider>();
                      dataProvider.setProject(data.projectName);
                      dataProvider.setTable(data.id!);
                      Navigator.pop(context);
                    },
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              );
            }),
        ),
        Container(
          height:50,
          width: double.infinity,
          margin: const EdgeInsets.all(5),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              onPrimary: Colors.black,
              elevation: 16),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => const AddProjectPage(),
                );
            },
            child: const Text(
              '新規作成',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        )
      ]
    );
  }
}
