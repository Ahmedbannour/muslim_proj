import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/NotifsService.dart';
import 'package:muslim_proj/Services/SimpleLatLng.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

const prayerTask = "dailyPrayerTask";



@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Hive.initFlutter();
    final box = await Hive.openBox('muslim_proj');

    final online = await isOnline();

    Map<dynamic, dynamic> timings;

    if (online) {
      // 🔵 ONLINE → API
      final location = await getCurrentLocation();

      timings = await getPrayerByDate(DateTime.now(), LatLng(location.latitude, location.longitude));
      box.put('today_prayers', timings);
    } else {
      // 🔴 OFFLINE → HIVE
      timings = Map<String, dynamic>.from(box.get('today_prayers', defaultValue: {}),);
    }

    await schedulePrayerNotifications(
      Map<String, String>.from(timings),
    );

    return Future.value(true);
  });
}


/// Récupère les prières pour une date spécifique et les stocke dans Hive
Future<Map<dynamic, dynamic>> getPrayerByDate(DateTime today, LatLng location) async {
  final box = await Hive.openBox('muslim_proj');
  String date = DateFormat('dd-MM-yyyy').format(today);

  try {
    final response = await Dio().get('http://api.aladhan.com/v1/timings/$date',
      queryParameters: {
        "latitude": location.latitude,
        "longitude": location.longitude,
        "method": 18,
      },
    );

    List<Map<dynamic, dynamic>> timings = [];

    if (response.data != null && response.data['data'] != null && response.data['data']['timings'] != null) {
      Map<String, dynamic> tt = response.data['data']['timings'];

      tt.forEach((key, value) {
        Map<String, dynamic> elem = {"label": key, "time": value};

        if (key == "Fajr") {
          elem['icon'] = "cloud-sun";
        } else if (key == "Dhuhr") {
          elem['icon'] = "brightness";
        } else if (key == "Asr") {
          elem['icon'] = "cloud-sun";
        } else if (key == "Maghrib") {
          elem['icon'] = "moon";
        } else if (key == "Isha") {
          elem['icon'] = "moon-stars";
        }
        timings.add(elem);
      });


      // Met à jour Hive
      Map<dynamic, dynamic> oldPrayersDate = Map<dynamic, dynamic>.from(box.get('prayersListsByDate') ?? {});
      oldPrayersDate[date] = timings;
      box.put('prayersListsByDate', oldPrayersDate);

      return tt;
    }

    return {
        "error" : "no data found",
        "message" : "probleme de connexion"
      };
  } on DioError catch (error) {
    // En cas d'erreur réseau, on retourne les données existantes dans Hive

    return {
      "error" : "no data found",
      "message" : "probleme de connexion"
    };
  } catch (error) {
    // Autres erreurs
    return {
      "error" : "no data found",
      "message" : "probleme de connexion"
    };
  }
}


Future<void> schedulePrayerNotifications(Map<String, String> timings) async {
  final prayers = {
    "Fajr": timings["Fajr"],
    "Dhuhr": timings["Dhuhr"],
    "Asr": timings["Asr"],
    "Maghrib": timings["Maghrib"],
    "Isha": timings["Isha"],
  };

  int id = 1;

  for (final entry in prayers.entries) {
    if (entry.value == null) continue;

    final dateTime = prayerDateTime(entry.value!);

    await NotifsService.schedule(
      id: id++,
      title: "🕌 ${entry.key} Prayer",
      body: "It’s time for ${entry.key} prayer",
      dateTime: dateTime,
    );
  }
}



