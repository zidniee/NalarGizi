import 'package:nalargizi/core/error/failures.dart';
import '../entities/auth_entity.dart';

/// Abstract contract for authentication operations.
///
/// Source: claude1.md §AUTH — FEATURE SPECIFICATION
/// Source: claude2.md §2 — Return Either<Failure, T>
/// Note: Using sealed Result type instead of dartz to avoid external package dependency.
abstract class AuthRepository {
  /// Login with email and password.
  /// Returns [AuthResultEntity] on success or [Failure] on error.
  Future<({AuthResultEntity? data, Failure? failure})> login({
    required String email,
    required String password,
  });

  /// Register a new account.
  Future<({AuthResultEntity? data, Failure? failure})> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  });

  /// Login via Google OAuth2.
  Future<({AuthResultEntity? data, Failure? failure})> googleLogin(
    String idToken,
  );

  /// Send forgot password link to email.
  Future<({bool success, Failure? failure})> forgotPassword(String email);
}
