import 'dart:io';

import 'package:flutter/material.dart';


const KPrimaryColor = Color(0xFF864A15);
const KBackgroundColor = Color(0xFFF9F4EE);
const KTextColor = Color(0xFF000000);
const kSecondaryColor = Color(0xFFF0E5D7);
const kFontColor = Color(0xFFa8a8a9);

const kDefaultPadding = 20.0;


DateTime prayerDateTime(String time) {
  final now = DateTime.now();
  final parts = time.split(':');

  return DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
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