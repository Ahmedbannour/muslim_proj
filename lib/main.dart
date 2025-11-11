import 'package:flutter/material.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Widgets/DashboardWidget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


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
      // 🌍 Support des langues
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      locale: const Locale('fr'), // ✅ Force la langue française
      home: const DashboardWidget(),
    );
  }


}
