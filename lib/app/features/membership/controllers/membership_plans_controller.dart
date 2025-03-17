import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class MembershipPlansController extends GetxController {
  final selectedPlan = 'FREE'.obs;
  
  final membershipPlans = [
    {
      'name': 'FREE',
      'price': '₹0/month',
      'connections': 2,
      'features': [
        '2 Connection Requests per month',
        'Basic Profile Access',
        'Limited Search',
      ],
    },
    {
      'name': 'BASIC',
      'price': '₹199/month',
      'connections': 5,
      'features': [
        '5 Connection Requests per month',
        'Full Profile Access',
        'Advanced Search',
        'Priority Support',
      ],
    },
    {
      'name': 'PREMIUM',
      'price': '₹499/month',
      'connections': 15,
      'features': [
        '15 Connection Requests per month',
        'Unlimited Profile Access',
        'Advanced Search with Filters',
        'Priority Support 24/7',
        'Profile Highlights',
        'Early Access to New Features',
      ],
    },
  ];

  void upgradeMembership(String planName) {
    Get.toNamed(
      Routes.PAYMENT,
      arguments: {
        'planName': planName,
        'price': membershipPlans.firstWhere(
          (plan) => plan['name'] == planName,
        )['price'],
        'connections': membershipPlans.firstWhere(
          (plan) => plan['name'] == planName,
        )['connections'],
      },
    );
  }
} 