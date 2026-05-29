import 'package:nalargizi/core/error/failures.dart';
import '../entities/growth_entity.dart';

/// Abstract repository contract for Growth feature.
///
/// Source: claude1.md §GROWTH — GET /api/growth/records, POST /api/growth/records
/// Source: claude2.md §2 — Returns record type with Failure
abstract class GrowthRepository {
  Future<({List<GrowthRecordEntity>? data, Failure? failure})> getRecords({
    int childId,
  });

  Future<({GrowthRecordEntity? data, Failure? failure})> addRecord(
    Map<String, dynamic> data,
  );
}
