import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FamilyMemberFormController extends GetxController {
  // Text values as observables
  final firstName = ''.obs;
  final mobile = ''.obs;
  final relation = ''.obs;

  // Controllers
  late TextEditingController firstNameController;
  late TextEditingController mobileController;
  late TextEditingController relationController;
  
  // Form state
  final formKey = GlobalKey<FormState>();
  final isFormValid = false.obs;
  final profilePicture = RxnString();
  final photos = <String>[].obs;

  // Image picker
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    print('[FamilyMemberFormController] onInit called');
    _initializeControllers();
    _setupListeners();
  }

  void _initializeControllers() {
    print('[FamilyMemberFormController] Initializing controllers');
    firstNameController = TextEditingController()
      ..addListener(() {
        firstName.value = firstNameController.text;
        validateForm();
      });
    
    mobileController = TextEditingController()
      ..addListener(() {
        mobile.value = mobileController.text;
        validateForm();
      });
    
    relationController = TextEditingController()
      ..addListener(() {
        relation.value = relationController.text;
        validateForm();
      });
  }

  void _setupListeners() {
    print('[FamilyMemberFormController] Setting up listeners');
    ever(firstName, (_) => validateForm());
    ever(mobile, (_) => validateForm());
    ever(relation, (_) => validateForm());
  }

  Future<void> pickProfilePicture() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        profilePicture.value = image.path;
      }
    } catch (e) {
      print('Error picking profile picture: $e');
      Get.snackbar(
        'Error',
        'Failed to pick profile picture',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickPhotos() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        photos.addAll(images.map((image) => image.path));
      }
    } catch (e) {
      print('Error picking photos: $e');
      Get.snackbar(
        'Error',
        'Failed to pick photos',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < photos.length) {
      photos.removeAt(index);
    }
  }

  void validateForm() {
    print('[FamilyMemberFormController] Validating form');
    final isValid = firstName.value.isNotEmpty &&
                    mobile.value.length == 10 &&
                    relation.value.isNotEmpty;
    print('[FamilyMemberFormController] Form valid: $isValid');
    isFormValid.value = isValid;
  }

  void clear() {
    print('[FamilyMemberFormController] Clearing form');
    firstNameController.clear();
    mobileController.clear();
    relationController.clear();
    firstName.value = '';
    mobile.value = '';
    relation.value = '';
    profilePicture.value = null;
    photos.clear();
    isFormValid.value = false;
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstName.value,
    'mobile': mobile.value,
    'relation': relation.value,
    'profilePicture': profilePicture.value,
    'photos': photos.toList(),
  };

  @override
  void onClose() {
    print('[FamilyMemberFormController] onClose called');
    firstNameController.dispose();
    mobileController.dispose();
    relationController.dispose();
    super.onClose();
  }
} 