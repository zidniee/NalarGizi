import '../models/growth_model.dart';

class GrowthRemoteDataSource {
  Future<GrowthModel> fetchGrowthData() async {
    return const GrowthModel(
      id: '1',
      title: 'Growth Data',
      description: 'Replace this mock with real API call.',
    );
  }
}
