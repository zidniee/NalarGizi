import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  const GetDashboardDataUseCase(this._repository);

  final DashboardRepository _repository;

  Future<DashboardEntity> call() {
    return _repository.getDashboardData();
  }
}
