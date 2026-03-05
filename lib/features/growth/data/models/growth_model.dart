import '../../domain/entities/growth_entity.dart';

class GrowthModel extends GrowthEntity {
  const GrowthModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory GrowthModel.fromMap(Map<String, dynamic> map) {
    return GrowthModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
