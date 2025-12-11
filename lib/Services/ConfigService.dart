import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:muslim_proj/Services/dio.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';


class ConfigService extends ChangeNotifier {

  Future<List<Map<String,dynamic>>> getTafsirList() async {


    try {
      final response = await dio().get('edition/format/text');

      print('response getTafsirList : ${response.data} ');

      List<Map<String,dynamic>> timings = [];

      if(response.data != null && response.data['data'] != null ){
        List<dynamic> rawList = response.data['data'];
        List<Map<String, dynamic>> allData = rawList.map((e) => Map<String, dynamic>.from(e)).toList();


        print('allData Tafsir : $allData');

        return allData;
      }

      var res = response.data;

      notifyListeners();
      print('res : ${res}');
      return res;
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

  Future<List<Map<String,dynamic>>> getTajweedAyahList() async {


    try {
      final response = await dio().get('edition/format/audio');

      print('response getTajweedList : ${response.data} ');

      List<Map<String,dynamic>> timings = [];

      if(response.data != null && response.data['data'] != null ){
        List<dynamic> rawList = response.data['data'];
        List<Map<String, dynamic>> allData = rawList.map((e) => Map<String, dynamic>.from(e)).toList();


        print('allData Tafsir : $allData');

        return allData;
      }

      var res = response.data;

      notifyListeners();
      print('res : ${res}');
      return res;
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

  Future<List<Map<String,dynamic>>> getTajweedSurahList() async {


    try {
      final response = await dio().get('edition/format/audio');

      print('response getTajweedList : ${response.data} ');

      List<Map<String,dynamic>> timings = [];

      if(response.data != null && response.data['data'] != null ){
        List<dynamic> rawList = response.data['data'];
        List<Map<String, dynamic>> allData = rawList.map((e) => Map<String, dynamic>.from(e)).toList();


        print('allData Tafsir : $allData');

        return allData;
      }

      var res = response.data;

      notifyListeners();
      print('res : ${res}');
      return res;
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

}

