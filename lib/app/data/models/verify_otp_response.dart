import '../../core/utils/json_helper.dart';
import 'dart:developer' as dev;

class VerifyOtpResponse {
  final String message;
  final String token;
  final String otp;
  final String role;
  final String familyName;
  final bool success;
  final String mobile;

  VerifyOtpResponse({
    required this.message,
    required this.token,
    required this.otp,
    required this.role,
    required this.familyName,
    required this.success,
    required this.mobile,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] as Map<String, dynamic>? ?? json;
      return VerifyOtpResponse(
        message: JsonHelper.asString(data['message']) ?? '',
        token: JsonHelper.asString(data['token']) ?? '',
        otp: JsonHelper.asString(data['otp']) ?? '',
        role: JsonHelper.asString(data['role']) ?? '',
        familyName: JsonHelper.asString(data['familyName']) ?? '',
        success: JsonHelper.asBool(data['success']),
        mobile: JsonHelper.asString(data['mobile']) ?? '',
      );
    } catch (e) {
      dev.log('Error parsing VerifyOtpResponse: $e');
      dev.log('Response JSON: $json');
      throw e;
    }
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'token': token,
    'otp': otp,
    'role': role,
    'familyName': familyName,
    'success': success,
    'mobile': mobile,
  };
} 