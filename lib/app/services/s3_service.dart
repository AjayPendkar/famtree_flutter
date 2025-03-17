import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'dart:developer' as dev;
import '../core/services/storage_service.dart';
import '../core/values/api_constants.dart';

class ImageResponse {
  final String fileName;
  final int size;
  final String type;
  final String category;
  final String url;

  ImageResponse({
    required this.fileName,
    required this.size,
    required this.type,
    required this.category,
    required this.url,
  });

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(
      fileName: json['fileName'] as String,
      size: json['size'] as int,
      type: json['type'] as String,
      category: json['category'] as String,
      url: json['url'] as String,
    );
  }
}

class ImageUploadService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  // Add a static init method for easier initialization
  static Future<ImageUploadService> init() async {
    return ImageUploadService();
  }

  Future<ImageResponse> uploadImage(
    File imageFile, {
    String category = 'PROFILE_PICTURE',
    String? userId,
  }) async {
    try {
      dev.log('Starting image upload process for file: ${imageFile.path}');
      
      // Get auth token
      final token = _storageService.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final userUuid = _storageService.getUserUuid();
      if (userUuid == null) {
        throw Exception('User UUID not found');
      }

      // Create multipart request
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.apiVersion}/images/upload');
      var request = http.MultipartRequest('POST', url);
      
      // Add headers
      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add file to request
      final file = await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      );
      request.files.add(file);

      // Add fields
      request.fields['category'] = category;
      request.fields['userId'] = userUuid;

      dev.log('Sending upload request to: $url');
      dev.log('Category: $category');
      dev.log('UserId: $userUuid');
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      dev.log('Upload response status code: ${response.statusCode}');
      dev.log('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to upload image: Status ${response.statusCode}\nResponse: ${response.body}');
      }

      // Parse response
      final jsonResponse = jsonDecode(response.body);
      
      if (jsonResponse['status'] != 200 || jsonResponse['data'] == null) {
        throw Exception('Invalid response format: ${response.body}');
      }

      final imageResponse = ImageResponse.fromJson(jsonResponse['data']);
      dev.log('Successfully uploaded file. URL: ${imageResponse.url}');
      
      return imageResponse;

    } catch (e, stackTrace) {
      dev.log('❌ ERROR UPLOADING IMAGE ❌', error: e, stackTrace: stackTrace);
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      
      if (e is SocketException) {
        throw Exception('Network error: Check your internet connection');
      } else if (e is HttpException) {
        throw Exception('HTTP error: Invalid request');
      } else if (e is FormatException) {
        throw Exception('Format error: Invalid response format');
      }
      
      rethrow;
    }
  }
} 