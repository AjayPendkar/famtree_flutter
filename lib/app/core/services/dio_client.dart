import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../values/api_constants.dart';

class DioClient {
  late Dio _dio;
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        responseType: ResponseType.json,
      ),
    )..interceptors.add(LoggingInterceptor());
  }

  Dio get dio => _dio;
}

class LoggingInterceptor extends Interceptor {
  // ANSI escape codes for colors
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _reset = '\x1B[0m';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('$_red┌────── Request ──────>');
      print('$_red│ ${options.method} ${options.uri}');
      print('$_red│ Headers: ${options.headers}');
      print('$_red│ Data: ${options.data}');
      print('$_red└────── End Request ──────>$_reset');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('$_green┌────── Response ──────>');
      print('$_green│ ${response.statusCode} ${response.requestOptions.uri}');
      print('$_green│ Data: ${response.data}');
      print('$_green└────── End Response ──────>$_reset');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('$_red┌────── Error ──────>');
      print('$_red│ ${err.response?.statusCode} ${err.requestOptions.uri}');
      print('$_red│ ${err.message}');
      print('$_red│ ${err.response?.data}');
      print('$_red└────── End Error ──────>$_reset');
    }
    return super.onError(err, handler);
  }
} 