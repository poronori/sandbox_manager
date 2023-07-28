import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:provider/provider.dart';

import '../model/data_model.dart';
import '../model/database_manager.dart';
import '../provider/data_list_provider.dart';
import '../view_model/add_data_model.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  String xAxis = '';
  String yAxis = '';
  String zAxis = '';
  String memo = '';
  String image = '';
  String type = TypeList.others.name;

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

/*
  void textScroll() {
    Future.delayed(const Duration(seconds: 1), () {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
    });
  }
*/
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
    ;

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
          // ×ボタン
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '新規追加',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
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

                          // 追加ボタン
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                onPrimary: Colors.black,
                                elevation: 16),
                            onPressed: _saved,
                            child: const Text('保存'),
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
      DataModel data = DataModel(
        xAxis: xAxis,
        yAxis: yAxis,
        zAxis: zAxis,
        memo: memo,
        image: '',
        type: type,
      );
      DataListProvider provider = context.read<DataListProvider>();
      provider.addDataList(data);
      Navigator.of(context).pop();
    }
  }
}
