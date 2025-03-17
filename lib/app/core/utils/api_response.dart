import 'package:flutter/material.dart';

class ApiResponse<T> {
  final bool success;
  final String? error;
  final T? data;

  ApiResponse({
    required this.success,
    this.error,
    this.data,
  });

  ApiResponse.success(this.data) : success = true, error = null;
  ApiResponse.error(this.error) : success = false, data = null;

  factory ApiResponse.fromJson(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      if (json is Map<String, dynamic>) {
        return ApiResponse<T>(
          success: json['success'] ?? true,
          error: json['error'],
          data: fromJson(json),
        );
      }
      
      return ApiResponse<T>(
        success: true,
        data: fromJson({'data': json}),
      );
    } catch (e) {
      debugPrint('❌ Error parsing response: $e');
      return ApiResponse<T>(
        success: false,
        error: 'Failed to parse response: $e',
      );
    }
  }

  bool get hasData => data != null;
} 