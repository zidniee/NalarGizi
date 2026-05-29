import 'package:equatable/equatable.dart';

/// Entity representing a single meal log (breakfast, lunch, dinner).
class NutritionMealEntity extends Equatable {
  final String id;
  final String nutritionJournalId;
  final String mealTime; // e.g. 'breakfast', 'lunch', 'dinner'
  final String timeLabel; // e.g. '07:00', '12:30', '18:00'
  final String? foodName;
  final String? portion;
  final int calories;
  final String status; // e.g. 'Habis', 'Sisa Sedikit', 'Belum Mencatat'
  final int carbohydrateG;
  final int proteinG;
  final int fatG;

  const NutritionMealEntity({
    required this.id,
    required this.nutritionJournalId,
    required this.mealTime,
    required this.timeLabel,
    this.foodName,
    this.portion,
    required this.calories,
    required this.status,
    this.carbohydrateG = 0,
    this.proteinG = 0,
    this.fatG = 0,
  });

  NutritionMealEntity copyWith({
    String? id,
    String? nutritionJournalId,
    String? mealTime,
    String? timeLabel,
    String? foodName,
    String? portion,
    int? calories,
    String? status,
    int? carbohydrateG,
    int? proteinG,
    int? fatG,
  }) {
    return NutritionMealEntity(
      id: id ?? this.id,
      nutritionJournalId: nutritionJournalId ?? this.nutritionJournalId,
      mealTime: mealTime ?? this.mealTime,
      timeLabel: timeLabel ?? this.timeLabel,
      foodName: foodName ?? this.foodName,
      portion: portion ?? this.portion,
      calories: calories ?? this.calories,
      status: status ?? this.status,
      carbohydrateG: carbohydrateG ?? this.carbohydrateG,
      proteinG: proteinG ?? this.proteinG,
      fatG: fatG ?? this.fatG,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nutritionJournalId,
        mealTime,
        timeLabel,
        foodName,
        portion,
        calories,
        status,
        carbohydrateG,
        proteinG,
        fatG,
      ];
}

/// Entity representing daily water hydration progress.
class HydrationLogEntity extends Equatable {
  final String id;
  final String childId;
  final DateTime logDate;
  final int glassesDone;
  final int glassesTarget;

  const HydrationLogEntity({
    required this.id,
    required this.childId,
    required this.logDate,
    required this.glassesDone,
    required this.glassesTarget,
  });

  HydrationLogEntity copyWith({
    String? id,
    String? childId,
    DateTime? logDate,
    int? glassesDone,
    int? glassesTarget,
  }) {
    return HydrationLogEntity(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      logDate: logDate ?? this.logDate,
      glassesDone: glassesDone ?? this.glassesDone,
      glassesTarget: glassesTarget ?? this.glassesTarget,
    );
  }

  @override
  List<Object?> get props => [id, childId, logDate, glassesDone, glassesTarget];
}

/// Entity representing daily calorie summaries.
class NutritionJournalEntity extends Equatable {
  final String id;
  final String childId;
  final DateTime journalDate;
  final int targetCalories;
  final int consumedCalories;
  final int remainingCalories;

  const NutritionJournalEntity({
    required this.id,
    required this.childId,
    required this.journalDate,
    required this.targetCalories,
    required this.consumedCalories,
    required this.remainingCalories,
  });

  @override
  List<Object?> get props => [
        id,
        childId,
        journalDate,
        targetCalories,
        consumedCalories,
        remainingCalories,
      ];
}

/// Consolidated entity wrapping the daily summary, meal lists, and hydration status for UI presentation.
class NutritionDailyEntity extends Equatable {
  final NutritionJournalEntity? journal;
  final List<NutritionMealEntity> meals;
  final HydrationLogEntity? hydration;

  const NutritionDailyEntity({
    this.journal,
    required this.meals,
    this.hydration,
  });

  int get targetCalories => journal?.targetCalories ?? 1100;
  int get consumedCalories => journal?.consumedCalories ?? 0;
  int get remainingCalories => journal?.remainingCalories ?? 1100;
  int get hydrationGlassesDone => hydration?.glassesDone ?? 0;
  int get hydrationGlassesTarget => hydration?.glassesTarget ?? 6;

  int get consumedCarbs => meals.fold(0, (sum, m) => sum + m.carbohydrateG);
  int get targetCarbs => 150;
  int get consumedProtein => meals.fold(0, (sum, m) => sum + m.proteinG);
  int get targetProtein => 40;
  int get consumedFat => meals.fold(0, (sum, m) => sum + m.fatG);
  int get targetFat => 35;

  @override
  List<Object?> get props => [journal, meals, hydration];
}
