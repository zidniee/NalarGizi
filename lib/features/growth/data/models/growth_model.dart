import '../../domain/entities/growth_entity.dart';

/// Data model for a growth record — maps JSON ↔ GrowthRecordEntity.
///
/// Source: claude.md §3C JSON mock
/// Source: claude1.md §MODEL RULES — fromJson/toJson/toEntity
class GrowthRecordModel {
  const GrowthRecordModel({
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

  factory GrowthRecordModel.fromJson(Map<String, dynamic> json) {
    return GrowthRecordModel(
      id: json['id'] as int,
      childId: json['child_id'] as int,
      ageMonths: json['age_months'] as int,
      weightKg: (json['weight_kg'] as num).toDouble(),
      heightCm: (json['height_cm'] as num).toDouble(),
      headCircumferenceCm:
          (json['head_circumference_cm'] as num).toDouble(),
      zScoreStatus: json['z_score_status'] as String,
      recordedAt: json['recorded_at'] as String,
    );
  }

  /// Also used by GrowthLocalDataSource (Hive).
  factory GrowthRecordModel.fromMap(Map<String, dynamic> map) =>
      GrowthRecordModel.fromJson(map);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'age_months': ageMonths,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'head_circumference_cm': headCircumferenceCm,
      'z_score_status': zScoreStatus,
      'recorded_at': recordedAt,
    };
  }

  /// Alias for Hive storage (same as toJson).
  Map<String, dynamic> toMap() => toJson();

  GrowthRecordEntity toEntity() {
    return GrowthRecordEntity(
      id: id,
      childId: childId,
      ageMonths: ageMonths,
      weightKg: weightKg,
      heightCm: heightCm,
      headCircumferenceCm: headCircumferenceCm,
      zScoreStatus: zScoreStatus,
      recordedAt: recordedAt,
    );
  }

  /// Used for Hive child-id comparison.
  String get measuredAt => recordedAt;
}
