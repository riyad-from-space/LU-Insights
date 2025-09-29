// abstract class AuthState {
//   const AuthState();

// }

// class AuthInitial extends AuthState {
//   const AuthInitial();
// }
// class AusthLoading extends AuthState {
//   const AusthLoading();
// }
// class Authenticated extends AuthState {
//   const Authenticated();
// }

import 'package:insights/features/auth/model/user_model.dart';

class AuthStateGeneric {
  const AuthStateGeneric({
    this.user,
    this.isLoading = false,
    this.isError = false,
  });

  final UserModel? user;
  final bool isLoading;
  final bool isError;

  AuthStateGeneric copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isError,
  }) {
    return AuthStateGeneric(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}
