import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Status for Dashboard loading states.
enum DashboardStatus { initial, loading, success, empty, failure }

/// State for the Dashboard Cubit.
///
/// Source: claude1.md §UI RULES — Loading, Empty, Error, Success states
/// Source: claude1.md §STATE MANAGEMENT RULES — Immutable, Equatable
class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.overview,
    this.message = '',
  });

  final DashboardStatus status;
  final DashboardOverviewEntity? overview;
  final String message;

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardOverviewEntity? overview,
    String? message,
  }) {
    return DashboardState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, overview, message];
}
