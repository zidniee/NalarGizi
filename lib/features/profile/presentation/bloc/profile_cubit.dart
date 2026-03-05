import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  Future<void> load() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    await Future<void>.delayed(const Duration(milliseconds: 300));

    emit(state.copyWith(status: ProfileStatus.success));
  }
}
