import 'package:nalargizi/core/error/failures.dart';
import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

/// UseCase: Get dashboard overview data.
///
/// Source: claude1.md §DASHBOARD Responsibilities
class GetDashboardOverviewUseCase {
  const GetDashboardOverviewUseCase(this._repository);
  final DashboardRepository _repository;

  Future<({DashboardOverviewEntity? data, Failure? failure})> call({
    int childId = 1,
  }) {
    return _repository.getOverview(childId: childId);
  }
}
