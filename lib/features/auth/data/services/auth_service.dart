import '../../../../core/database/app_database.dart';
import '../models/user_model.dart';
import 'auth_secure_storage.dart';

class AuthService {
  AuthService(this._database);

  final AppDatabase _database;

  static const String demoOtp = '123456';

  Future<bool> verifyOtp(String otp) async => otp == demoOtp;

  Future<bool> userExists(String phone) async {
    return await _database.getUser(phone) != null;
  }

  Future<void> registerUser(UserModel user) async {
    await _database.saveUser(
      phone: user.phone,
      firstName: user.firstName,
      lastName: user.lastName,
      dob: user.dob,
    );
    await AuthSecureStorage.saveSession(user.phone);
  }

  Future<void> login(String phone) => AuthSecureStorage.saveSession(phone);

  Future<void> logout() => AuthSecureStorage.clearSession();

  Future<bool> hasSession() => AuthSecureStorage.isLoggedIn();

  Future<String?> sessionPhone() => AuthSecureStorage.getPhone();
}
