import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insights/features/auth/repositories/auth_repository.dart';
import 'package:insights/features/auth/view_model/state/auth_state.dart';

final authStatusProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStateGeneric>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AuthStateGeneric> {
  AuthController(this.ref) : super(const AuthStateGeneric());
  final Ref ref;

  AuthRepository authRepository = AuthRepository();

  Future<void> register({
    required String firstName,
    required String lastName,
    required String userName,
    required String email,
    required String password,
    required int studentId,
  }) async {
    // print(
    //     "Registering user: $firstName, $lastName, $userName, $email, $studentId");
    try {
      state = state.copyWith(isLoading: true);
      final user = await authRepository.register(
        firstName: firstName,
        lastName: lastName,
        userName: userName,
        email: email,
        password: password,
        studentId: studentId,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      // print("Error in register: $e");
      state = state.copyWith(isLoading: false, isError: true);
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await authRepository.login(
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: true);
      rethrow;
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    state =
        const AuthStateGeneric(user: null, isLoading: false, isError: false);
  }
}
