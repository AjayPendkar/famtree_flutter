import 'package:famtreeflutter/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class StorageService {
  static const String TOKEN_KEY = 'auth_token';
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String THEME_MODE = 'theme_mode';
  static const String USER_UUID_KEY = 'user_uuid';
  
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);
  
  Future<void> saveToken(String token) async {
    print('Saving token: $token'); // Debug log
    await _prefs.setString(TOKEN_KEY, token);
    await _prefs.setBool(IS_LOGGED_IN, true);
  }
  
  String? getToken() {
    final token = _prefs.getString(TOKEN_KEY);
    print('Retrieved token: $token'); // Debug log
    return token;
  }
  
  bool isLoggedIn() {
    return _prefs.getBool(IS_LOGGED_IN) ?? false;
  }
  
  Future<void> clearAuth() async {
    await _prefs.remove(TOKEN_KEY);
    await _prefs.remove(IS_LOGGED_IN);
  }
  
  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(THEME_MODE, isDark);
  }
  
  bool? getThemeMode() {
    return _prefs.getBool(THEME_MODE);
  }
  
  Future<void> clearSession() async {
    await _prefs.remove(TOKEN_KEY);
    await _prefs.remove(IS_LOGGED_IN);
    debugPrint('🔐 Session cleared');
  }
  
  Future<void> logout() async {
    try {
      await _prefs.clear(); // Clear all stored data
      debugPrint('🔐 All data cleared');
      
      // Navigate to login and remove all previous routes
      Get.offAllNamed(Routes.LOGIN);
      
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('❌ Error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String? getUserUuid() {
    return _prefs.getString(USER_UUID_KEY);
  }

  Future<bool> setUserUuid(String uuid) {
    return _prefs.setString(USER_UUID_KEY, uuid);
  }
} 