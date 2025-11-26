import 'package:geolocator/geolocator.dart';

class SimpleLatLng {
  final double latitude;
  final double longitude;
  SimpleLatLng(this.latitude, this.longitude);
}

Future<SimpleLatLng> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location service disabled');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw Exception('Permission denied');
  }

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return SimpleLatLng(position.latitude, position.longitude);
}
