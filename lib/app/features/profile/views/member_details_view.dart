import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/pending_member_model.dart';
import '../controllers/edit_profile_controller.dart';
import '../../../data/models/register_member_model.dart';

class MemberDetailsView extends GetView<EditProfileController> {
  const MemberDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final member = Get.arguments as PendingMember;
    final formKey = GlobalKey<FormState>();
    
    // Controllers for form fields
    final familyNameController = TextEditingController();
    final headNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final emailController = TextEditingController();
    final dobController = TextEditingController();
    final occupationController = TextEditingController();
    final educationController = TextEditingController();
    final addressController = TextEditingController();
    final descriptionController = TextEditingController();
    final nationalIdController = TextEditingController();
    final passportController = TextEditingController();
    final voterIdController = TextEditingController();
    final birthCertificateController = TextEditingController();
    
    final gender = 'MALE'.obs;
    final maritalStatus = 'SINGLE'.obs;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text('${member.firstName}\'s Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionTitle('Basic Information'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: familyNameController,
                        decoration: const InputDecoration(labelText: 'Family Name'),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: headNameController,
                        decoration: const InputDecoration(labelText: 'Head Name'),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Contact Information
              _buildSectionTitle('Contact Information'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: member.mobile,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Mobile'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        maxLines: 2,
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Personal Details
              _buildSectionTitle('Personal Details'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: dobController,
                        decoration: const InputDecoration(
                          labelText: 'Date of Birth',
                          hintText: 'YYYY-MM-DD',
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      Obx(() => Row(
                        children: [
                          const Text('Gender: '),
                          Radio(
                            value: 'MALE',
                            groupValue: gender.value,
                            onChanged: (value) => gender.value = value.toString(),
                          ),
                          const Text('Male'),
                          Radio(
                            value: 'FEMALE',
                            groupValue: gender.value,
                            onChanged: (value) => gender.value = value.toString(),
                          ),
                          const Text('Female'),
                        ],
                      )),
                      const SizedBox(height: 16),
                      Obx(() => Row(
                        children: [
                          const Text('Marital Status: '),
                          Radio(
                            value: 'SINGLE',
                            groupValue: maritalStatus.value,
                            onChanged: (value) => maritalStatus.value = value.toString(),
                          ),
                          const Text('Single'),
                          Radio(
                            value: 'MARRIED',
                            groupValue: maritalStatus.value,
                            onChanged: (value) => maritalStatus.value = value.toString(),
                          ),
                          const Text('Married'),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Professional Information
              _buildSectionTitle('Professional Information'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: occupationController,
                        decoration: const InputDecoration(labelText: 'Occupation'),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: educationController,
                        decoration: const InputDecoration(labelText: 'Education'),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Additional Information
              _buildSectionTitle('Additional Information'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: member.relation,
                        enabled: false,
                        decoration: const InputDecoration(labelText: 'Relation'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ID Documents
              _buildSectionTitle('ID Documents (Optional)'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nationalIdController,
                        decoration: const InputDecoration(labelText: 'National ID'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passportController,
                        decoration: const InputDecoration(labelText: 'Passport Number'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: voterIdController,
                        decoration: const InputDecoration(labelText: 'Voter ID'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: birthCertificateController,
                        decoration: const InputDecoration(labelText: 'Birth Certificate ID'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final request = RegisterMemberRequest(
                        mobile: member.mobile,
                        memberUid: member.memberUid,
                        familyUid: member.familyUid,
                        familyName: familyNameController.text,
                        headName: headNameController.text,
                        firstName: member.firstName,
                        lastName: lastNameController.text,
                        email: emailController.text,
                        dateOfBirth: dobController.text,
                        gender: gender.value,
                        maritalStatus: maritalStatus.value,
                        occupation: occupationController.text,
                        education: educationController.text,
                        address: addressController.text,
                        description: descriptionController.text,
                        relation: member.relation,
                        nationalId: nationalIdController.text.isEmpty ? null : nationalIdController.text,
                        passportNumber: passportController.text.isEmpty ? null : passportController.text,
                        voterId: voterIdController.text.isEmpty ? null : voterIdController.text,
                        birthCertificateId: birthCertificateController.text.isEmpty ? null : birthCertificateController.text,
                      );
                      controller.registerMember(request);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Register Member',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 