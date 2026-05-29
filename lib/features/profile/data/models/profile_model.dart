import 'package:nalargizi/features/auth/data/models/child_model.dart';
import 'package:nalargizi/features/auth/data/models/user_model.dart';
import '../../domain/entities/profile_entity.dart';

/// Data model for Profile details.
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.user,
    super.child,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>).toEntity(),
      child: json['child'] != null
          ? ChildModel.fromJson(json['child'] as Map<String, dynamic>).toEntity()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'phone_number': user.phoneNumber,
        'email_verified_at': user.emailVerifiedAt,
      },
      'child': child != null
          ? {
              'id': child!.id,
              'user_id': child!.userId,
              'name': child!.name,
              'birth_date': child!.birthDate,
              'gender': child!.gender,
            }
          : null,
    };
  }
}
