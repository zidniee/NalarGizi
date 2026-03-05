enum ProfileStatus { initial, loading, success, failure }

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.message = '',
  });

  final ProfileStatus status;
  final String message;

  ProfileState copyWith({
    ProfileStatus? status,
    String? message,
  }) {
    return ProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
