import '../entities/posyandu_entity.dart';
import '../repositories/posyandu_repository.dart';

class GetPosyanduDataUseCase {
  const GetPosyanduDataUseCase(this._repository);

  final PosyanduRepository _repository;

  Future<PosyanduEntity> call() {
    return _repository.getPosyanduData();
  }
}
