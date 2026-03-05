import '../entities/posyandu_entity.dart';

abstract class PosyanduRepository {
  Future<PosyanduEntity> getPosyanduData();
}
