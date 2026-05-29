import 'package:equatable/equatable.dart';

/// Domain entity for authenticated user.
///
/// Source: claude.md §3A (ERD: USERS table)
/// Source: claude1.md §ENTITY RULES — Immutable, Equatable, Framework Independent
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.emailVerifiedAt,
  });

  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? emailVerifiedAt;

  @override
  List<Object?> get props => [id, name, email, phoneNumber, emailVerifiedAt];
}

/// Domain entity for child profile linked to a user.
///
/// Source: claude.md §3A (ERD: CHILDREN table)
/// Source: claude1.md §ENTITY RULES
class ChildEntity extends Equatable {
  const ChildEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.birthDate,
    required this.gender,
  });

  final int id;
  final int userId;
  final String name;

  /// Format: 'YYYY-MM-DD'
  final String birthDate;

  /// 'Laki-laki' or 'Perempuan'
  final String gender;

  @override
  List<Object?> get props => [id, userId, name, birthDate, gender];
}

/// Domain entity representing the complete authentication result.
///
/// Source: claude.md §3A JSON mock — token + user + child
class AuthResultEntity extends Equatable {
  const AuthResultEntity({
    required this.token,
    required this.user,
    this.child,
  });

  final String token;
  final UserEntity user;
  final ChildEntity? child;

  @override
  List<Object?> get props => [token, user, child];
}
