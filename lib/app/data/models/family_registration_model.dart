import 'package:famtreeflutter/app/data/models/registration_model.dart';

class FamilyRegistrationResponse {
  final int status;
  final String message;
  final FamilyRegistrationData data;

  FamilyRegistrationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FamilyRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return FamilyRegistrationResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: FamilyRegistrationData.fromJson(json['data'] ?? {}),
    );
  }
}

class FamilyRegistrationData {
  final String familyName;
  final String address;
  final String description;
  final FamilyHead familyHead;
  final List<FamilyMember> members;

  FamilyRegistrationData({
    required this.familyName,
    required this.address,
    required this.description,
    required this.familyHead,
    required this.members,
  });

  factory FamilyRegistrationData.fromJson(Map<String, dynamic> json) {
    return FamilyRegistrationData(
      familyName: json['familyName'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      familyHead: FamilyHead.fromJson(json['familyHead'] ?? {}),
      members: (json['members'] as List?)
              ?.map((e) => FamilyMember.fromJson(e))
              .toList() ??
          [],
    );
  }
} 