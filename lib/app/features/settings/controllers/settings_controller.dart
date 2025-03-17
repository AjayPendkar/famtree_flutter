import 'package:famtreeflutter/app/core/services/locale_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final _storage = GetStorage();
  final _localeService = Get.find<LocaleService>();
  final notificationsEnabled = true.obs;
  final darkModeEnabled = false.obs;
  final twoFactorEnabled = false.obs;
  final selectedLanguage = 'English'.obs;
  final selectedTextSize = 'Medium'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  void loadSavedLanguage() {
    final savedLanguage = _storage.read('language') ?? 'English';
    selectedLanguage.value = savedLanguage;
  }

  void changeLanguage(String? value) {
    if (value != null) {
      selectedLanguage.value = value;
      _localeService.changeLanguage(value);
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    // TODO: Implement notification toggle
  }

  void toggleDarkMode(bool value) {
    darkModeEnabled.value = value;
    // TODO: Implement dark mode toggle
  }

  void toggleTwoFactor(bool value) {
    twoFactorEnabled.value = value;
    // TODO: Implement 2FA toggle
  }

  void changeTextSize(String? value) {
    if (value != null) {
      selectedTextSize.value = value;
      // TODO: Implement text size change
    }
  }

  void handlePrivacySettings() {
    // TODO: Implement privacy settings navigation
  }

  void handleChangePassword() {
    // TODO: Implement password change
  }

  void handleHelpSupport() {
    // TODO: Implement help & support
  }

  void handleAboutApp() {
    // TODO: Implement about app
  }

  void handlePrivacyPolicy() {
    // TODO: Implement privacy policy
  }

  void handleTermsOfService() {
    // TODO: Implement terms of service
  }

  void handleDeleteAccount() {
    Get.dialog(
      AlertDialog(
        title: Text('settings.delete_account'.tr),
        content: Text('settings.delete_confirmation'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
} 