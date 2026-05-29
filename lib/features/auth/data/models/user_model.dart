import '../../domain/entities/auth_entity.dart';

/// Data model for User, maps JSON from /api/auth/* to UserEntity.
///
/// Source: claude.md §3A JSON mock
/// Source: claude1.md §MODEL RULES — must have fromJson/toJson/toEntity
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Convert to domain Entity.
  /// Source: claude1.md §MODEL RULES — JSON → Model → Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      emailVerifiedAt: emailVerifiedAt,
    );
  }
}
