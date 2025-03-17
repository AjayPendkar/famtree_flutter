import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/values/app_constants.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool? getThemeMode() {
    return _prefs.getBool(AppConstants.themeKey);
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _prefs.setBool(AppConstants.themeKey, isDarkMode);
  }

  String? getLocale() {
    return _prefs.getString(AppConstants.localeKey);
  }

  Future<void> saveLocale(String locale) async {
    await _prefs.setString(AppConstants.localeKey, locale);
  }
} 