enum DashboardStatus { initial, loading, success, failure }

class DashboardState {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.message = '',
  });

  final DashboardStatus status;
  final String message;

  DashboardState copyWith({
    DashboardStatus? status,
    String? message,
  }) {
    return DashboardState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
