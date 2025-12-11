import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:muslim_proj/Services/dio.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class QuranService extends ChangeNotifier {
  var box = Hive.box('muslim_proj');

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

      print('getSurahDetails : $data');

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


  Future<Map<String,dynamic>> getAyahDetails(int ayahNum , Map<String , dynamic> surah) async {
    String? tajweedAyahId = box.get("tajweedAyahId");

    print('getAyahDetails link : ${'ayah/${surah["number"]}:$ayahNum/${tajweedAyahId ?? 'ar.alafasy'}'}');
    try {

      final response = await dio().get(
          'ayah/${surah["number"]}:$ayahNum/${tajweedAyahId ?? 'ar.alafasy'}'
      );


      final data = response.data;

      print('getAyahDetails : $data');

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


  Future<Map<String,dynamic>> getAyahExplic(int ayahNum , Map<String , dynamic> surah) async {

    try {
      String? tafsirId = box.get("tafsirId");


      final response = await dio().get(
          'ayah/${surah["number"]}:$ayahNum/${tafsirId ?? "ar.muyassar"}'
      );


      final data = response.data;

      notifyListeners();

      // Vérification et cast
      if(data != null && data['code'] != null && data['code'].toString() == '200' && data['data'] != null && data['data'] is Map){
        print('explic : ${data['data']}');
        return data;
      }

      return {
        "error" : 1 ,
        "message" : "probleme d api ayah"
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



  Future<File> getSurahAudio(int surahNumber) async {

    String? tajweedSurahId = box.get("tajweedSurahId");

    // Répertoire de stockage
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$surahNumber");

    try {
      final response = await Dio().get(
        'https://cdn.islamic.network/quran/audio-surah/128/${tajweedSurahId ?? "ar.alafasy"}/$surahNumber.mp3',
        options: Options(
          responseType: ResponseType.bytes, // très important !
          followRedirects: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('fdlkmsflsddsf');

      if (response.statusCode == 200) {
        // Écrire les bytes dans le fichier
        await file.writeAsBytes(response.data!, flush: true);
        return file; // <--- EXACTEMENT ce que tu veux
      } else {
        throw Exception("Échec téléchargement MP3, status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur téléchargement MP3 : $e");
    }
  }


}