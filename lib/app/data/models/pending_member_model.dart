class PendingMembersResponse {
  final int status;
  final String message;
  final List<PendingMember> data;

  PendingMembersResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PendingMembersResponse.fromJson(Map<String, dynamic> json) {
    return PendingMembersResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => PendingMember.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PendingMember {
  final String firstName;
  final String mobile;
  final String relation;
  final String verificationCode;
  final String memberUid;
  final String familyUid;

  PendingMember({
    required this.firstName,
    required this.mobile,
    required this.relation,
    required this.verificationCode,
    required this.memberUid,
    required this.familyUid,
  });

  factory PendingMember.fromJson(Map<String, dynamic> json) => PendingMember(
    firstName: json['firstName'] ?? '',
    mobile: json['mobile'] ?? '',
    relation: json['relation'] ?? '',
    verificationCode: json['verificationCode'] ?? '',
    memberUid: json['memberUid'] ?? '',
    familyUid: json['familyUid'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'mobile': mobile,
    'relation': relation,
    'verificationCode': verificationCode,
    'memberUid': memberUid,
    'familyUid': familyUid,
  };
} 