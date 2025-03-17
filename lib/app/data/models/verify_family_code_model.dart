class VerifyFamilyCodeRequest {
  final String mobile;
  final String verificationCode;
  final String familyName;

  VerifyFamilyCodeRequest({
    required this.mobile,
    required this.verificationCode,
    required this.familyName,
  });

  Map<String, dynamic> toJson() => {
    'mobile': mobile,
    'verificationCode': verificationCode,
    'familyName': familyName,
  };
} 