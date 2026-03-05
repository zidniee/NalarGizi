import 'package:flutter_bloc/flutter_bloc.dart';

import 'growth_state.dart';

class GrowthCubit extends Cubit<GrowthState> {
  GrowthCubit() : super(const GrowthState());

  Future<void> load() async {
    emit(state.copyWith(status: GrowthStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: GrowthStatus.success));
  }
}
