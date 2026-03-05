import 'package:flutter_bloc/flutter_bloc.dart';

import 'nutrition_state.dart';

class NutritionCubit extends Cubit<NutritionState> {
  NutritionCubit() : super(const NutritionState());

  Future<void> load() async {
    emit(state.copyWith(status: NutritionStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: NutritionStatus.success));
  }
}
