import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LocaleService extends GetxService {
  GetStorage? _storage;
  final locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    _initStorage();
    loadSavedLocale();
  }

  void _initStorage() {
    try {
      _storage = GetStorage();
    } catch (e) {
      debugPrint('Failed to initialize storage: $e');
    }
  }

  void loadSavedLocale() {
    try {
      final savedLanguage = _storage?.read('language') ?? 'English';
      updateLocale(savedLanguage);
    } catch (e) {
      debugPrint('Error loading locale: $e');
      // Use default locale on error
      updateLocale('English');
    }
  }

  void updateLocale(String language) {
    switch (language) {
      case 'Hindi':
        locale.value = const Locale('hi', 'IN');
        break;
      case 'Telugu':
        locale.value = const Locale('te', 'IN');
        break;
      default:
        locale.value = const Locale('en', 'US');
    }
    Get.updateLocale(locale.value);
  }

  void changeLanguage(String language) {
    try {
      _storage?.write('language', language);
      updateLocale(language);
    } catch (e) {
      debugPrint('Error saving language: $e');
      // Still update the UI even if storage fails
      updateLocale(language);
    }
  }
} 