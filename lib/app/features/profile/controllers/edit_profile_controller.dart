import 'dart:io';
import 'package:famtreeflutter/app/core/values/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/pending_member_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/register_member_model.dart';
import '../../../data/models/verify_family_code_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/s3_service.dart';

class EditProfileController extends GetxController {
  final ImageUploadService _imageUploadService = Get.find<ImageUploadService>();
  final formKey = GlobalKey<FormState>();
  
  // Personal Information
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final occupationController = TextEditingController();
  final educationController = TextEditingController();
  final selectedGender = 'MALE'.obs;
  final maritalStatus = 'MARRIED'.obs;
  
  // Family Information
  final familyNameController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  
  // Profile Pictures
  final profilePicture = ''.obs;
  final photos = <String>[].obs;

  // Expandable sections
  final isBasicInfoExpanded = true.obs;
  final isContactInfoExpanded = false.obs;
  final isFamilyInfoExpanded = false.obs;
  final isPhotosExpanded = false.obs;

  // Add back pending members section
  final isPendingMembersExpanded = false.obs;
  final pendingMembers = <PendingMember>[].obs;
  final isLoadingMembers = false.obs;
  final _apiClient = Get.find<ApiClient>();
  final isLoading = false.obs;

  // Profile image
  final profileImageUrl = ''.obs;
  
  // Family photos
  final familyPhotos = <String>[].obs;
  
  // S3 Service


  @override
  void onInit() async {
    super.onInit();
    // Ensure ImageUploadService is available
    if (!Get.isRegistered<ImageUploadService>()) {
      await Get.putAsync<ImageUploadService>(() => ImageUploadService.init());
    }
    loadUserData();
    debugPrint('🚀 Initializing EditProfileController');
    await fetchPendingMembers(); // Fetch pending members on initialization
  }

  void loadUserData() {
    // TODO: Replace with actual API data
    firstNameController.text = 'Pendkar';
    lastNameController.text = 'Shankar';
    emailController.text = 'pendkarshankar@gmail.com';
    mobileController.text = '9059050018';
    dobController.text = '1980-01-01';
    occupationController.text = 'Business';
    educationController.text = 'Graduate';
    selectedGender.value = 'MALE';
    maritalStatus.value = 'MARRIED';
    
    familyNameController.text = 'Pendkar';
    addressController.text = 'RamaRaoBagh Colony';
    descriptionController.text = 'Good Family';
    
    profilePicture.value = 'http://example.com/profile.jpg';
    photos.value = [
      'http://example.com/photo1.jpg',
      'http://example.com/photo2.jpg'
    ];

    // Sample profile image URL
    profileImageUrl.value = '';
    
    // Sample family photos
    familyPhotos.value = [];
  }

  Future<void> updateProfile() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        // TODO: Implement API call to update profile
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> saveProfile() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        
        // TODO: Implement API call to save profile data
        // For now, just use the existing updateProfile method
        await updateProfile();
        
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update profile: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void togglePendingMembers() {
    debugPrint('⚡ Toggle called, current state: ${isPendingMembersExpanded.value}');
    isPendingMembersExpanded.value = !isPendingMembersExpanded.value;
    debugPrint(isPendingMembersExpanded.value ? '📂 Section expanded' : '📁 Section collapsed');
  }

  Future<void> fetchPendingMembers() async {
    debugPrint('⭐ Starting to fetch pending members');
    
    try {
      isLoadingMembers.value = true;
      debugPrint('🔄 Set loading state to true');

      final response = await _apiClient.getRequest<PendingMembersResponse>(
        endpoint: '${ApiConstants.apiVersion}${ApiConstants.pendingMembers}',
        fromJson: (json) {
          debugPrint('📦 Got response: $json');
          return PendingMembersResponse.fromJson(json);
        },
      );
      
      if (response.success && response.data != null) {
        pendingMembers.value = response.data!.data;
        debugPrint('✅ Successfully loaded ${pendingMembers.length} members');
      } else {
        throw Exception(response.error ?? 'Failed to load members');
      }
    } catch (e) {
      debugPrint('❌ Error fetching members: $e');
      Get.snackbar(
        'Error',
        'Failed to load pending members',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMembers.value = false;
      debugPrint('🔄 Set loading state to false');
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
        pendingMembers.removeWhere((member) => member.verificationCode == verificationCode);
        Get.snackbar('Success', 'Member approved successfully',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint('❌ Error approving member: $e');
      Get.snackbar('Error', 'Failed to approve member',
          snackPosition: SnackPosition.BOTTOM);
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
        pendingMembers.removeWhere((member) => member.memberUid == memberUid);
        Get.snackbar('Success', 'Member rejected',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      debugPrint('❌ Error rejecting member: $e');
      Get.snackbar('Error', 'Failed to reject member',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> registerMember(RegisterMemberRequest request) async {
    try {
      final response = await _apiClient.postRequest(
        endpoint: '${ApiConstants.apiVersion}${ApiConstants.members}/register',
        data: request.toJson(),
        fromJson: (json) => json,
      );
      
      if (response.success) {
        Get.back();
        Get.snackbar(
          'Success',
          'Member registered successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchPendingMembers(); // Refresh the list
      } else {
        throw Exception(response.error ?? 'Failed to register member');
      }
    } catch (e) {
      debugPrint('❌ Error registering member: $e');
      Get.snackbar(
        'Error',
        'Failed to register member',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> verifyFamilyCode(VerifyFamilyCodeRequest request) async {
    try {
      isLoading.value = true;
      final response = await _apiClient.postRequest(
        endpoint: '${ApiConstants.apiVersion}${ApiConstants.members}/verify-family-code',
        data: request.toJson(),
        fromJson: (json) => json,
      );
      
      if (response.success) {
        return true;
      } else {
        if (response.error?.contains('401') ?? false) {
          await Get.find<StorageService>().logout();
          return false;
        }
        throw Exception(response.error ?? 'Verification failed');
      }
    } catch (e) {
      debugPrint('❌ Error verifying family code: $e');
      if (e.toString().contains('401')) {
        await Get.find<StorageService>().logout();
      } else {
        Get.snackbar(
          'Error',
          'Failed to verify family code',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfileImage(String url) {
    if (url.isNotEmpty) {
      profileImageUrl.value = url;
    }
  }

  Future<void> addFamilyPhoto(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        final response = await _imageUploadService.uploadImage(
          File(image.path),
          category: 'FAMILY_PHOTO'
        );
        familyPhotos.add(response.url);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add family photo: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  void removeFamilyPhoto(int index) {
    if (index >= 0 && index < familyPhotos.length) {
      familyPhotos.removeAt(index);
    }
  }
  
  void selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Start at 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      final response = await _imageUploadService.uploadImage(
        imageFile,
        category: 'PROFILE_PICTURE'
      );
      updateProfileImage(response.url);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload profile picture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dobController.dispose();
    occupationController.dispose();
    educationController.dispose();
    familyNameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
} 