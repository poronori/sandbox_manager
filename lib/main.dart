import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandbox_manager/provider/data_list_provider.dart';
import 'package:sandbox_manager/provider/project_list_provider.dart';
import 'view/bottom_tab_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataListProvider()),
        ChangeNotifierProvider(create: (_) => ProjectListProvider()),
      ],
      child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const BottomTabPage(),
    );
  }
}