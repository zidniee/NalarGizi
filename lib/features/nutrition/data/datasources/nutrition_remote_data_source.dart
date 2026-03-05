import '../models/nutrition_model.dart';

class NutritionRemoteDataSource {
  Future<NutritionModel> fetchNutritionData() async {
    return const NutritionModel(
      id: '1',
      title: 'Nutrition Data',
      description: 'Replace this mock with real API call.',
    );
  }
}
