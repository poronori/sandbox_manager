import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandbox_manager/model/data_model_project.dart';
import 'package:provider/provider.dart';

import '../provider/project_list_provider.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {

  String projectName = '';
  bool errorflg = false;

  @override
  Widget build(BuildContext context) {
    ProjectListProvider provider = context.read<ProjectListProvider>();


    void _save() async {
      if (projectName.isEmpty) {
        setState(() {
          errorflg = true;
        });
      } else {
        // プロジェクト管理テーブルに挿入
        DataModelProject data = DataModelProject(projectName: projectName);
        provider.addDataList(data);
        Navigator.of(context).pop(true);
      }
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
            onChanged: (value) {
              setState(() {
                projectName = value;
                errorflg = false;
              });
            }),
          Visibility(
            visible: errorflg,
            child: const Text('プロジェクト名が空です。', style:TextStyle(color: Colors.red)),
          ),
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
          },
          child: const Text('OK'),
        ),
      ]
    );
  }
}