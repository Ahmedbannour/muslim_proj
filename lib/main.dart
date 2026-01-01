import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/ConfigService.dart';
import 'package:muslim_proj/Services/NotifsService.dart';
import 'package:muslim_proj/Services/PrayersInfo.dart';
import 'package:muslim_proj/Services/QuranService.dart';
import 'package:muslim_proj/Widgets/DashboardWidget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ⚡ TOUJOURS en premier

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('muslim_proj');


  // Initialize notifications
  await NotifsService().initializeNotification();
  await NotifsService().requestPermissions();  // Android 13+

  // Initialize timezone
  await initializeTimeZone();  // ⚡ CRUCIAL

  runApp(const MyApp());
}



Future<void> initializeTimeZone() async {
  tz.initializeTimeZones();

  // Récupère le nom du fuseau horaire local (ex: "Europe/Paris")
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();

  // Initialise tz avec ce fuseau horaire
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> PrayersInfoService(),),
        ChangeNotifierProvider(create: (context)=> ConfigService(),),
        ChangeNotifierProvider(create: (context)=> QuranService(),),
      ],
      child: MaterialApp(
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
      ),
    );
  }


}
