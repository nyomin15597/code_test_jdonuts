import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../data/models/user_model.dart';
import '../data/services/auth_service.dart';

final databaseServiceProvider = Provider<AppDatabase>(
  (ref) => AppDatabase.instance,
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(databaseServiceProvider)),
);

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.phone = '',
    this.firstName = '',
    this.lastName = '',
    this.isLoggedIn = false,
  });

  final bool isLoading;
  final String? errorMessage;
  final String phone;
  final String firstName;
  final String lastName;
  final bool isLoggedIn;

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? phone,
    String? firstName,
    String? lastName,
    bool? isLoggedIn,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._service) : super(const AuthState());

  final AuthService _service;

  void setPhone(String phone) =>
      state = state.copyWith(phone: phone, clearError: true);

  void setName({required String firstName, String lastName = ''}) {
    state = state.copyWith(
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      clearError: true,
    );
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final valid = await _service.verifyOtp(otp);
      if (!valid) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid OTP code. Try 123456',
        );
        return false;
      }
      final exists = await _service.userExists(state.phone);
      if (exists) {
        await _service.login(state.phone);
        state = state.copyWith(isLoading: false, isLoggedIn: true);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required DateTime dob,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _service.registerUser(UserModel(
        phone: state.phone,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        dob: '${dob.month}/${dob.day}/${dob.year}',
      ));
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to save your profile.',
      );
      return false;
    }
  }

  Future<bool> restoreSession() async {
    final loggedIn = await _service.hasSession();
    final phone = await _service.sessionPhone();
    state = state.copyWith(isLoggedIn: loggedIn, phone: phone ?? '');
    return loggedIn;
  }

  Future<void> logout() async {
    await _service.logout();
    state = state.copyWith(
      isLoggedIn: false,
      phone: '',
      firstName: '',
      lastName: '',
    );
  }

  void clearError() => state = state.copyWith(clearError: true);
}
