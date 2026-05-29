import '../../domain/entities/nutrition_entity.dart';

/// Data model representing daily calorie progress.
class NutritionJournalModel extends NutritionJournalEntity {
  const NutritionJournalModel({
    required super.id,
    required super.childId,
    required super.journalDate,
    required super.targetCalories,
    required super.consumedCalories,
    required super.remainingCalories,
  });

  factory NutritionJournalModel.fromMap(Map<String, dynamic> map) {
    return NutritionJournalModel(
      id: map['id'] as String? ?? '',
      childId: map['childId'] as String? ?? '',
      journalDate: map['journalDate'] != null 
          ? DateTime.parse(map['journalDate'] as String)
          : DateTime.now(),
      targetCalories: (map['targetCalories'] as num?)?.toInt() ?? 0,
      consumedCalories: (map['consumedCalories'] as num?)?.toInt() ?? 0,
      remainingCalories: (map['remainingCalories'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'journalDate': journalDate.toIso8601String(),
      'targetCalories': targetCalories,
      'consumedCalories': consumedCalories,
      'remainingCalories': remainingCalories,
    };
  }
}

/// Data model representing a meal log.
class NutritionMealModel extends NutritionMealEntity {
  const NutritionMealModel({
    required super.id,
    required super.nutritionJournalId,
    required super.mealTime,
    required super.timeLabel,
    super.foodName,
    super.portion,
    required super.calories,
    required super.status,
    super.carbohydrateG,
    super.proteinG,
    super.fatG,
  });

  factory NutritionMealModel.fromMap(Map<String, dynamic> map) {
    return NutritionMealModel(
      id: map['id']?.toString() ?? '',
      nutritionJournalId: map['nutritionJournalId']?.toString() ?? '',
      mealTime: map['meal_time'] as String? ?? '',
      timeLabel: map['time_label'] as String? ?? '',
      foodName: map['food_name'] as String?,
      portion: map['portion'] as String?,
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      status: map['status'] as String? ?? '',
      carbohydrateG: (map['carbohydrate_g'] as num?)?.toInt() ?? 0,
      proteinG: (map['protein_g'] as num?)?.toInt() ?? 0,
      fatG: (map['fat_g'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nutritionJournalId': nutritionJournalId,
      'meal_time': mealTime,
      'time_label': timeLabel,
      'food_name': foodName,
      'portion': portion,
      'calories': calories,
      'status': status,
      'carbohydrate_g': carbohydrateG,
      'protein_g': proteinG,
      'fat_g': fatG,
    };
  }

  NutritionMealEntity toEntity() => this;
}

/// Data model representing daily water logging.
class HydrationLogModel extends HydrationLogEntity {
  const HydrationLogModel({
    required super.id,
    required super.childId,
    required super.logDate,
    required super.glassesDone,
    required super.glassesTarget,
  });

  factory HydrationLogModel.fromMap(Map<String, dynamic> map) {
    return HydrationLogModel(
      id: map['id'] as String? ?? '',
      childId: map['childId'] as String? ?? '',
      logDate: map['logDate'] != null
          ? DateTime.parse(map['logDate'] as String)
          : DateTime.now(),
      glassesDone: (map['glassesDone'] as num?)?.toInt() ?? 0,
      glassesTarget: (map['glassesTarget'] as num?)?.toInt() ?? 6,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'childId': childId,
      'logDate': logDate.toIso8601String(),
      'glassesDone': glassesDone,
      'glassesTarget': glassesTarget,
    };
  }
}

/// Consolidated data model mapping the complete daily summary JSON from API response.
class NutritionDailyModel extends NutritionDailyEntity {
  const NutritionDailyModel({
    super.journal,
    required super.meals,
    super.hydration,
  });

  factory NutritionDailyModel.fromJson(
    Map<String, dynamic> json, {
    String childId = '1',
    String? date,
  }) {
    final target = (json['target_calories'] as num?)?.toInt() ?? 1100;
    final consumed = (json['consumed_calories'] as num?)?.toInt() ?? 0;
    final remaining = (json['remaining_calories'] as num?)?.toInt() ?? 1100;
    final glassesTarget = (json['hydration_glasses_target'] as num?)?.toInt() ?? 6;
    final glassesDone = (json['hydration_glasses_done'] as num?)?.toInt() ?? 0;

    final dateStr = date ?? DateTime.now().toIso8601String().split('T')[0];
    final journalId = 'journal-$childId-$dateStr';
    final hydrationId = 'hydration-$childId-$dateStr';

    final journal = NutritionJournalModel(
      id: journalId,
      childId: childId,
      journalDate: DateTime.parse(dateStr),
      targetCalories: target,
      consumedCalories: consumed,
      remainingCalories: remaining,
    );

    final meals = (json['meals'] as List<dynamic>? ?? [])
        .map((m) {
          final map = Map<String, dynamic>.from(m as Map);
          map['nutritionJournalId'] = journalId;
          return NutritionMealModel.fromMap(map);
        })
        .toList();

    final hydration = HydrationLogModel(
      id: hydrationId,
      childId: childId,
      logDate: DateTime.parse(dateStr),
      glassesDone: glassesDone,
      glassesTarget: glassesTarget,
    );

    return NutritionDailyModel(
      journal: journal,
      meals: meals,
      hydration: hydration,
    );
  }
}
