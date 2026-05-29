import '../../domain/entities/dashboard_entity.dart';

/// Data model for Dashboard overview response.
///
/// Source: claude.md §3B JSON mock
/// Source: claude1.md §MODEL RULES — fromJson/toJson/toEntity
class DashboardOverviewModel {
  const DashboardOverviewModel({
    required this.childInfo,
    required this.lastGrowth,
    required this.dailyTip,
    this.nearestSchedule,
    required this.posyanduCenter,
    required this.educationalContents,
  });

  final ChildInfoModel childInfo;
  final LastGrowthModel lastGrowth;
  final DailyTipModel dailyTip;
  final NearestScheduleModel? nearestSchedule;
  final PosyanduCenterModel posyanduCenter;
  final List<EducationalContentModel> educationalContents;

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    return DashboardOverviewModel(
      childInfo: ChildInfoModel.fromJson(
          json['child_info'] as Map<String, dynamic>),
      lastGrowth: LastGrowthModel.fromJson(
          json['last_growth'] as Map<String, dynamic>),
      dailyTip: DailyTipModel.fromJson(
          json['daily_tip'] as Map<String, dynamic>),
      nearestSchedule: json['nearest_schedule'] != null
          ? NearestScheduleModel.fromJson(
              json['nearest_schedule'] as Map<String, dynamic>)
          : null,
      posyanduCenter: PosyanduCenterModel.fromJson(
          json['posyandu_center'] as Map<String, dynamic>),
      educationalContents: (json['educational_contents'] as List<dynamic>)
          .map((e) => EducationalContentModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }

  DashboardOverviewEntity toEntity() {
    return DashboardOverviewEntity(
      childInfo: childInfo.toEntity(),
      lastGrowth: lastGrowth.toEntity(),
      dailyTip: dailyTip.toEntity(),
      nearestSchedule: nearestSchedule?.toEntity(),
      posyanduCenter: posyanduCenter.toEntity(),
      educationalContents:
          educationalContents.map((e) => e.toEntity()).toList(),
    );
  }
}

class ChildInfoModel {
  const ChildInfoModel({
    required this.name,
    required this.ageMonths,
    required this.gender,
  });

  final String name;
  final int ageMonths;
  final String gender;

  factory ChildInfoModel.fromJson(Map<String, dynamic> json) {
    return ChildInfoModel(
      name: json['name'] as String,
      ageMonths: json['age_months'] as int,
      gender: json['gender'] as String,
    );
  }

  ChildInfoEntity toEntity() =>
      ChildInfoEntity(name: name, ageMonths: ageMonths, gender: gender);
}

class LastGrowthModel {
  const LastGrowthModel({
    required this.weightKg,
    required this.heightCm,
    required this.zScoreStatus,
    required this.recordedAt,
  });

  final double weightKg;
  final double heightCm;
  final String zScoreStatus;
  final String recordedAt;

  factory LastGrowthModel.fromJson(Map<String, dynamic> json) {
    return LastGrowthModel(
      weightKg: (json['weight_kg'] as num).toDouble(),
      heightCm: (json['height_cm'] as num).toDouble(),
      zScoreStatus: json['z_score_status'] as String,
      recordedAt: json['recorded_at'] as String,
    );
  }

  LastGrowthEntity toEntity() => LastGrowthEntity(
    weightKg: weightKg,
    heightCm: heightCm,
    zScoreStatus: zScoreStatus,
    recordedAt: recordedAt,
  );
}

class DailyTipModel {
  const DailyTipModel({required this.title, required this.content});

  final String title;
  final String content;

  factory DailyTipModel.fromJson(Map<String, dynamic> json) {
    return DailyTipModel(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  DailyTipEntity toEntity() => DailyTipEntity(title: title, content: content);
}

class NearestScheduleModel {
  const NearestScheduleModel({
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

  factory NearestScheduleModel.fromJson(Map<String, dynamic> json) {
    return NearestScheduleModel(
      id: json['id'] as int,
      posyanduCenterName: json['posyandu_center_name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: json['event_date'] as String,
    );
  }

  NearestScheduleEntity toEntity() => NearestScheduleEntity(
    id: id,
    posyanduCenterName: posyanduCenterName,
    title: title,
    description: description,
    eventDate: eventDate,
  );
}

class PosyanduCenterModel {
  const PosyanduCenterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.leaderName,
  });

  final int id;
  final String name;
  final String address;
  final String leaderName;

  factory PosyanduCenterModel.fromJson(Map<String, dynamic> json) {
    return PosyanduCenterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      leaderName: json['leader_name'] as String,
    );
  }

  PosyanduCenterEntity toEntity() => PosyanduCenterEntity(
    id: id,
    name: name,
    address: address,
    leaderName: leaderName,
  );
}

class EducationalContentModel {
  const EducationalContentModel({
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

  factory EducationalContentModel.fromJson(Map<String, dynamic> json) {
    return EducationalContentModel(
      id: json['id'] as int,
      title: json['title'] as String,
      mediaUrl: json['media_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      duration: json['duration'] as String,
    );
  }

  EducationalContentEntity toEntity() => EducationalContentEntity(
    id: id,
    title: title,
    mediaUrl: mediaUrl,
    thumbnailUrl: thumbnailUrl,
    duration: duration,
  );
}
