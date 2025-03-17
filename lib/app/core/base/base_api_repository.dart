import 'package:dio/dio.dart';
import '../services/dio_client.dart';
import '../utils/api_response.dart';

class BaseApiRepository {
  final Dio _dio = DioClient().dio;

  Future<ApiResponse<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final response = await apiCall();
      return ApiResponse.success(response);
    } on DioException catch (e) {
      return ApiResponse.error(_handleDioError(e));
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<T>> getRequest<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return fromJson(response.data);
    });
  }

  Future<ApiResponse<T>> postRequest<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.post(
        endpoint, 
        data: data,
        options: Options(headers: headers),
      );
      return fromJson(response.data);
    });
  }

  Future<ApiResponse<T>> putRequest<T>({
    required String endpoint,
    required Map<String, dynamic> data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    return safeApiCall(() async {
      final response = await _dio.put(endpoint, data: data);
      return fromJson(response.data);
    });
  }

  Future<ApiResponse<void>> deleteRequest({
    required String endpoint,
  }) async {
    return safeApiCall(() async {
      await _dio.delete(endpoint);
      return;
    });
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      default:
        return e.message ?? 'Something went wrong';
    }
  }

  String _handleBadResponse(Response? response) {
    if (response?.data is Map) {
      return response?.data['message'] ?? 'Server error ${response?.statusCode}';
    }
    return 'Server error ${response?.statusCode}';
  }
} 