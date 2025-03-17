import '../../core/base/base_api_repository.dart';
import '../../core/values/api_constants.dart';
import '../../core/utils/api_response.dart';
import '../models/family_model.dart';

class FamilyRepository extends BaseApiRepository {
  Future<ApiResponse<List<FamilyModel>>> getAllFamilies() async {
    return await getRequest(
      endpoint: ApiConstants.family,
      fromJson: (json) => (json['data'] as List)
          .map((item) => FamilyModel.fromJson(item))
          .toList(),
    );
  }

  Future<ApiResponse<FamilyModel>> createFamily(Map<String, dynamic> data) async {
    return await postRequest(
      endpoint: ApiConstants.family,
      data: data,
      fromJson: (json) => FamilyModel.fromJson(json),
    );
  }

  Future<ApiResponse<FamilyModel>> updateFamily(String id, Map<String, dynamic> data) async {
    return await putRequest(
      endpoint: '${ApiConstants.family}/$id',
      data: data,
      fromJson: (json) => FamilyModel.fromJson(json),
    );
  }

  Future<ApiResponse<void>> deleteFamily(String id) async {
    return await deleteRequest(endpoint: '${ApiConstants.family}/$id');
  }
} 