import 'package:famtreeflutter/app/core/network/api_client.dart';
import 'package:famtreeflutter/app/core/services/storage_service.dart';
import 'package:famtreeflutter/app/data/models/family_registration_model.dart';
import 'package:get/get.dart';

import '../../core/base/base_api_repository.dart';
import '../../core/values/api_constants.dart';
import '../../core/utils/api_response.dart';
import '../models/user_model.dart';
import '../models/otp_response_model.dart';
import '../models/verify_otp_response.dart';

class AuthRepository extends BaseApiRepository {
  final _apiClient = Get.find<ApiClient>();
  final _storageService = Get.find<StorageService>();

  Future<ApiResponse<OtpResponseModel>> sendOtp(Map<String, dynamic> data) async {
    final endpoint = '${ApiConstants.apiVersion}${ApiConstants.sendOtp}';
    
    // Debug log
    print('Sending OTP request:');
    print('Endpoint: $endpoint');
    print('Data: $data');
    
    try {
      final response = await postRequest(
        endpoint: endpoint,
        data: data,
        fromJson: (json) => OtpResponseModel.fromJson(json),
      );

      if (response.success == true && response.data != null) {
        return response;
      } else {
        return ApiResponse.error(response.error ?? 'Failed to send OTP');
      }
    } catch (e) {
      return ApiResponse.error('An error occurred: $e');
    }
  }

  Future<ApiResponse<VerifyOtpResponse>> verifyOtp(Map<String, dynamic> data) async {
    const endpoint = '${ApiConstants.apiVersion}${ApiConstants.verifyOtp}';
    return await _apiClient.postRequest(
      endpoint: endpoint,
      data: data,
      fromJson: (json) => VerifyOtpResponse.fromJson(json),
    );
  }

  Future<ApiResponse<UserModel>> login(Map<String, dynamic> data) async {
    final endpoint = '${ApiConstants.apiVersion}${ApiConstants.login}';
    return await postRequest(
      endpoint: endpoint,
      data: data,
      fromJson: (json) => UserModel.fromJson(json),
    );
  }

  Future<ApiResponse<FamilyRegistrationResponse>> register(Map<String, dynamic> data) async {
    final endpoint = '${ApiConstants.apiVersion}${ApiConstants.register}';
    return await postRequest(
      endpoint: endpoint,
      data: data,
      fromJson: (json) => FamilyRegistrationResponse.fromJson(json),
    );
  }

  Future<ApiResponse<OtpResponseModel>> loginWithMobile(Map<String, dynamic> data) async {
    const endpoint = '${ApiConstants.apiVersion}/auth/mobile/login/send-otp';
    return await _apiClient.postRequest(
      endpoint: endpoint,
      data: data,
      fromJson: (json) => OtpResponseModel.fromJson(json),
    );
  }

  Future<ApiResponse<dynamic>> completeRegistration(Map<String, dynamic> data) async {
    const endpoint = '${ApiConstants.apiVersion}/families/complete-registration';
    final token = _storageService.getToken();
    
    // Debug: Print API request details
    print('\n=== API Request Details ===');
    print('Endpoint: $endpoint');
    print('Token: $token');
    print('Request Body:');
    data.forEach((key, value) {
      print('$key: $value');
    });
    print('========================\n');
    
    try {
      final response = await postRequest(
        endpoint: endpoint,
        data: data,
        headers: {
          'Authorization': 'Bearer $token',
        },
        fromJson: (json) {
          // Debug: Print API response
          print('\n=== API Response ===');
          print('Status: ${json['status']}');
          print('Message: ${json['message']}');
          print('Data: ${json['data']}');
          print('===================\n');
          return json;
        },
      );
      return response;
    } catch (e) {
      print('\n=== API Error ===');
      print('Error: $e');
      print('================\n');
      rethrow;
    }
  }

  Future<ApiResponse<bool>> checkMobileExists(String mobile) async {
    final endpoint = '${ApiConstants.apiVersion}${ApiConstants.checkUser}/$mobile';
    
    try {
      final response = await getRequest(
        endpoint: endpoint,
        fromJson: (json) => json['exists'] as bool? ?? false,
      );
      
      return response;
    } catch (e) {
      return ApiResponse.error('Failed to check mobile: $e');
    }
  }
} 