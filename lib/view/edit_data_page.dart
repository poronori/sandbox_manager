import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sandbox_manager/model/image_manager.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';

import '../model/data_model.dart';
import '../model/database_manager.dart';
import '../provider/data_list_provider.dart';
import '../view_model/add_data_model.dart';

class EditDataPage extends StatefulWidget {
  const EditDataPage({super.key, required this.data});

  final DataModel data;

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  int id = 0;
  String xAxis = '';
  String yAxis = '';
  String zAxis = '';
  String memo = '';
  String type = TypeList.others.name;
  String image = '';
  File? _imageFile;
  bool imageChangeFlg = false; // 画像が変更されたか

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    id = widget.data.id ?? 0;
    xAxis = widget.data.xAxis;
    yAxis = widget.data.yAxis;
    zAxis = widget.data.zAxis;
    memo = widget.data.memo ?? '';
    type = widget.data.type ?? TypeList.others.name;
    image = widget.data.image ?? '';

    Future(() async {
      if (image.isNotEmpty) {
        _imageFile = await ImageManager.getImage(image);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // キーボードサイズ
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // キーボードが表示されたら一番下までスクロール
    if (keyboardHeight != 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
      });
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          // 画面下げるようバー
          Container(
            width: width * 0.08,
            height: height * 0.005,
            margin: const EdgeInsets.only(top: 8, bottom: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFA59E9E),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
          Stack(
            children: [
              // 削除ボタン
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left:5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      onPrimary: Colors.black,
                      elevation: 8),
                  onPressed: _delete,
                  child: const Text('削除'),
                ),
              ),
              // タイトル
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '詳細',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // ×ボタン
              Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close,
                      color: const Color(0xFF090444), size: width * 0.06),
                ),
              ),
            ],
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      // キーボード分上げる
                      padding: EdgeInsets.only(bottom: keyboardHeight),
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                              child: _imageFile == null 
                              // 画像がないとき
                              ? Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                  child: const Text('タップで画像を追加', style: TextStyle(color: Colors.white)),
                                )
                                // 画像が設定されたとき
                              : Container(
                                  alignment: Alignment.center,
                                  height: 250,
                                  child: Image.file(_imageFile!),
                                )
                            ),
                            onTap:() async {
                              final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (pickImage == null) return;
                              setState(() {
                                _imageFile = File(pickImage.path);
                                imageChangeFlg = true;
                              });
                            },
                          ),
                          // タイプの選択
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  child: const Text('タイプ：'),
                                ),
                              ),
                              Flexible(
                                child: DropdownButton(
                                  items: TypeList.values.map((TypeList type) {
                                    return DropdownMenuItem(
                                      value: type.name,
                                      child: Text(type.name),
                                    );
                                  }).toList(),
                                  value: type,
                                  onChanged:(value) {
                                    setState(() {
                                      type = value!;
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: TextFormField(
                                      initialValue: xAxis,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidateText.validate,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        labelText: 'x座標',
                                      ),
                                      onSaved: (value) async {
                                        xAxis = value!;
                                      }),
                                ),
                              ),
                              Flexible(
                                child: TextFormField(
                                    initialValue: yAxis,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: ValidateText.validate,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                          color: Colors.amber,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      labelText: 'y座標',
                                    ),
                                    onSaved: (value) async {
                                      yAxis = value!;
                                    }),
                              ),
                              Flexible(
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: TextFormField(
                                      initialValue: zAxis,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: ValidateText.validate,
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.amber,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                          ),
                                        ),
                                        labelText: 'z座標',
                                      ),
                                      onSaved: (value) async {
                                        zAxis = value!;
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: TextFormField(
                                initialValue: memo,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.amber,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  labelText: 'メモ',
                                ),
                                onSaved: (value) async {
                                  memo = value!;
                                }),
                          ),

                          // 変更
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                onPrimary: Colors.black,
                                elevation: 16),
                            onPressed: _saved,
                            child: const Text('変更'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _saved() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 画像が変更されていれば更新
      if (_imageFile != null && imageChangeFlg) {
        if (image.isEmpty) {
          image = DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString();
        }
        ImageManager.saveImage(_imageFile!, image);
      }
      
      DataModel data = DataModel(
        id: id,
        xAxis: xAxis,
        yAxis: yAxis,
        zAxis: zAxis,
        memo: memo,
        image: image,
        type: type,
      );
      DataListProvider provider = context.read<DataListProvider>();
      provider.updateDataList(data);
      Navigator.of(context).pop();
    }
  }

  void _delete() async {
    var result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text("確認"),
            content: const Text("このデータを削除してもよろしいですか"),
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
    if (context.mounted) {
      if (result) {
        DataListProvider provider = context.read<DataListProvider>();
        provider.deleteDataList(widget.data);
        // 画像が設定されていれば削除
        String image = widget.data.image ?? '';
        if (image.isNotEmpty) {
          ImageManager.deleteImage(image);
        }
        Navigator.of(context).pop();
      }
    }
  }
}
