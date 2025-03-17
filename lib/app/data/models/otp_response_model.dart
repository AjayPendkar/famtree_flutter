import '../../core/utils/json_helper.dart';

class OtpResponseModel {
  final String? message;
  final String? otp;
  final String? role;
  final String? familyName;
  final bool success;
  final String? mobile;
  final int status;

  OtpResponseModel({
    this.message,
    this.otp,
    this.role,
    this.familyName,
    required this.success,
    this.mobile,
    required this.status,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    return OtpResponseModel(
      message: data['message'] as String?,
      otp: data['otp'] as String?,
      role: data['role'] as String?,
      familyName: data['familyName'] as String?,
      success: data['success'] as bool? ?? false,
      mobile: data['mobile'] as String?,
      status: json['status'] as int? ?? 400,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'otp': otp,
    'role': role,
    'familyName': familyName,
    'success': success,
    'mobile': mobile,
    'status': status,
  };
} 