import 'package:flutter_bloc/flutter_bloc.dart';

import 'posyandu_state.dart';

class PosyanduCubit extends Cubit<PosyanduState> {
  PosyanduCubit() : super(const PosyanduState());

  Future<void> load() async {
    emit(state.copyWith(status: PosyanduStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: PosyanduStatus.success));
  }
}
