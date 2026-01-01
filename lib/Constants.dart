import 'dart:io';

import 'package:flutter/material.dart';


const KPrimaryColor = Color(0xFF864A15);
const KBackgroundColor = Color(0xFFF9F4EE);
const KTextColor = Color(0xFF000000);
const kSecondaryColor = Color(0xFFF0E5D7);
const kFontColor = Color(0xFFa8a8a9);

const kDefaultPadding = 20.0;


DateTime prayerDateTime(String date, String time) {
  final dateParts = date.split('-'); // yyyy-MM-dd
  final timeParts = time.split(':'); // HH:mm

  return DateTime(
    int.parse(dateParts[2]), // year
    int.parse(dateParts[1]), // month
    int.parse(dateParts[0]), // day
    int.parse(timeParts[0]), // hour
    int.parse(timeParts[1]), // minute
  );
}

Future<bool> isOnline() async {
  try {
    final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
    return result.isNotEmpty;
  } catch (_) {
    return false;
  }
}