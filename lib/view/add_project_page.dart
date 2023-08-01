import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sandbox_manager/model/data_model_project.dart';
import 'package:provider/provider.dart';

import '../model/database_manager.dart';
import '../provider/data_list_provider.dart';
import '../provider/project_list_provider.dart';

class AddProjectPage extends StatelessWidget {
  const AddProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectListProvider provider = context.read<ProjectListProvider>();
    String projectName = '';

    void _save() async {
      // プロジェクト管理テーブルに挿入
      DataModelProject data = DataModelProject(projectName: projectName);
      provider.addDataList(data);
    }

    return CupertinoAlertDialog(
      title: const Text("新規作成"),
      content: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            child: const Text(
              '新規で作成するプロジェクト名を入力してください。',
              textAlign: TextAlign.left,
            ),
          ),
          CupertinoTextField(
            onChanged: (value) async {
              projectName = value;
            }),
        ],
      ),
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
            _save();
            Navigator.of(context).pop(true);
          },
          child: const Text('OK'),
        ),
      ]
    );
  }
}