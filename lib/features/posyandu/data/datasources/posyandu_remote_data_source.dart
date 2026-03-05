import '../models/posyandu_model.dart';

class PosyanduRemoteDataSource {
  Future<PosyanduModel> fetchPosyanduData() async {
    return const PosyanduModel(
      id: '1',
      title: 'Posyandu Data',
      description: 'Replace this mock with real API call.',
    );
  }
}
