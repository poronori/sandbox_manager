import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sandbox_manager/model/data_model_project.dart';
import 'package:provider/provider.dart';

import '../provider/data_list_provider.dart';
import '../provider/project_list_provider.dart';

class EditProjectPage extends StatefulWidget {
  const EditProjectPage({super.key, required this.data});

  final DataModelProject data;

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {

  String projectName = '';
  bool errorflg = false;


  @override
  void initState() {
    super.initState();
    projectName = widget.data.projectName;
  }

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
        DataModelProject data = DataModelProject(id:widget.data.id, projectName: projectName);
        provider.updateDataList(data);

        // 現在表示中のプロジェクトが変更された場合は表示も変える
        DataListProvider dataProvider = context.read<DataListProvider>();
        if(dataProvider.currentTableName == 'table${widget.data.id.toString()}') {
          dataProvider.setProject(projectName);
        }
                  
        Navigator.of(context).pop(true);
      }
    }

    return CupertinoAlertDialog(
      title: const Text("プロジェクト名変更"),
      content: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            child: const Text(
              '変更後のプロジェクト名を入力してください。',
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