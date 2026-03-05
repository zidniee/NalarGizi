import '../../domain/entities/posyandu_entity.dart';

class PosyanduModel extends PosyanduEntity {
  const PosyanduModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory PosyanduModel.fromMap(Map<String, dynamic> map) {
    return PosyanduModel(
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
