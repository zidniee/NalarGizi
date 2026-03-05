enum PosyanduStatus { initial, loading, success, failure }

class PosyanduState {
  const PosyanduState({
    this.status = PosyanduStatus.initial,
    this.message = '',
  });

  final PosyanduStatus status;
  final String message;

  PosyanduState copyWith({
    PosyanduStatus? status,
    String? message,
  }) {
    return PosyanduState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
