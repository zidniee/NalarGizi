import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_dashboard_overview_usecase.dart';
import 'dashboard_state.dart';

/// Cubit managing Dashboard screen state.
///
/// Source: claude1.md §STATE MANAGEMENT RULES — Cubit Only
/// Source: claude1.md §96-104 — Business logic here, NOT in widgets
/// Source: claude2.md §3 — Instantiated via GetIt.I<DashboardCubit>()
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getOverviewUseCase) : super(const DashboardState());

  final GetDashboardOverviewUseCase _getOverviewUseCase;

  /// Load dashboard overview. Called once on page init.
  Future<void> loadOverview({int childId = 1}) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    final result = await _getOverviewUseCase(childId: childId);

    if (result.failure != null) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        message: result.failure!.message,
      ));
    } else if (result.data == null ||
        result.data!.educationalContents.isEmpty) {
      emit(state.copyWith(
        status: DashboardStatus.empty,
        overview: result.data,
      ));
    } else {
      emit(state.copyWith(
        status: DashboardStatus.success,
        overview: result.data,
      ));
    }
  }

  /// Retry after failure.
  Future<void> retry({int childId = 1}) => loadOverview(childId: childId);
}
