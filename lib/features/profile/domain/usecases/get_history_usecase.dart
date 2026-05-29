import 'package:nalargizi/core/error/failures.dart';
import 'package:nalargizi/features/growth/domain/entities/growth_entity.dart';
import '../repositories/profile_repository.dart';

/// UseCase to retrieve growth measurements history of the child.
class GetHistoryUseCase {
  const GetHistoryUseCase(this._repository);

  final ProfileRepository _repository;

  Future<({List<GrowthRecordEntity>? data, Failure? failure})> call() {
    return _repository.getChildHistory();
  }
}
