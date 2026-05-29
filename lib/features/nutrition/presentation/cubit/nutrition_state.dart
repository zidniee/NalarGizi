import 'package:equatable/equatable.dart';
import '../../domain/entities/nutrition_entity.dart';

/// Nutrition display status states.
enum NutritionStatus { initial, loading, success, failure }

/// State containing all data needed by the Nutrition screen.
class NutritionState extends Equatable {
  final NutritionStatus status;
  final String message;
  final NutritionDailyEntity? dailyData;
  final String selectedDate; // Formatted as YYYY-MM-DD

  const NutritionState({
    this.status = NutritionStatus.initial,
    this.message = '',
    this.dailyData,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [status, message, dailyData, selectedDate];

  NutritionState copyWith({
    NutritionStatus? status,
    String? message,
    NutritionDailyEntity? dailyData,
    String? selectedDate,
  }) {
    return NutritionState(
      status: status ?? this.status,
      message: message ?? this.message,
      dailyData: dailyData ?? this.dailyData,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
