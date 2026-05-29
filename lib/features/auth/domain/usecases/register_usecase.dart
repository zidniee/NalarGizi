import 'package:nalargizi/core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase: Register new account.
///
/// Source: claude1.md §TASK EXECUTION PROTOCOL Step 6
class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<({AuthResultEntity? data, Failure? failure})> call({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
    );
  }
}
