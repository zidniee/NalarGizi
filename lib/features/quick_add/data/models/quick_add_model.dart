import '../../domain/entities/quick_add_entity.dart';

class QuickAddModel extends QuickAddEntity {
  const QuickAddModel({
    required super.id,
    required super.title,
    required super.description,
  });

  factory QuickAddModel.fromMap(Map<String, dynamic> map) {
    return QuickAddModel(
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
