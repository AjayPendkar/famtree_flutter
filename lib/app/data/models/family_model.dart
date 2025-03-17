class FamilyModel {
  final String id;
  final String familyName;
  final String role;

  FamilyModel({
    required this.id,
    required this.familyName,
    required this.role,
  });

  factory FamilyModel.fromJson(Map<String, dynamic> json) => FamilyModel(
        id: json['id'],
        familyName: json['familyName'],
        role: json['role'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'familyName': familyName,
        'role': role,
      };
} 