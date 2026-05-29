import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import 'profile_state.dart';

/// Cubit managing Profile loading (info & history).
class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final GetHistoryUseCase _getHistoryUseCase;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required GetHistoryUseCase getHistoryUseCase,
  })  : _getProfileUseCase = getProfileUseCase,
        _getHistoryUseCase = getHistoryUseCase,
        super(const ProfileState());

  /// Loads profile details and growth measurement logs.
  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    final profileResult = await _getProfileUseCase();
    if (profileResult.failure != null) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        message: profileResult.failure!.message,
      ));
      return;
    }

    final historyResult = await _getHistoryUseCase();
    if (historyResult.failure != null) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        message: historyResult.failure!.message,
      ));
      return;
    }

    emit(state.copyWith(
      status: ProfileStatus.success,
      profile: profileResult.data,
      history: historyResult.data ?? [],
    ));
  }
}
