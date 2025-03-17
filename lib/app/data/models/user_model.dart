import 'package:get/get.dart';

class UserModel {
  final String mobile;
  final String familyName;
  final String role;

  UserModel({
    required this.mobile,
    required this.familyName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        mobile: json['mobile'],
        familyName: json['familyName'],
        role: json['role'],
      );

  Map<String, dynamic> toJson() => {
        'mobile': mobile,
        'familyName': familyName,
        'role': role,
      };
}

enum UserRole {
  HEAD,
  MEMBER;

  String get displayName => name.toString().split('.').last;
} 