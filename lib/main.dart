import 'dart:async';
import 'package:famtreeflutter/app/features/auth/bindings/auth_binding.dart';
import 'app/core/services/storage_service.dart';
import 'package:famtreeflutter/app/data/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/core/translations/app_translations.dart';
import 'app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'app/core/network/api_client.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/services/locale_service.dart';
import 'app/services/s3_service.dart';
import 'app/core/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize GetStorage
    await GetStorage.init().timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        debugPrint('GetStorage initialization timed out');
        throw TimeoutException('GetStorage initialization timed out');
      },
    );
  } catch (e) {
    debugPrint('GetStorage initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FamTree',
      initialBinding: InitialBinding(),
      translations: AppTranslations(),
      fallbackLocale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
