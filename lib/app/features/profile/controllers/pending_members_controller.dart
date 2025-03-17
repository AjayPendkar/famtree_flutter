import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/values/api_constants.dart';
import '../../../data/models/pending_member_model.dart';

class PendingMembersController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  final isLoading = false.obs;
  final pendingMembers = <PendingMember>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingMembers();
  }

  Future<void> fetchPendingMembers() async {
    try {
      isLoading.value = true;
      final response = await _apiClient.getRequest<PendingMembersResponse>(
        endpoint: '${ApiConstants.apiVersion}${ApiConstants.pendingMembers}',
        fromJson: (json) => PendingMembersResponse.fromJson(json),
      );
      
      if (response.success && response.data != null) {
        pendingMembers.value = response.data!.data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load pending members');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveMember(String verificationCode) async {
    try {
      final response = await _apiClient.postRequest(
        endpoint: '${ApiConstants.apiVersion}${ApiConstants.members}/approve',
        data: {'verificationCode': verificationCode},
        fromJson: (json) => json,
      );
      
      if (response.success) {
        pendingMembers.removeWhere((m) => m.verificationCode == verificationCode);
        Get.snackbar('Success', 'Member approved successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve member');
    }
  }

  Future<void> rejectMember(String memberUid) async {
    try {
      final response = await _apiClient.postRequest(
        endpoint: '${ApiConstants.apiVersion}${ApiConstants.members}/reject',
        data: {'memberUid': memberUid},
        fromJson: (json) => json,
      );
      
      if (response.success) {
        pendingMembers.removeWhere((m) => m.memberUid == memberUid);
        Get.snackbar('Success', 'Member rejected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject member');
    }
  }
} 