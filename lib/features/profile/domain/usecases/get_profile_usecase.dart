import 'package:nalargizi/core/error/failures.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase to retrieve parent and child profile details.
class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<({ProfileEntity? data, Failure? failure})> call() {
    return _repository.getProfileInfo();
  }
}
