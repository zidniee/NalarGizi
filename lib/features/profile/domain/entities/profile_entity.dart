import 'package:equatable/equatable.dart';
import 'package:nalargizi/features/auth/domain/entities/auth_entity.dart';

/// Entity representing parent and child profile data.
class ProfileEntity extends Equatable {
  const ProfileEntity({
    required this.user,
    this.child,
  });

  final UserEntity user;
  final ChildEntity? child;

  @override
  List<Object?> get props => [user, child];
}
