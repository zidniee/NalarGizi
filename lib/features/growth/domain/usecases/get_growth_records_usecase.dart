import 'package:nalargizi/core/error/failures.dart';
import '../entities/growth_entity.dart';
import '../repositories/growth_repository.dart';

/// UseCase: Get all growth records for a child.
class GetGrowthRecordsUseCase {
  const GetGrowthRecordsUseCase(this._repository);
  final GrowthRepository _repository;

  Future<({List<GrowthRecordEntity>? data, Failure? failure})> call({
    int childId = 1,
  }) {
    return _repository.getRecords(childId: childId);
  }
}
