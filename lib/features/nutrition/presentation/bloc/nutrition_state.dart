enum NutritionStatus { initial, loading, success, failure }

class NutritionState {
  const NutritionState({
    this.status = NutritionStatus.initial,
    this.message = '',
  });

  final NutritionStatus status;
  final String message;

  NutritionState copyWith({
    NutritionStatus? status,
    String? message,
  }) {
    return NutritionState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
