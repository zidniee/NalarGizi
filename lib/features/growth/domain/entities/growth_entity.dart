import 'package:equatable/equatable.dart';

/// Domain entity for a single growth measurement record.
///
/// Source: claude.md §3C JSON mock (ERD: GROWTH_RECORDS table)
/// Source: claude1.md §ENTITY RULES — Immutable, Equatable, Framework Independent
///
/// Fields exactly match ERD: id, child_id, age_months, weight_kg, height_cm,
/// head_circumference_cm, z_score_status, recorded_at
class GrowthRecordEntity extends Equatable {
  const GrowthRecordEntity({
    required this.id,
    required this.childId,
    required this.ageMonths,
    required this.weightKg,
    required this.heightCm,
    required this.headCircumferenceCm,
    required this.zScoreStatus,
    required this.recordedAt,
  });

  final int id;
  final int childId;
  final int ageMonths;
  final double weightKg;
  final double heightCm;
  final double headCircumferenceCm;
  final String zScoreStatus;
  final String recordedAt;

  @override
  List<Object?> get props => [
    id, childId, ageMonths, weightKg, heightCm,
    headCircumferenceCm, zScoreStatus, recordedAt,
  ];
}
