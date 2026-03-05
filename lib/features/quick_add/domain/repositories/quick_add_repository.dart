import '../entities/quick_add_entity.dart';

abstract class QuickAddRepository {
  Future<QuickAddEntity> getQuickAddData();
}
