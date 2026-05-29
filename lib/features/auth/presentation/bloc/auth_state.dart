import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_entity.dart';

/// Status enum for all auth operations.
enum AuthStatus { initial, loading, success, failure }

/// Auth form validation state (claude2.md §5 — validation managed by Cubit).
class AuthFormState extends Equatable {
  const AuthFormState({
    this.email = '',
    this.password = '',
    this.name = '',
    this.phoneNumber = '',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isNameValid = true,
  });

  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isNameValid;

  AuthFormState copyWith({
    String? email,
    String? password,
    String? name,
    String? phoneNumber,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isNameValid,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isNameValid: isNameValid ?? this.isNameValid,
    );
  }

  @override
  List<Object?> get props => [
    email, password, name, phoneNumber,
    isEmailValid, isPasswordValid, isNameValid,
  ];
}

/// State for the Auth feature Cubit.
///
/// Source: claude1.md §STATE MANAGEMENT RULES — Immutable, Equatable
/// Source: claude2.md §5 — form validation state managed here
class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.message = '',
    this.result,
    this.form = const AuthFormState(),
  });

  final AuthStatus status;
  final String message;

  /// The authenticated user + token + child data on success.
  final AuthResultEntity? result;

  /// Form validation state per claude2.md §5
  final AuthFormState form;

  AuthState copyWith({
    AuthStatus? status,
    String? message,
    AuthResultEntity? result,
    AuthFormState? form,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      result: result ?? this.result,
      form: form ?? this.form,
    );
  }

  @override
  List<Object?> get props => [status, message, result, form];
}
