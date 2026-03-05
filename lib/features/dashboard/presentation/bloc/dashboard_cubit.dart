import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  Future<void> load() async {
    emit(state.copyWith(status: DashboardStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: DashboardStatus.success));
  }
}
