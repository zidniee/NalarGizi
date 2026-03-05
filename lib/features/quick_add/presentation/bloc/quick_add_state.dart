enum QuickAddStatus { initial, loading, success, failure }

class QuickAddState {
  const QuickAddState({
    this.status = QuickAddStatus.initial,
    this.message = '',
  });

  final QuickAddStatus status;
  final String message;

  QuickAddState copyWith({
    QuickAddStatus? status,
    String? message,
  }) {
    return QuickAddState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
