import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_proj/Services/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:intl/intl.dart';


class PrayersInfoService extends ChangeNotifier {

  Future<List<Map<String,dynamic>>> getPrayerInfos(DateTime date , LatLng location) async {
    print('latitudess : ${location.latitude} , longitude : ${location.longitude}');
    print('datee : ${DateFormat('dd-MM-yyyy', 'fr_FR').format(DateTime.now())}');

    String dateFormatted = DateFormat('dd-MM-yyyy', 'fr_FR').format(date);


    try {
      final response = await dio().get('/timings/$dateFormatted',
        queryParameters: {
          "latitude": location.latitude,
          "longitude": location.longitude,
          "method": 3,
        },
      );

      print('response : ${response.data['data']['timings']} ');

      List<Map<String,dynamic>> timings = [];

      if(response.data != null && response.data['data'] != null && response.data['data']['timings'] != null){
        Map<String,dynamic> tt = response.data['data']['timings'];
        print('tt : $tt');

        tt.forEach((key , value){
          print('key : $key');
          print('value :$value');

          Map<String,dynamic> elem = {
            "label" : key,
            "time" : value,
          };


          if(key == "Fajr"){
            elem['icon'] = "cloud-sun";
          }else if(key == "Dhuhr"){
            elem['icon'] = "brightness";
          }else if(key == "Asr"){
            elem['icon'] = "cloud-sun";
          }else if(key == "Maghrib"){
            elem['icon'] = "moon";
          }else if(key == "Isha"){
            elem['icon'] = "moon-stars";
          }
          timings.add(elem);
        });

        return timings;
      }


      var res = response.data;

      notifyListeners();
      print('res : ${res}');
      return res;
    } on Dio.DioError catch (error) {
      if (error.type == Dio.DioErrorType && error.error is HandshakeException) {
        // Handle HandshakeException here


        return [];
      } else if (error.error is HttpException) {
        HttpException httpException = error.error as HttpException;
        if (httpException.message == 'Connection closed before full header was received') {



          return [];
        }
      }else if (error.type == Dio.DioErrorType.receiveTimeout || error.error is SocketException) {
        // Handle the timeout error here


        return [];
      }else if (error.response?.statusCode == 403) {
        print('40333333333333333333333333333333333333333333333333333333333333333333');



        // Handle 403 Forbidden error here
        // You can add your specific handling for this error, if needed
      }
      // Handle other DioErrors
      throw error.message.toString();
    } catch (error) {
      // Handle other errors
      throw error.toString();
    }
  }

}

