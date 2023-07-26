import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandbox_manager/provider/data_list_provider.dart';

import 'add_data_page.dart';
import 'map_page.dart';
import 'data_list_page.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BottomTabPageState();
  }
}

class _BottomTabPageState extends State<BottomTabPage> {
  int _currentIndex = 0;
  final _pageWidgets = [const DataListPage(), const MapPage()];

  @override
  void initState(){
    super.initState();
    // データリストの初期化
    DataListProvider provider = context.read<DataListProvider>();
    provider.init();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SandBox Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                builder: (context) => const AddDataPage(),
              );
            },
          ),
        ],
      ),
      body: _pageWidgets.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'リスト'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '地図'),
        ],
        currentIndex: _currentIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) => setState(() => _currentIndex = index);
}
