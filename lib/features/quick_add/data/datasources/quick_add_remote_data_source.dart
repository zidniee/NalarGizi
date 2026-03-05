import '../models/quick_add_model.dart';

class QuickAddRemoteDataSource {
  Future<QuickAddModel> fetchQuickAddData() async {
    return const QuickAddModel(
      id: '1',
      title: 'Quick Add Data',
      description: 'Replace this mock with real API call.',
    );
  }
}
