enum GrowthStatus { initial, loading, success, failure }

class GrowthState {
  const GrowthState({
    this.status = GrowthStatus.initial,
    this.message = '',
  });

  final GrowthStatus status;
  final String message;

  GrowthState copyWith({
    GrowthStatus? status,
    String? message,
  }) {
    return GrowthState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
