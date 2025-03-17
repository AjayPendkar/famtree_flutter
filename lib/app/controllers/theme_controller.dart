import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/local/storage_service.dart';

class ThemeController extends GetxController {
  final _storageService = Get.find<StorageService>();
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  void loadThemeMode() {
    final savedMode = _storageService.getThemeMode();
    isDarkMode.value = savedMode ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storageService.saveThemeMode(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
} 