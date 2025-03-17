import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/family_member_form.dart';

class AuthController extends GetxController with StateMixin {
  static AuthController get to => Get.find();
  
  // Make controller permanent
  @override
  bool get permanent => true;

  final _authRepository = AuthRepository();
  final loginFormKey = GlobalKey<FormState>();
  final newUserFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  
  // Regular TextEditingControllers
  late TextEditingController mobileController;
  late TextEditingController otpController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController familyNameController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  late TextEditingController dobController;
  late TextEditingController occupationController;
  late TextEditingController educationController;

  // Family Head Details
  late TextEditingController headFirstNameController;
  late TextEditingController headLastNameController;
  late TextEditingController headEmailController;
  late TextEditingController headMobileController;
  late TextEditingController headDobController;
  late TextEditingController headOccupationController;
  late TextEditingController headEducationController;

  // OTP verification
  final selectedRole = 'MEMBER'.obs;
  final selectedGender = 'MALE'.obs;
  final maritalStatus = 'SINGLE'.obs;

  // Registration step fields
  final currentStep = 0.obs;
  final familyFormKey = GlobalKey<FormState>();
  final headFormKey = GlobalKey<FormState>();
  final selectedMaritalStatus = 'SINGLE'.obs;
  final memberForms = <FamilyMemberFormController>[].obs;

  // Form validation status
  final isFamilyDetailsValid = false.obs;
  final isHeadDetailsValid = false.obs;
  final isMembersValid = false.obs;

  // Store form data
  final familyDetails = RxMap<String, dynamic>();
  final headDetails = RxMap<String, dynamic>();
  final membersDetails = RxList<Map<String, dynamic>>();

  // Add a variable to store mobile temporarily
  String? _tempMobile;

  // Form keys for each step
  final membersFormKey = GlobalKey<FormState>();

  // Observable values for dropdowns
  final headGender = 'MALE'.obs;
  final headMaritalStatus = 'SINGLE'.obs;
  
  // Profile pictures and photos
  final headProfilePicture = Rxn<String>();
  final headPhotos = <String>[].obs;

