import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../data/models/family_member_form.dart';
import 'custom_form_fields.dart';
import 'image_upload_widget.dart';
import 'dart:io';

class FamilyMemberForm extends StatelessWidget {
  final int index;
  final FamilyMemberFormController controller;
  final VoidCallback onRemove;

  const FamilyMemberForm({
    Key? key,
    required this.index,
    required this.controller,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('[FamilyMemberForm] Building form for index: $index');
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Member ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.red,
                    onPressed: onRemove,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Profile Picture Section
              Center(
                child: Column(
                  children: [
                    Obx(() => CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: controller.profilePicture.value != null
                          ? FileImage(File(controller.profilePicture.value!))
                          : null,
                      child: controller.profilePicture.value == null
                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    )),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: controller.pickProfilePicture,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Name',
                icon: Icons.person_outline,
                controller: controller.firstNameController,
                onChanged: (value) => controller.firstName.value = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Mobile',
                icon: Icons.phone,
                controller: controller.mobileController,
                onChanged: (value) => controller.mobile.value = value,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Mobile is required';
                  }
                  if (value!.length != 10) {
                    return 'Mobile must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomFormField(
                label: 'Relation',
                icon: Icons.family_restroom,
                controller: controller.relationController,
                onChanged: (value) => controller.relation.value = value,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Relation is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Multiple Photos Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Photos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => controller.photos.isEmpty
                      ? Center(
                          child: TextButton.icon(
                            onPressed: controller.pickPhotos,
                            icon: const Icon(Icons.add_photo_alternate),
                            label: const Text('Add Photos'),
                          ),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...controller.photos.asMap().entries.map((entry) {
                              final index = entry.key;
                              final photo = entry.value;
                              return Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: FileImage(File(photo)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.remove_circle),
                                      color: Colors.red,
                                      onPressed: () => controller.removePhoto(index),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.add_photo_alternate),
                                onPressed: controller.pickPhotos,
                              ),
                            ),
                          ],
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => Text(
                'Form Status: ${controller.isFormValid.value ? "Valid" : "Invalid"}',
                style: TextStyle(
                  color: controller.isFormValid.value ? Colors.green : Colors.red,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
} 