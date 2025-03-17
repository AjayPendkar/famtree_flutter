import 'package:famtreeflutter/app/core/services/storage_service.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  Future<void> handleLogout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog first
              Get.find<StorageService>().logout(); // Then logout
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 