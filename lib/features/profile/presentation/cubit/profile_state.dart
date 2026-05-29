import 'package:equatable/equatable.dart';
import 'package:nalargizi/features/growth/domain/entities/growth_entity.dart';
import '../../domain/entities/profile_entity.dart';

enum ProfileStatus { initial, loading, success, failure }

/// State containing all data needed by the Profile screen.
class ProfileState extends Equatable {
  final ProfileStatus status;
  final String message;
  final ProfileEntity? profile;
  final List<GrowthRecordEntity> history;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.message = '',
    this.profile,
    this.history = const [],
  });

  @override
  List<Object?> get props => [status, message, profile, history];

  ProfileState copyWith({
    ProfileStatus? status,
    String? message,
    ProfileEntity? profile,
    List<GrowthRecordEntity>? history,
  }) {
    return ProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
      profile: profile ?? this.profile,
      history: history ?? this.history,
    );
  }
}
