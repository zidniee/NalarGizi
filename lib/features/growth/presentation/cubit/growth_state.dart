import 'package:equatable/equatable.dart';
import '../../domain/entities/growth_entity.dart';

enum GrowthStatus { initial, loading, success, empty, failure }

/// State for Growth Cubit.
///
/// Source: claude1.md §STATE MANAGEMENT RULES — Immutable, Equatable
/// Source: claude.md §3C — Weight & height tracking with change calculation
class GrowthState extends Equatable {
  const GrowthState({
    this.status = GrowthStatus.initial,
    this.records = const [],
    this.message = '',
    this.isWeightMode = true,
  });

  final GrowthStatus status;
  final List<GrowthRecordEntity> records;
  final String message;

  /// True = Berat Badan mode, False = Tinggi Badan mode
  final bool isWeightMode;

  // ── Computed business values (claude1.md §96 — logic in Cubit, not Widget) ──

  /// Latest record (most recent measurement).
  GrowthRecordEntity? get latest =>
      records.isNotEmpty ? records.first : null;

  /// Previous record for change calculation.
  GrowthRecordEntity? get previous =>
      records.length >= 2 ? records[1] : null;

  /// Weight change: current - previous (claude.md §3C formula).
  double get weightChange {
    if (latest == null || previous == null) return 0;
    return latest!.weightKg - previous!.weightKg;
  }

  /// Height change: current - previous.
  double get heightChange {
    if (latest == null || previous == null) return 0;
    return latest!.heightCm - previous!.heightCm;
  }

  GrowthState copyWith({
    GrowthStatus? status,
    List<GrowthRecordEntity>? records,
    String? message,
    bool? isWeightMode,
  }) {
    return GrowthState(
      status: status ?? this.status,
      records: records ?? this.records,
      message: message ?? this.message,
      isWeightMode: isWeightMode ?? this.isWeightMode,
    );
  }

  @override
  List<Object?> get props => [status, records, message, isWeightMode];
}
