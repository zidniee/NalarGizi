import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_growth_records_usecase.dart';
import '../../domain/usecases/add_growth_record_usecase.dart';
import 'growth_state.dart';

/// Cubit managing Growth tracking screen state.
///
/// Source: claude1.md §STATE MANAGEMENT RULES — Cubit Only
/// Source: claude1.md §96-104 — Business logic here (weight/height change calculation)
/// Source: claude2.md §3 — Instantiated via GetIt.I<GrowthCubit>()
class GrowthCubit extends Cubit<GrowthState> {
  GrowthCubit({
    required this.getGrowthRecordsUseCase,
    required this.addGrowthRecordUseCase,
  }) : super(const GrowthState());

  final GetGrowthRecordsUseCase getGrowthRecordsUseCase;
  final AddGrowthRecordUseCase addGrowthRecordUseCase;

  /// Load all growth records for the child.
  Future<void> loadRecords({int childId = 1}) async {
    emit(state.copyWith(status: GrowthStatus.loading));

    final result = await getGrowthRecordsUseCase(childId: childId);

    if (result.failure != null) {
      emit(state.copyWith(
        status: GrowthStatus.failure,
        message: result.failure!.message,
      ));
    } else if (result.data == null || result.data!.isEmpty) {
      emit(state.copyWith(
        status: GrowthStatus.empty,
        records: [],
      ));
    } else {
      emit(state.copyWith(
        status: GrowthStatus.success,
        records: result.data!,
      ));
    }
  }

  /// Switch between weight (BB) and height (TB) display mode.
  /// UI toggle — belongs in Cubit, not Widget (claude1.md §96).
  void switchMode({required bool isWeightMode}) {
    emit(state.copyWith(isWeightMode: isWeightMode));
  }

  /// Add a new growth measurement record.
  /// POST /api/growth/records (claude.md §3C)
  Future<void> addRecord({
    required double weightKg,
    required double heightCm,
    required double headCircumferenceCm,
    required int ageMonths,
    required String recordedAt,
  }) async {
    emit(state.copyWith(status: GrowthStatus.loading));

    final result = await addGrowthRecordUseCase({
      'child_id': 1,
      'age_months': ageMonths,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'head_circumference_cm': headCircumferenceCm,
      'recorded_at': recordedAt,
    });

    if (result.failure != null) {
      emit(state.copyWith(
        status: GrowthStatus.failure,
        message: result.failure!.message,
      ));
    } else {
      // Prepend new record to the list
      final updatedRecords = [result.data!, ...state.records];
      emit(state.copyWith(
        status: GrowthStatus.success,
        records: updatedRecords,
      ));
    }
  }

  /// Retry after failure.
  Future<void> retry({int childId = 1}) => loadRecords(childId: childId);
}
