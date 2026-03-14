import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nalargizi/core/network/network_exception.dart';

import '../../domain/usecases/get_posyandu_data_usecase.dart';

import 'posyandu_state.dart';

class PosyanduCubit extends Cubit<PosyanduState> {
  PosyanduCubit(this._getPosyanduDataUseCase) : super(const PosyanduState());

  final GetPosyanduDataUseCase _getPosyanduDataUseCase;

  Future<void> load() async {
    emit(state.copyWith(status: PosyanduStatus.loading, message: ''));

    try {
      final result = await _getPosyanduDataUseCase();
      emit(state.copyWith(status: PosyanduStatus.success, data: result));
    } on NetworkException catch (error) {
      emit(
        state.copyWith(status: PosyanduStatus.failure, message: error.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PosyanduStatus.failure,
          message: 'Gagal memuat data posyandu. Coba lagi.',
        ),
      );
    }
  }
}
