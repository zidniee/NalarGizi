import '../entities/quick_add_entity.dart';
import '../repositories/quick_add_repository.dart';

class GetQuickAddDataUseCase {
  const GetQuickAddDataUseCase(this._repository);

  final QuickAddRepository _repository;

  Future<QuickAddEntity> call() {
    return _repository.getQuickAddData();
  }
}