  @override
  void onInit() {
    print('[AuthController] onInit called');
    super.onInit();
    ever(currentStep, (int step) {
      print('[AuthController] Step changed to: $step');
      // Restore data when step changes
      if (step == 0) {
        print('[AuthController] Restoring family details for step 0');
        restoreFamilyDetails();
      } else if (step == 1) {
        print('[AuthController] Restoring head details for step 1');
        restoreHeadDetails();
      }
    });
    _initializeControllers();
    // Initialize empty maps for form data
    if (familyDetails.isEmpty) {
      print('[AuthController] Initializing empty family details');
      familyDetails.value = {};
    }
    if (headDetails.isEmpty) {
      print('[AuthController] Initializing empty head details');
      headDetails.value = {};
    }
    if (membersDetails.isEmpty) {
      print('[AuthController] Initializing empty members details');
      membersDetails.value = [];
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Restore form data if available
    restoreFamilyDetails();
    restoreHeadDetails();
  }

  void _initializeControllers() {
    // Initialize all controllers
    mobileController = TextEditingController();
    otpController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    familyNameController = TextEditingController();
    addressController = TextEditingController();
    descriptionController = TextEditingController();
    dobController = TextEditingController();
    occupationController = TextEditingController();
    educationController = TextEditingController();

    // Initialize head details controllers
    headFirstNameController = TextEditingController();
    headLastNameController = TextEditingController();
    headEmailController = TextEditingController();
    headMobileController = TextEditingController();
    headDobController = TextEditingController();
    headOccupationController = TextEditingController();
    headEducationController = TextEditingController();
  }

  @override
  void onClose() {
    print('[AuthController] onClose called, permanent: $permanent');
    if (!permanent) {
      print('[AuthController] Disposing controllers');
      // Dispose all controllers
      mobileController.dispose();
      otpController.dispose();
      firstNameController.dispose();
      lastNameController.dispose();
      emailController.dispose();
      familyNameController.dispose();
      addressController.dispose();
      descriptionController.dispose();
      dobController.dispose();
      occupationController.dispose();
      educationController.dispose();

      // Dispose head details controllers
      headFirstNameController.dispose();
      headLastNameController.dispose();
      headEmailController.dispose();
      headMobileController.dispose();
      headDobController.dispose();
      headOccupationController.dispose();
      headEducationController.dispose();

      // Dispose all member forms
      for (var i = 0; i < memberForms.length; i++) {
        Get.delete<FamilyMemberFormController>(tag: 'member_$i');
      }
      memberForms.clear();
    }
    super.onClose();
  }

  // Method to clear all fields
  void clearFields() {
    print('[AuthController] clearFields called');
    // Clear all member forms first
    for (var i = 0; i < memberForms.length; i++) {
      print('[AuthController] Removing member form at index $i');
      Get.delete<FamilyMemberFormController>(tag: 'member_$i');
    }
    memberForms.clear();

    print('[AuthController] Clearing all text controllers');
    // Clear other controllers
    mobileController.text = '';
    otpController.text = '';
    firstNameController.text = '';
    lastNameController.text = '';
    emailController.text = '';
    familyNameController.text = '';
    addressController.text = '';
    descriptionController.text = '';
    dobController.text = '';
    occupationController.text = '';
    educationController.text = '';
    
    print('[AuthController] Clearing stored form data');
    // Clear stored form data
    familyDetails.clear();
    headDetails.clear();
    membersDetails.clear();
    
    print('[AuthController] Resetting validation status');
    // Reset validation status
    isFamilyDetailsValid.value = false;
    isHeadDetailsValid.value = false;
    isMembersValid.value = false;
    
    print('[AuthController] Resetting current step to 0');
    // Reset current step
    currentStep.value = 0;
  }

  // Login with OTP
  Future<void> login() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        final mobile = mobileController.text.trim();
        
        // First check if the mobile number exists
        final checkResponse = await _authRepository.checkMobileExists(mobile);
        
        if (checkResponse.success) {
          if (checkResponse.data == true) {
            // Mobile exists, send OTP
            final response = await _authRepository.sendOtp({
              'mobile': mobile,
            });
            
            if (response.success && response.data != null) {
              _tempMobile = mobile;
              clearMobile();
              Get.toNamed(Routes.VERIFY_OTP, arguments: {
                'mobile': _tempMobile,
                'otp': response.data?.otp ?? '',
              });
            } else {
              Get.snackbar(
                'Error',
                response.error ?? 'Failed to send OTP',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          } else {
            // Mobile doesn't exist, go to registration
            _tempMobile = mobile;
            // clearMobile();
            Get.toNamed(Routes.NEW_USER, arguments: {
              'mobile': _tempMobile,
            });
          }
        } else {
          // Error checking mobile
          Get.snackbar(
            'Error',
            checkResponse.error ?? 'Failed to check mobile number',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Verify OTP
  Future<void> verifyOtp() async {
    if (otpFormKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        final response = await _authRepository.verifyOtp({
          'mobile': _tempMobile ?? '',
          'otp': otpController.text,
        });

        if (response.success && response.data != null) {
          final token = response.data?.token;
          if (token != null) {
            await Get.find<StorageService>().saveToken(token);
            
            if (Get.previousRoute == Routes.LOGIN) {
              clearFields();
              Get.offAllNamed(Routes.HOME);
            } else if (Get.previousRoute == Routes.NEW_USER) {
              clearOtp(); // Only clear OTP, keep other fields
              Get.offAllNamed(Routes.REGISTRATION);
            } else {
              clearFields();
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.snackbar(
              'Error',
              'Invalid response from server',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            response.error ?? 'Verification failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Register new user
  // Future<void> register() async {
  //   if (newUserFormKey.currentState?.validate() ?? false) {
  //     try {
  //       isLoading.value = true;
  //       final response = await _authRepository.register({
  //         'firstName': firstNameController.text,
  //         'lastName': lastNameController.text,
  //         'email': emailController.text,
  //         'mobile': mobileController.text,
  //         'familyName': familyNameController.text,
  //         'address': addressController.text,
  //         'description': descriptionController.text,
  //         'gender': selectedGender.value,
  //         'maritalStatus': maritalStatus.value,
  //         'role': selectedRole.value,
  //       });

  //       if (response.success && response.data != null) {
  //         // Navigate to home after successful registration
  //         Get.offAllNamed(Routes.HOME);
  //       } else {
  //         throw Exception(response.error ?? 'Registration failed');
  //       }
  //     } catch (e) {
  //       Get.snackbar(
  //         'Error',
  //         'Registration failed',
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }
  // }

  void nextStep() {
    print('[AuthController] nextStep called, current step: ${currentStep.value}');
    
    if (currentStep.value == 0) {
      print('[AuthController] Validating family form');
      if (familyFormKey.currentState?.validate() ?? false) {
        print('[AuthController] Family form validation successful');
        // Save family details without clearing
        final details = {
          'familyName': familyNameController.text.trim(),
          'address': addressController.text.trim(),
          'description': descriptionController.text.trim(),
        };
        print('[AuthController] Saving family details: $details');
        familyDetails.value = details;
        isFamilyDetailsValid.value = true;
        currentStep.value++;
        print('[AuthController] Moved to step ${currentStep.value}');
        return;
      } else {
        print('[AuthController] Family form validation failed');
      }
    } else if (currentStep.value == 1) {
      print('[AuthController] Validating head form');
      if (headFormKey.currentState?.validate() ?? false) {
        print('[AuthController] Head form validation successful');
        // Save head details without clearing
        final details = {
          'firstName': headFirstNameController.text.trim(),
          'lastName': headLastNameController.text.trim(),
          'email': headEmailController.text.trim(),
          'mobile': headMobileController.text.trim(),
          'dateOfBirth': headDobController.text.trim(),
          'occupation': headOccupationController.text.trim(),
          'education': headEducationController.text.trim(),
          'gender': headGender.value,
          'maritalStatus': headMaritalStatus.value,
        };
        print('[AuthController] Saving head details: $details');
        headDetails.value = details;
        isHeadDetailsValid.value = true;
        currentStep.value++;
        print('[AuthController] Moved to step ${currentStep.value}');
        return;
      } else {
        print('[AuthController] Head form validation failed');
      }
    } else if (currentStep.value == 2) {
      print('[AuthController] Validating member forms');
      if (validateMemberForms()) {
        print('[AuthController] Member forms validation successful');
        saveMemberForms();
        isMembersValid.value = true;
        print('[AuthController] Members data saved');
        return;
      } else {
        print('[AuthController] Member forms validation failed');
      }
    }
  }

  bool validateMemberForms() {
    if (memberForms.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one family member',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    for (final form in memberForms) {
      if (!form.isFormValid.value) {
        Get.snackbar(
          'Error',
          'Please fill all required fields for family members',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }
    return true;
  }

  void saveMemberForms() {
    membersDetails.value = memberForms.map((form) => form.toJson()).toList();
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      
      // Restore form data when going back
      if (currentStep.value == 0) {
        restoreFamilyDetails();
      } else if (currentStep.value == 1) {
        restoreHeadDetails();
      }
    }
  }

  void restoreFamilyDetails() {
    print('[AuthController] Attempting to restore family details');
    if (familyDetails.isNotEmpty) {
      print('[AuthController] Found family details to restore: ${familyDetails.value}');
      familyNameController.text = familyDetails['familyName'] ?? '';
      addressController.text = familyDetails['address'] ?? '';
      descriptionController.text = familyDetails['description'] ?? '';
      print('[AuthController] Family details restored to controllers');
    } else {
      print('[AuthController] No family details found to restore');
    }
  }

  void restoreHeadDetails() {
    print('[AuthController] Attempting to restore head details');
    if (headDetails.isNotEmpty) {
      print('[AuthController] Found head details to restore: ${headDetails.value}');
      headFirstNameController.text = headDetails['firstName'] ?? '';
      headLastNameController.text = headDetails['lastName'] ?? '';
      headEmailController.text = headDetails['email'] ?? '';
      headMobileController.text = headDetails['mobile'] ?? '';
      headDobController.text = headDetails['dateOfBirth'] ?? '';
      headOccupationController.text = headDetails['occupation'] ?? '';
      headEducationController.text = headDetails['education'] ?? '';
      headGender.value = headDetails['gender'] ?? 'MALE';
      headMaritalStatus.value = headDetails['maritalStatus'] ?? 'SINGLE';
      print('[AuthController] Head details restored to controllers');
    } else {
      print('[AuthController] No head details found to restore');
    }
  }

  void addMember() {
    final form = FamilyMemberFormController();
    final tag = 'member_${memberForms.length}';
    Get.put(form, tag: tag);
    memberForms.add(form);
  }

  void removeMember(int index) {
    if (index >= 0 && index < memberForms.length) {
      final tag = 'member_$index';
      Get.delete<FamilyMemberFormController>(tag: tag);
      memberForms.removeAt(index);
      
      // Update tags for remaining forms
      for (var i = index; i < memberForms.length; i++) {
        final oldTag = 'member_${i + 1}';
        final newTag = 'member_$i';
        final form = memberForms[i];
        
        Get.delete<FamilyMemberFormController>(tag: oldTag);
        Get.put(form, tag: newTag);
      }
    }
  }

  // Method to clear OTP
  void clearOtp() {
    otpController.clear();
  }

  // Method to clear mobile number
  void clearMobile() {
    mobileController.clear();
  }

  // Register method for new user
  Future<void> registerNewUser() async {
    if (!newUserFormKey.currentState!.validate()) return;
    
    try {
      isLoading.value = true;
      
      // Debug: Print values before sending
      print('Registering new user with:');
      print('Mobile: ${mobileController.text}');
      print('Family Name: ${familyNameController.text}');
      print('Role: ${selectedRole.value}');
      
      // Ensure mobile number is not empty
      if (mobileController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Mobile number is required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      final response = await _authRepository.sendOtp({
        'mobile': mobileController.text.trim(),
        'role': selectedRole.value,
        'familyName': familyNameController.text.trim(),
      });
      
      if (response.success && response.data != null) {
        _tempMobile = mobileController.text.trim();
        
        Get.toNamed(
          Routes.VERIFY_OTP,
          arguments: {
            'mobile': mobileController.text.trim(),
            'otp': response.data!.otp,
          },
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to send OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to register: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeRegistration() async {
    if (currentStep.value != 2) return;
    
    try {
      isLoading.value = true;

      // Prepare family head data
      final familyHead = {
        'firstName': headFirstNameController.text.trim(),
        'lastName': headLastNameController.text.trim(),
        'email': headEmailController.text.trim(),
        'mobile': headMobileController.text.trim(),
        'dateOfBirth': headDobController.text.trim(),
        'occupation': headOccupationController.text.trim(),
        'education': headEducationController.text.trim(),
        'gender': headGender.value,
        'maritalStatus': headMaritalStatus.value,
  
        'isVerified': true,
        if (headProfilePicture.value != null) 'profilePicture': headProfilePicture.value,
        if (headPhotos.isNotEmpty) 'photos': headPhotos,
      };

      // Prepare members data
      final members = memberForms.map((form) => {
        'firstName': form.firstNameController.value.text.trim(),
        'mobile': form.mobileController.value.text.trim(),
        'relation': form.relationController.value.text.trim(),
        'profilePicture': form.profilePicture.value,
        'photos': form.photos,
      }).toList();

      // Prepare registration data
      final registrationData = {
        'familyName': familyNameController.text.trim(),
        'address': addressController.text.trim(),
        'description': descriptionController.text.trim(),
        'memberCount': members.length + 1, // Including head
        'isBlocked': false,
        'familyHead': familyHead,
        'members': members,
      };

      final response = await _authRepository.completeRegistration(registrationData);
      
      if (response.success) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Registration failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
      headDobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      final response = await _authRepository.sendOtp({
        'mobile': _tempMobile ?? '',
      });
      
      if (response.success && response.data != null) {
        Get.snackbar(
          'Success',
          'OTP resent successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to resend OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setMobileNumber(String? mobile) {
    if (mobile != null && mobile.isNotEmpty) {
      if (mobileController.text != mobile) {
        mobileController.text = mobile;
      }
    }
  }
} 