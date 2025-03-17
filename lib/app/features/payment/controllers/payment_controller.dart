import 'package:get/get.dart';

class PaymentController extends GetxController {
  void processPayment(String method) {
    // TODO: Implement actual payment processing
    Get.snackbar(
      'Processing Payment',
      'Processing $method payment...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
} 