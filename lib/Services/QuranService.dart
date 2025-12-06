import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_proj/Services/dio.dart';
import 'package:intl/intl.dart';


class QuranService extends ChangeNotifier {

  Future<List<Map<String,dynamic>>> getQuranAll() async {

    try {

      final response = await dio().get('surah');


      final data = response.data['data'] ?? [];

      notifyListeners();

      // Vérification et cast
      if (data is List) {
        return data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
      }

      return [];

    } on DioError catch (error) {
      if (error.type == DioErrorType && error.error is HandshakeException) {
        // Handle HandshakeException here


        return [];
      } else if (error.error is HttpException) {
        HttpException httpException = error.error as HttpException;
        if (httpException.message == 'Connection closed before full header was received') {



          return [];
        }
      }else if (error.type == DioErrorType.receiveTimeout || error.error is SocketException) {
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


  Future<Map<String,dynamic>> getSurahDetails(int surahNumber) async {

    try {

      final response = await dio().get(
          'surah/$surahNumber/ar.asad'
      );


      final data = response.data;

      print('flmsdkfsmdlsssss : ${data}');
      notifyListeners();

      // Vérification et cast
      if(data != null ){
        return data;
      }

      return {
        "error" : 1 ,
        "message" : "probleme d api"
      };

    } on DioError catch (error) {
      if (error.type == DioErrorType && error.error is HandshakeException) {
        // Handle HandshakeException here


        return {
          "error" : 1 ,
          "message" : "probleme d api"
        };

      } else if (error.error is HttpException) {
        HttpException httpException = error.error as HttpException;
        if (httpException.message == 'Connection closed before full header was received') {



          return {
            "error" : 1 ,
            "message" : "probleme d api"
          };

        }
      }else if (error.type == DioErrorType.receiveTimeout || error.error is SocketException) {
        // Handle the timeout error here


        return {
          "error" : 1 ,
          "message" : "probleme d api"
        };

      }else if (error.response?.statusCode == 403) {
        print('40333333333333333333333333333333333333333333333333333333333333333333');


      }
      // Handle other DioErrors
      throw error.message.toString();
    } catch (error) {
      // Handle other errors
      throw error.toString();
    }
  }

}