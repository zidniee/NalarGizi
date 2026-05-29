import 'package:nalargizi/core/error/failures.dart';
import '../entities/growth_entity.dart';
import '../repositories/growth_repository.dart';

/// UseCase: Add a new growth measurement record.
///
/// Source: claude.md §3C — POST /api/growth/records
class AddGrowthRecordUseCase {
  const AddGrowthRecordUseCase(this._repository);
  final GrowthRepository _repository;

  Future<({GrowthRecordEntity? data, Failure? failure})> call(
    Map<String, dynamic> data,
  ) {
    return _repository.addRecord(data);
  }
}
