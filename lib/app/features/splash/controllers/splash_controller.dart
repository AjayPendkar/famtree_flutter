import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class SplashController extends GetxController {
  final _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay
    
    if (_storageService.isLoggedIn()) {
      final token = _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }
} 