import 'package:famtreeflutter/app/data/models/pending_member_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../../../data/models/verify_family_code_model.dart';
import 'member_details_view.dart';

class VerifyFamilyCodeView extends GetView<EditProfileController> {
  const VerifyFamilyCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final member = Get.arguments as PendingMember;
    final formKey = GlobalKey<FormState>();
    final familyNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text('Verify Family Code'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
            stops: const [0.0, 0.2, 0.3],
          ),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Info Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Verify Family Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please enter your family details to proceed',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Form Fields
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Mobile Number (Disabled)
                        TextFormField(
                          initialValue: member.mobile,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Verification Code (Disabled)
                        TextFormField(
                          initialValue: member.verificationCode,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Verification Code',
                            prefixIcon: Icon(Icons.key),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Family Name
                        TextFormField(
                          controller: familyNameController,
                          decoration: const InputDecoration(
                            labelText: 'Family Name',
                            prefixIcon: Icon(Icons.family_restroom),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter family name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (formKey.currentState?.validate() ?? false) {
                              final request = VerifyFamilyCodeRequest(
                                mobile: member.mobile,
                                verificationCode: member.verificationCode,
                                familyName: familyNameController.text,
                              );
                              
                              final success = await controller.verifyFamilyCode(request);
                              if (success) {
                                Get.off(() => const MemberDetailsView(), arguments: member);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Verify & Continue',
                            style: TextStyle(fontSize: 16),
                          ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 