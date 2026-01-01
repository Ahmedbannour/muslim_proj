import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:muslim_proj/Services/NotifsService.dart';

class PrayersInfoService extends ChangeNotifier {
  var box = Hive.box('muslim_proj');

  /// Télécharge les prières pour les 7 prochains jours à partir de [today]
  Future<List<Map<dynamic, dynamic>>> downloadPrayerForWeek(DateTime today, LatLng location) async {

    List<Map<dynamic , dynamic>> todayPrayers = [];
    for (int i = 0; i < 7; i++) {
      DateTime nextDate = today.add(Duration(days: i));
      String formatted = DateFormat('dd-MM-yyyy').format(nextDate);



      if(i == 0){
        todayPrayers = await getPrayerByDate(formatted, location);
      }else{
        // Télécharge les prières pour cette date
        await getPrayerByDate(formatted, location);
      }
    }

    print('todayPrayers : $todayPrayers');
    return todayPrayers;
  }

  /// Récupère les prières pour une date spécifique et les stocke dans Hive
  Future<List<Map<dynamic, dynamic>>> getPrayerByDate(String date, LatLng location) async {
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



        await schedulePrayerNotifications(
          Map<String, String>.from(tt),
          date
        );
        // Met à jour Hive
        Map<dynamic, dynamic> oldPrayersDate = Map<dynamic, dynamic>.from(box.get('prayersListsByDate') ?? {});
        oldPrayersDate[date] = timings;
        box.put('prayersListsByDate', oldPrayersDate);

        return timings;
      }

      return [
        {
          "error" : "no data found",
          "message" : "probleme de connexion"
        }
      ];
    } on DioError catch (error) {
      // En cas d'erreur réseau, on retourne les données existantes dans Hive

      return [
        {
          "error" : error.type,
          "message" : error.message
        }
      ];
    } catch (error) {
      // Autres erreurs
      return [
        {
          "error" : error,
          "message" : null
        }
      ];
    }
  }


  Future<void> schedulePrayerNotifications(Map<String, String> timings , String date) async {
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

      final dateTime = prayerDateTime(date , entry.value!);

      await NotifsService.schedule(
        id: id++,
        title: "🕌 ${entry.key} Prayer",
        body: "It’s time for ${entry.key} prayer",
        dateTime: dateTime,
      );

      print('prayer added on $date , $dateTime');
    }
  }

}
