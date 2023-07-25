import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/data_model.dart';

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

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // キーボードサイズ
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

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
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close,
                  color: const Color(0xFF090444), size: width * 0.06),
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                            height: 300,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
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
                                      labelText: 'x座標',
                                    ),
                                    onSaved: (value) async {
                                      xAxis = value!;
                                    }),
                              ),
                              Flexible(
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
                                      labelText: 'y座標',
                                    ),
                                    onSaved: (value) async {
                                      yAxis = value!;
                                    }),
                              ),
                              Flexible(
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
                                      labelText: 'z座標',
                                    ),
                                    onSaved: (value) async {
                                      zAxis = value!;
                                    }),
                              ),
                            ],
                          ),
                          TextFormField(
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
    _formKey.currentState!.save();
  }
}
