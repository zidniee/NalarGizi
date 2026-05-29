import 'package:nalargizi/core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase: Login with email and password.
///
/// Source: claude1.md §TASK EXECUTION PROTOCOL Step 6 — Implement use case.
/// Source: claude1.md §Architecture Flow: Cubit → UseCase → Repository
class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<({AuthResultEntity? data, Failure? failure})> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
