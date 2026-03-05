import '../entities/growth_entity.dart';

abstract class GrowthRepository {
  Future<GrowthEntity> getGrowthData();
}
