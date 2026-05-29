import 'package:nalargizi/core/error/failures.dart';
import '../entities/dashboard_entity.dart';

/// Abstract repository contract for Dashboard feature.
///
/// Source: claude2.md §2 — Repository returns record type with Failure
abstract class DashboardRepository {
  Future<({DashboardOverviewEntity? data, Failure? failure})> getOverview({
    int childId,
  });
}
