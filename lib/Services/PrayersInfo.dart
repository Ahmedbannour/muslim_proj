import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_proj/Services/dio.dart';
import 'package:dio/dio.dart' as Dio;


class PrayersInfoService extends ChangeNotifier {

  Future<List<Map<String,dynamic>>> getPrayerInfos(DateTime date , LatLng location) async {
    try {
      final response = await dio().get('/timings/',
        data: {

        },
      );

      print('response : ${response.data} ');
      var res =response.data;

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

