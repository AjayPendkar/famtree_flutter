import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../services/s3_service.dart';
import '../services/storage_service.dart';
import '../services/locale_service.dart';
import '../network/api_client.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/home/controllers/profile_controller.dart';
import '../../features/settings/controllers/settings_controller.dart';
import '../../features/profile/controllers/edit_profile_controller.dart';
import '../../features/payment/controllers/payment_controller.dart';
import '../../features/membership/controllers/membership_plans_controller.dart';
import '../../features/profile/controllers/pending_members_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    print('[InitialBinding] Initializing dependencies');
    _initServices();
  }

  void _initServices() {
    print('[InitialBinding] Starting services initialization');
    
    // 1. Initialize SharedPreferences synchronously
    SharedPreferences.getInstance().then((prefs) {
      print('[InitialBinding] SharedPreferences initialized');
      
      // 2. Initialize StorageService with SharedPreferences
      final storageService = StorageService(prefs);
      Get.put(storageService, permanent: true);
      print('[InitialBinding] StorageService initialized');
      
      // 3. Initialize LocaleService
      Get.put(LocaleService(), permanent: true);
      print('[InitialBinding] LocaleService initialized');
      
      // 4. Initialize ApiClient with StorageService
      final apiClient = ApiClient(Dio(), storageService);
      Get.put(apiClient, permanent: true);
      print('[InitialBinding] ApiClient initialized');
      
      // 5. Initialize ImageUploadService
      ImageUploadService.init().then((imageService) {
        Get.put(imageService, permanent: true);
        print('[InitialBinding] ImageUploadService initialized');
        
        // 6. Initialize controllers after all services are ready
        _initControllers();
      });
    });
  }

  void _initControllers() {
    print('[InitialBinding] Initializing controllers');
    
    // Initialize AuthController first and make it permanent
    print('[InitialBinding] Creating AuthController instance');
    final authController = AuthController();
    Get.put(authController, permanent: true);
    print('[InitialBinding] AuthController initialized');

    // Initialize other controllers with fenix: true
    print('[InitialBinding] Initializing other controllers');
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
    Get.lazyPut(() => EditProfileController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => MembershipPlansController(), fenix: true);
    Get.lazyPut(() => PendingMembersController(), fenix: true);
    print('[InitialBinding] All controllers initialized');
  }
} 