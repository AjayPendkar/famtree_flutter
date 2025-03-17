import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:famtreeflutter/app/core/utils/api_response.dart';
import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import 'dart:developer' as dev;
import '../values/api_constants.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ApiClient {
  final dio.Dio _dio;
  final StorageService _storageService;

  ApiClient(this._dio, this._storageService) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: _handleRequest,
      onResponse: _handleResponse,
      onError: _handleError,
    ));
  }

  Future<ApiResponse<T>> getRequest<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      debugPrint('🌐 Making GET request to: ${_dio.options.baseUrl}$endpoint');
      debugPrint('🔑 Headers: ${_dio.options.headers}');
      
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      
      debugPrint('📥 Raw response: ${response.data}');
      return ApiResponse.fromJson(response.data, fromJson);
    } catch (e, stackTrace) {
      debugPrint('❌ GET request failed: $e');
      debugPrint('🔍 Stack trace: $stackTrace');
      return ApiResponse(success: false, error: e.toString());
    }
  }

  Future<ApiResponse<T>> postRequest<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      debugPrint('\x1B[31m🌐 POST Request: ${_dio.options.baseUrl}$endpoint\x1B[0m');
      debugPrint('\x1B[31mRequest Data: $data\x1B[0m');
      
      final response = await _dio.post(endpoint, data: data);
      
      debugPrint('\x1B[32m📥 POST Response: ${response.data}\x1B[0m');
      return ApiResponse.fromJson(response.data, fromJson);
    } catch (e) {
      debugPrint('\x1B[31m❌ POST Error: $e\x1B[0m');
      return ApiResponse(success: false, error: e.toString());
    }
  }

  Future<ApiResponse<T>> putRequest<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return ApiResponse.fromJson(response.data, fromJson);
    } catch (e) {
      debugPrint('PUT Error: $e');
      return ApiResponse(success: false, error: e.toString());
    }
  }

  Future<ApiResponse<void>> deleteRequest({
    required String endpoint,
  }) async {
    try {
      await _dio.delete(endpoint);
      return ApiResponse(success: true);
    } catch (e) {
      debugPrint('DELETE Error: $e');
      return ApiResponse(success: false, error: e.toString());
    }
  }

  void _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    print('\n🚀 REQUEST DETAILS:');
    print('URL: ${options.baseUrl}${options.path}');
    print('Method: ${options.method}');
    print('Headers: ${options.headers}');
    print('Query Parameters: ${options.queryParameters}');
    print('Request Data: ${options.data}');
    print('------------------------\n');

    final token = _storageService.getToken();
    debugPrint('🔑 Token for request: ${token?.substring(0, 20)}...');
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      debugPrint('⚠️ No token found for request');
    }
    
    debugPrint('🌐 Request URL: ${options.baseUrl}${options.path}');
    debugPrint('🔒 Headers: ${options.headers}');
    
    handler.next(options);
  }

  void _handleResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    print('\n✅ RESPONSE DETAILS:');
    print('Status Code: ${response.statusCode}');
    print('Response Data: ${response.data}');
    print('------------------------\n');

    debugPrint('Response: ${response.data}');
    handler.next(response);
  }

  void _handleError(
    dio.DioException error,
    dio.ErrorInterceptorHandler handler,
  ) {
    print('\n❌ ERROR DETAILS:');
    print('Error Type: ${error.type}');
    print('Error Message: ${error.message}');
    print('Error Response: ${error.response?.data}');
    print('Status Code: ${error.response?.statusCode}');
    print('------------------------\n');

    if (error.response?.statusCode == 401) {
      debugPrint('🚫 Unauthorized request - Token expired');
      _handleUnauthorized();
    }
    handler.next(error);
  }

  void _handleUnauthorized() async {
    try {
      await _storageService.logout();
      Get.snackbar(
        'Session Expired',
        'Please login again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('❌ Error during logout: $e');
    }
  }

  void _handleUnauthorizedResponse() {
    debugPrint('🔒 Unauthorized response detected, logging out...');
    Get.find<StorageService>().logout();
  }
} 
  