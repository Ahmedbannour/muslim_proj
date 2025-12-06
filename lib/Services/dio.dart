import 'package:dio/dio.dart';
import 'package:muslim_proj/Constants.dart';
import 'package:hive/hive.dart';

Dio dio(){

  String url = "http://api.alquran.cloud/v1";


  print('base url : $url');


  Dio dio =Dio();
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
      // Do something before request is sent
      return handler.next(options); // continue with the request
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      // Do something with the response data
      return handler.next(response); // continue with the response
    },
    onError: (DioError e, ErrorInterceptorHandler handler) {
      // Handle errors
      return handler.next(e);
    },
  ));
  dio.options.baseUrl= '$url/';
  dio.options.headers['accept'] = 'Application/Json';
  return dio;
}

