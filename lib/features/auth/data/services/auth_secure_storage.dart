import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSecureStorage {
  AuthSecureStorage._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const _loggedInKey = 'is_logged_in';
  static const _phoneKey = 'auth_phone';

  static Future<void> saveSession(String phone) async {
    await _storage.write(key: _loggedInKey, value: 'true');
    await _storage.write(key: _phoneKey, value: phone);
  }

  static Future<bool> isLoggedIn() async {
    return await _storage.read(key: _loggedInKey) == 'true';
  }

  static Future<String?> getPhone() => _storage.read(key: _phoneKey);

  static Future<void> clearSession() async {
    await _storage.delete(key: _loggedInKey);
    await _storage.delete(key: _phoneKey);
  }
}
