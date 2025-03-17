class RegistrationModel {
  final String familyName;
  final String address;
  final String description;
  final FamilyHead familyHead;
  final List<FamilyMember> members;

  RegistrationModel({
    required this.familyName,
    required this.address,
    required this.description,
    required this.familyHead,
    required this.members,
  });

  Map<String, dynamic> toJson() => {
        'familyName': familyName,
        'address': address,
        'description': description,
        'familyHead': familyHead.toJson(),
        'members': members.map((member) => member.toJson()).toList(),
      };
}

class FamilyHead {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String dateOfBirth;
  final String occupation;
  final String education;
  final String gender;
  final String maritalStatus;
  final String role;
  final String? profilePicture;
  final List<String>? photos;

  FamilyHead({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.dateOfBirth,
    required this.occupation,
    required this.education,
    required this.gender,
    required this.maritalStatus,
    this.role = 'HEAD',
    this.profilePicture,
    this.photos,
  });

  factory FamilyHead.fromJson(Map<String, dynamic> json) {
    return FamilyHead(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      occupation: json['occupation'] ?? '',
      education: json['education'] ?? '',
      gender: json['gender'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      role: json['role'] ?? 'HEAD',
      profilePicture: json['profilePicture'],
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobile': mobile,
        'dateOfBirth': dateOfBirth,
        'occupation': occupation,
        'education': education,
        'gender': gender,
        'maritalStatus': maritalStatus,
        'role': role,
        if (profilePicture != null) 'profilePicture': profilePicture,
        if (photos != null) 'photos': photos,
      };
}

class FamilyMember {
  final String firstName;
  final String mobile;
  final String relation;
  final String? verificationCode;
  final String? profilePicture;
  final List<String>? photos;

  FamilyMember({
    required this.firstName,
    required this.mobile,
    required this.relation,
    this.verificationCode,
    this.profilePicture,
    this.photos,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      firstName: json['firstName'] ?? '',
      mobile: json['mobile'] ?? '',
      relation: json['relation'] ?? '',
      verificationCode: json['verificationCode'],
      profilePicture: json['profilePicture'],
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'mobile': mobile,
        'relation': relation,
        if (verificationCode != null) 'verificationCode': verificationCode,
        if (profilePicture != null) 'profilePicture': profilePicture,
        if (photos != null) 'photos': photos,
      };
} 