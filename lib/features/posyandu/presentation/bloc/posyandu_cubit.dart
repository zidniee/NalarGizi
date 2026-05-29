import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/posyandu_schedule_item_entity.dart';
import '../../domain/repositories/posyandu_repository.dart';
import '../../domain/usecases/get_posyandu_data_usecase.dart';

import 'posyandu_state.dart';

/// Cubit managing Posyandu overview and immunization state.
///
/// Source: claude2.md §3 — DI Instantiation using GetIt
class PosyanduCubit extends Cubit<PosyanduState> {
  PosyanduCubit(
    this._getPosyanduDataUseCase,
    this._repository,
  ) : super(const PosyanduState());

  final GetPosyanduDataUseCase _getPosyanduDataUseCase;
  final PosyanduRepository _repository;

  Future<void> load({int childId = 1}) async {
    emit(state.copyWith(status: PosyanduStatus.loading, message: ''));

    final result = await _getPosyanduDataUseCase(childId: childId);

    if (result.failure != null) {
      emit(
        state.copyWith(
          status: PosyanduStatus.failure,
          message: result.failure!.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PosyanduStatus.success,
          data: result.data,
        ),
      );
    }
  }

  /// Sends PATCH to mark a schedule as completed, persisting the state change
  /// to the backend/mock. Returns true on success, false on failure.
  Future<bool> markCompleted(String scheduleId) async {
    final failure = await _repository.markScheduleCompleted(scheduleId);
    return failure == null;
  }

  /// POSTs a new posyandu schedule to the backend and saves it locally.
  /// Returns true on success, false on failure.
  Future<bool> addSchedule(PosyanduScheduleItemEntity schedule) async {
    final failure = await _repository.addSchedule(schedule);
    return failure == null;
  }
}
