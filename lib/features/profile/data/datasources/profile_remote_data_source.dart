import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfileData() async {
    return const ProfileModel(
      id: '1',
      title: 'Profile Data',
      description: 'Replace this mock with real API call.',
    );
  }
}
