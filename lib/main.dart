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

import 'background_tasks.dart';


void main() async{
  print('hello planning');
  await Hive.initFlutter();
  await Hive.openBox('muslim_proj');
  var box =  Hive.box('muslim_proj');
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  await Workmanager().registerPeriodicTask(
    "prayer_task_id",
    prayerTask,
    frequency: const Duration(hours: 24),
    initialDelay: const Duration(minutes: 1),
    constraints: Constraints(
      networkType: NetworkType.not_required,
    ),
  );
  // initialize notification
  await NotifsService().initializeNotification();
  await NotifsService().requestPermissions();  // 🔥 obligatoire Android 13+
  runApp(const MyApp());
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
