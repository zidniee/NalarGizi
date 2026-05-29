import 'child_model.dart';
import 'user_model.dart';
import '../../domain/entities/auth_entity.dart';

/// Response model for authentication endpoints.
///
/// Source: claude.md §3A JSON — wraps token + user + child
/// Source: claude1.md §MODEL RULES
class AuthResponseModel {
  const AuthResponseModel({
    required this.token,
    required this.user,
    this.child,
  });

  final String token;
  final UserModel user;
  final ChildModel? child;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      child: json['child'] != null
          ? ChildModel.fromJson(json['child'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'child': child?.toJson(),
    };
  }

  /// Convert to domain entity.
  AuthResultEntity toEntity() {
    return AuthResultEntity(
      token: token,
      user: user.toEntity(),
      child: child?.toEntity(),
    );
  }
}
