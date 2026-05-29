import 'package:equatable/equatable.dart';

/// Dashboard overview entity — aggregates all data shown on the home screen.
///
/// Source: claude.md §3B JSON mock (ERD: CHILDREN, GROWTH_RECORDS, EDUCATIONAL_CONTENTS, SCHEDULES, POSYANDU_CENTERS)
/// Source: claude1.md §ENTITY RULES — Immutable, Equatable, Framework Independent
class DashboardOverviewEntity extends Equatable {
  const DashboardOverviewEntity({
    required this.childInfo,
    required this.lastGrowth,
    required this.dailyTip,
    this.nearestSchedule,
    required this.posyanduCenter,
    required this.educationalContents,
  });

  final ChildInfoEntity childInfo;
  final LastGrowthEntity lastGrowth;
  final DailyTipEntity dailyTip;
  final NearestScheduleEntity? nearestSchedule;
  final PosyanduCenterEntity posyanduCenter;
  final List<EducationalContentEntity> educationalContents;

  @override
  List<Object?> get props => [
    childInfo, lastGrowth, dailyTip,
    nearestSchedule, posyanduCenter, educationalContents,
  ];
}

class ChildInfoEntity extends Equatable {
  const ChildInfoEntity({
    required this.name,
    required this.ageMonths,
    required this.gender,
  });

  final String name;
  final int ageMonths;
  final String gender;

  @override
  List<Object?> get props => [name, ageMonths, gender];
}

class LastGrowthEntity extends Equatable {
  const LastGrowthEntity({
    required this.weightKg,
    required this.heightCm,
    required this.zScoreStatus,
    required this.recordedAt,
  });

  final double weightKg;
  final double heightCm;
  final String zScoreStatus;
  final String recordedAt;

  @override
  List<Object?> get props => [weightKg, heightCm, zScoreStatus, recordedAt];
}

class DailyTipEntity extends Equatable {
  const DailyTipEntity({required this.title, required this.content});

  final String title;
  final String content;

  @override
  List<Object?> get props => [title, content];
}

class NearestScheduleEntity extends Equatable {
  const NearestScheduleEntity({
    required this.id,
    required this.posyanduCenterName,
    required this.title,
    required this.description,
    required this.eventDate,
  });

  final int id;
  final String posyanduCenterName;
  final String title;
  final String description;
  final String eventDate;

  @override
  List<Object?> get props => [id, posyanduCenterName, title, description, eventDate];
}

class PosyanduCenterEntity extends Equatable {
  const PosyanduCenterEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.leaderName,
  });

  final int id;
  final String name;
  final String address;
  final String leaderName;

  @override
  List<Object?> get props => [id, name, address, leaderName];
}

class EducationalContentEntity extends Equatable {
  const EducationalContentEntity({
    required this.id,
    required this.title,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.duration,
  });

  final int id;
  final String title;
  final String mediaUrl;
  final String thumbnailUrl;
  final String duration;

  @override
  List<Object?> get props => [id, title, mediaUrl, thumbnailUrl, duration];
}
