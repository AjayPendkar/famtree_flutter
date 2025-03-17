import 'package:famtreeflutter/app/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_form_fields.dart';
import '../../../widgets/family_member_form.dart';

class RegistrationView extends GetView<AuthController> {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getStepIcon(controller.currentStep.value),
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getStepTitle(controller.currentStep.value),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Row(
                    children: [0, 1, 2].map((step) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          decoration: BoxDecoration(
                            color: step <= controller.currentStep.value
                                ? Colors.white
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Obx(() {
                    final step = controller.currentStep.value;
                    switch (step) {
                      case 0:
                        return _buildFamilyDetailsForm(context);
                      case 1:
                        return _buildFamilyHeadForm(context);
                      case 2:
                        return _buildFamilyMembersForm(context);
                      default:
                        return const SizedBox();
                    }
                  }),
                ),
              ),
            ),
            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Obx(() => Row(
                children: [
                  if (controller.currentStep.value > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('PREVIOUS'),
                      ),
                    ),
                  if (controller.currentStep.value > 0)
                    const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value 
                        ? null 
                        : controller.currentStep.value == 2 
                          ? controller.completeRegistration
                          : controller.nextStep,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                controller.currentStep.value == 2 ? 'REGISTER' : 'NEXT',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (controller.currentStep.value < 2) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 20),
                              ],
                            ],
                          ),
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStepIcon(int step) {
    switch (step) {
      case 0:
        return Icons.home_outlined;
      case 1:
        return Icons.person_outline;
      case 2:
        return Icons.people_outline;
      default:
        return Icons.home_outlined;
    }
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Family Details';
      case 1:
        return 'Family Head';
      case 2:
        return 'Family Members';
      default:
        return '';
    }
  }

  Widget _buildFamilyDetailsForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Form(
        key: controller.familyFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              icon: Icons.family_restroom,
              title: 'Basic Information',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomFormField(
                    label: 'Family Name',
                    icon: Icons.family_restroom,
                    controller: controller.familyNameController,
                  ),
                  CustomFormField(
                    label: 'Address',
                    icon: Icons.location_on,
                    controller: controller.addressController,
                    isMultiLine: true,
                  ),
                  CustomFormField(
                    label: 'Description',
                    icon: Icons.description,
                    controller: controller.descriptionController,
                    isMultiLine: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyHeadForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Form(
        key: controller.headFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              context,
              icon: Icons.person,
              title: 'Head Details',
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Expanded(
                      //   child: CustomFormField(
                      //     label: 'First Name',
                      //     icon: Icons.person_outline,
                      //     controller: controller.firstNameController,
                      //   ),
                      // ),
                     
                      Expanded(
                        child: CustomFormField(
                          label: 'Name',
                          icon: Icons.person_outline,
                          controller: controller.lastNameController,
                        ),
                      ),
                    ],
                  ),
                  CustomFormField(
                    label: 'Email',
                    icon: Icons.email,
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly
                    ,LengthLimitingTextInputFormatter(10)
                    ],
                    label: 'Mobile',
                    icon: Icons.phone,
                    controller: controller.mobileController,
                    keyboardType: TextInputType.phone,
                  ),
                  CustomFormField(
                    label: 'Date of Birth',
                    icon: Icons.calendar_today,
                    controller: controller.headDobController,
                    readOnly: true,
                    onTap: () => controller.selectDateOfBirth(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date of birth';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          label: 'Occupation',
                          icon: Icons.work,
                          controller: controller.occupationController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomFormField(
                          label: 'Education',
                          icon: Icons.school,
                          controller: controller.educationController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => CustomDropdownField<String>(
                          label: 'Gender',
                          icon: Icons.wc,
                          value: controller.selectedGender.value,
                          items: const [
                            DropdownMenuItem(
                              value: 'MALE',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'FEMALE',
                              child: Text('Female'),
                            ),
                            DropdownMenuItem(
                              value: 'OTHER',
                              child: Text('Other'),
                            ),
                          ],
                          onChanged: (value) =>
                              controller.selectedGender.value = value!,
                        )),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Obx(() => CustomDropdownField<String>(
                          label: 'Marital Status',
                          icon: Icons.favorite,
                          value: controller.selectedMaritalStatus.value,
                          items: const [
                            DropdownMenuItem(
                              value: 'SINGLE',
                              child: Text('Single'),
                            ),
                            DropdownMenuItem(
                              value: 'MARRIED',
                              child: Text('Married'),
                            ),
                            DropdownMenuItem(
                              value: 'DIVORCED',
                              child: Text('Divorced'),
                            ),
                            DropdownMenuItem(
                              value: 'WIDOWED',
                              child: Text('Widowed'),
                            ),
                          ],
                          onChanged: (value) =>
                              controller.selectedMaritalStatus.value = value!,
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMembersForm(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(
          context,
          icon: Icons.people,
          title: 'Family Members',
        ),
        const SizedBox(height: 16),
        Obx(() => Column(
          children: [
            ...controller.memberForms.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              return FamilyMemberForm(
                key: ValueKey('member_$index'),
                index: index,
                controller: member,
                onRemove: () => controller.removeMember(index),
              );
            }).toList(),
          ],
        )),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: controller.addMember,
          icon: const Icon(Icons.add),
          label: const Text('ADD MEMBER'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            side: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
} 