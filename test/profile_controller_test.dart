import 'package:flutter_test/flutter_test.dart';
import 'package:order_tracker_app/controller/profile_controller.dart';
import 'package:order_tracker_app/model/data/remote_data/profile_data.dart';
import 'package:order_tracker_app/model/profile_model.dart';

class FakeProfileData extends ProfileData {
  final ProfileModel? mockUser;
  bool loginCalled = false;

  FakeProfileData({this.mockUser});

  @override
  Future<ProfileModel?> login({
    required String email,
    required String password,
  }) async {
    loginCalled = true;
    if (email == 'admin@test.com' && password == '123456') {
      return mockUser ??
          ProfileModel(
            id: 'usr-1',
            email: 'admin@test.com',
            name: 'Admin User',
            createdAt: DateTime(2026, 7, 27),
          );
    }
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProfileController profileController;
  late FakeProfileData fakeProfileData;

  setUp(() {
    fakeProfileData = FakeProfileData();
    profileController = ProfileController(profileData: fakeProfileData);
  });

  group('ProfileController Tests', () {
    test('updateIsObscure toggles password visibility state', () {
      expect(profileController.isObscure, isTrue);

      profileController.updateIsObscure();
      expect(profileController.isObscure, isFalse);

      profileController.updateIsObscure();
      expect(profileController.isObscure, isTrue);
    });

    test('initial state flags are correctly set', () {
      expect(profileController.isLoading, isFalse);
      expect(profileController.isObscure, isTrue);
    });
  });
}
