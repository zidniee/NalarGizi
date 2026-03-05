import '../../domain/entities/nutrition_entity.dart';

class NutritionModel extends NutritionEntity {
  const NutritionModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory NutritionModel.fromMap(Map<String, dynamic> map) {
    return NutritionModel(
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
