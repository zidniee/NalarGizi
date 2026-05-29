import '../../domain/entities/auth_entity.dart';

/// Data model for Child, maps JSON from /api/auth/* to ChildEntity.
///
/// Source: claude.md §3A JSON mock
/// Source: claude1.md §MODEL RULES
class ChildModel {
  const ChildModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.birthDate,
    required this.gender,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final String name;
  final String birthDate;
  final String gender;
  final String? createdAt;
  final String? updatedAt;

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      birthDate: json['birth_date'] as String,
      gender: json['gender'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'birth_date': birthDate,
      'gender': gender,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Convert to domain Entity.
  ChildEntity toEntity() {
    return ChildEntity(
      id: id,
      userId: userId,
      name: name,
      birthDate: birthDate,
      gender: gender,
    );
  }
}
