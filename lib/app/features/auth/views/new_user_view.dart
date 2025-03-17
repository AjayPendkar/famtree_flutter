import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_form_fields.dart';
import '../controllers/auth_controller.dart';

class NewUserView extends GetView<AuthController> {
  const NewUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.3,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'New User Registration',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Container(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.newUserFormKey,
                      child: Column(
                        children: [
                          CustomFormField(
                            label: 'Mobile Number',
                            icon: Icons.phone,
                            controller: controller.mobileController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter mobile number';
                              }
                              if (value!.length != 10) {
                                return 'Mobile number must be 10 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomFormField(
                            label: 'Family Name',
                            icon: Icons.family_restroom,
                            controller: controller.familyNameController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter family name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Obx(() => CustomDropdownField<String>(
                            label: 'Role',
                            icon: Icons.person_outline,
                            value: controller.selectedRole.value,
                            items: const [
                              DropdownMenuItem(
                                value: 'HEAD',
                                child: Text('Family Head'),
                              ),
                              DropdownMenuItem(
                                value: 'MEMBER',
                                child: Text('Family Member'),
                              ),
                            ],
                            onChanged: (value) => 
                                controller.selectedRole.value = value!,
                          )),
                          const SizedBox(height: 24),
                          Obx(() => ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.registerNewUser,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator()
                                : const Text('Register'),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 