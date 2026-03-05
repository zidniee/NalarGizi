import '../models/dashboard_model.dart';

class DashboardRemoteDataSource {
  Future<DashboardModel> fetchDashboardData() async {
    return const DashboardModel(
      id: '1',
      title: 'Dashboard Data',
      description: 'Replace this mock with real API call.',
    );
  }
}
