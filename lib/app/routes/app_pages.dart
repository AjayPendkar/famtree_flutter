import 'package:get/get.dart';
import '../features/splash/views/splash_view.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/new_user_view.dart';
import '../features/auth/views/registration_view.dart';
import '../features/auth/views/verify_otp_view.dart';
import '../features/home/views/home_view.dart';
import '../features/settings/views/settings_view.dart';
import '../features/profile/views/edit_profile_view.dart';
import '../features/payment/views/payment_view.dart';
import '../features/membership/views/membership_plans_view.dart';
import '../features/profile/views/pending_members_view.dart';
import '../features/profile/views/member_details_view.dart';
import '../features/profile/views/verify_family_code_view.dart';
import '../core/bindings/initial_binding.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
    ),
    GetPage(
      name: Routes.NEW_USER,
      page: () => const NewUserView(),
    ),
    GetPage(
      name: Routes.REGISTRATION,
      page: () => const RegistrationView(),
    ),
    GetPage(
      name: '/edit-profile',
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: '/payment',
      page: () => const PaymentView(),
    ),
    GetPage(
      name: Routes.MEMBERSHIP_PLANS,
      page: () => const MembershipPlansView(),
    ),
    GetPage(
      name: Routes.PENDING_MEMBERS,
      page: () => const PendingMembersView(),
    ),
    GetPage(
      name: Routes.MEMBER_DETAILS,
      page: () => const MemberDetailsView(),
    ),
    GetPage(
      name: Routes.VERIFY_FAMILY_CODE,
      page: () => const VerifyFamilyCodeView(),
    ),
    GetPage(
      name: Routes.VERIFY_OTP,
      page: () => const VerifyOtpView(),
    ),
  ];
} 