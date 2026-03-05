import 'package:flutter_bloc/flutter_bloc.dart';

import 'quick_add_state.dart';

class QuickAddCubit extends Cubit<QuickAddState> {
  QuickAddCubit() : super(const QuickAddState());

  Future<void> load() async {
    emit(state.copyWith(status: QuickAddStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: QuickAddStatus.success));
  }
}
