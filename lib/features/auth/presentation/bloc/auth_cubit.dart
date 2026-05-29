import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import 'auth_state.dart';

/// Cubit managing all authentication state transitions.
///
/// Source: claude1.md §STATE MANAGEMENT RULES — Cubit Only
/// Source: claude1.md §96-104 — Business logic belongs to Cubits
/// Source: claude2.md §3 — Instantiated via GetIt, not manually in UI
/// Source: claude2.md §5 — Form validation managed here
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleLoginUseCase,
    required this.forgotPasswordUseCase,
  }) : super(const AuthState());

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  // ── Form validation (claude2.md §5) ───────────────────────────────────

  /// Update email field and validate it.
  void emailChanged(String email) {
    final isValid = _isValidEmail(email);
    emit(state.copyWith(
      form: state.form.copyWith(email: email, isEmailValid: isValid),
    ));
  }

  /// Update password field and validate it.
  void passwordChanged(String password) {
    final isValid = password.length >= 6;
    emit(state.copyWith(
      form: state.form.copyWith(password: password, isPasswordValid: isValid),
    ));
  }

  /// Update name field and validate it.
  void nameChanged(String name) {
    final isValid = name.trim().length >= 2;
    emit(state.copyWith(
      form: state.form.copyWith(name: name, isNameValid: isValid),
    ));
  }

  /// Update phone number field.
  void phoneNumberChanged(String phone) {
    emit(state.copyWith(
      form: state.form.copyWith(phoneNumber: phone),
    ));
  }

  // ── Auth operations ────────────────────────────────────────────────────

  /// Login with email and password.
  /// Source: claude.md §3A — POST /api/auth/login
  Future<void> login() async {
    if (!_isValidEmail(state.form.email)) {
      emit(state.copyWith(
        form: state.form.copyWith(isEmailValid: false),
      ));
      return;
    }
    if (state.form.password.length < 6) {
      emit(state.copyWith(
        form: state.form.copyWith(isPasswordValid: false),
      ));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final result = await loginUseCase(
      email: state.form.email,
      password: state.form.password,
    );

    if (result.failure != null) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      emit(state.copyWith(
        status: AuthStatus.success,
        result: result.data,
        message: 'Login berhasil.',
      ));
    }
  }

  /// Register a new account.
  /// Source: claude.md §3A — POST /api/auth/register
  Future<void> register() async {
    if (state.form.name.trim().length < 2) {
      emit(state.copyWith(form: state.form.copyWith(isNameValid: false)));
      return;
    }
    if (!_isValidEmail(state.form.email)) {
      emit(state.copyWith(form: state.form.copyWith(isEmailValid: false)));
      return;
    }
    if (state.form.password.length < 6) {
      emit(state.copyWith(form: state.form.copyWith(isPasswordValid: false)));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final result = await registerUseCase(
      name: state.form.name,
      email: state.form.email,
      password: state.form.password,
      phoneNumber: state.form.phoneNumber.isEmpty
          ? null
          : state.form.phoneNumber,
    );

    if (result.failure != null) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      emit(state.copyWith(
        status: AuthStatus.success,
        result: result.data,
        message: 'Registrasi berhasil.',
      ));
    }
  }

  /// Login with Google OAuth2.
  /// Source: claude.md §3A — POST /api/auth/google
  Future<void> googleLogin(String idToken) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await googleLoginUseCase(idToken);

    if (result.failure != null) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      emit(state.copyWith(
        status: AuthStatus.success,
        result: result.data,
        message: 'Login Google berhasil.',
      ));
    }
  }

  /// Send forgot password email.
  /// Source: claude.md §3A — POST /api/auth/forgot-password
  Future<void> forgotPassword() async {
    if (!_isValidEmail(state.form.email)) {
      emit(state.copyWith(form: state.form.copyWith(isEmailValid: false)));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    final result = await forgotPasswordUseCase(state.form.email);

    if (result.failure != null) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.success,
        message: 'Link reset password dikirim ke ${state.form.email}.',
      ));
    }
  }

  /// Logout the user.
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    emit(const AuthState());
  }

  /// Reset state back to initial.
  void reset() => emit(const AuthState());

  // ── Private helpers ────────────────────────────────────────────────────

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
