class RegisterMemberRequest {
  final String mobile;
  final String memberUid;
  final String familyUid;
  final String familyName;
  final String headName;
  final String firstName;
  final String lastName;
  final String email;
  final String dateOfBirth;
  final String gender;
  final String maritalStatus;
  final String occupation;
  final String education;
  final String address;
  final String description;
  final String relation;
  final String? nationalId;
  final String? passportNumber;
  final String? voterId;
  final String? birthCertificateId;
  final String? profileImageUrl;
  final List<String>? documentImageUrls;

  RegisterMemberRequest({
    required this.mobile,
    required this.memberUid,
    required this.familyUid,
    required this.familyName,
    required this.headName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.maritalStatus,
    required this.occupation,
    required this.education,
    required this.address,
    required this.description,
    required this.relation,
    this.nationalId,
    this.passportNumber,
    this.voterId,
    this.birthCertificateId,
    this.profileImageUrl,
    this.documentImageUrls,
  });

  Map<String, dynamic> toJson() => {
    'mobile': mobile,
    'memberUid': memberUid,
    'familyUid': familyUid,
    'familyName': familyName,
    'headName': headName,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'dateOfBirth': dateOfBirth,
    'gender': gender,
    'maritalStatus': maritalStatus,
    'occupation': occupation,
    'education': education,
    'address': address,
    'description': description,
    'relation': relation,
    if (nationalId != null) 'nationalId': nationalId,
    if (passportNumber != null) 'passportNumber': passportNumber,
    if (voterId != null) 'voterId': voterId,
    if (birthCertificateId != null) 'birthCertificateId': birthCertificateId,
    if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
    if (documentImageUrls != null) 'documentImageUrls': documentImageUrls,
  };
} 