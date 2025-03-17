import 'package:get/get.dart';
import '../../../services/s3_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ImageUploadService is available
    if (!Get.isRegistered<ImageUploadService>()) {
      Get.putAsync<ImageUploadService>(() => ImageUploadService.init());
    }
    
    Get.lazyPut<AuthController>(() => AuthController());
  }
}