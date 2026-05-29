import 'package:nalargizi/core/error/failures.dart';
import '../entities/posyandu_entity.dart';
import '../repositories/posyandu_repository.dart';

class GetPosyanduDataUseCase {
  const GetPosyanduDataUseCase(this._repository);

  final PosyanduRepository _repository;

  Future<({PosyanduEntity? data, Failure? failure})> call({
    int childId = 1,
  }) {
    return _repository.getPosyanduData(childId: childId);
  }
}

