import '../../domain/entities/immunization_item_entity.dart';

class ImmunizationItemModel extends ImmunizationItemEntity {
  const ImmunizationItemModel({
    required super.name,
    required super.isDone,
  });

  factory ImmunizationItemModel.fromMap(Map<String, dynamic> map) {
    return ImmunizationItemModel(
      name: map['name'] as String,
      isDone: (map['is_done'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'is_done': isDone,
    };
  }
}