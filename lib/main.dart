import 'package:flutter/material.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/DashboardWidget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muslim App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      home: const DashboardWidget(),
    );
  }


}
