import '../models/user.dart';

class LoginResult {
  final bool success;
  final User? user;
  final String? error;
  final int? code;

  LoginResult._({
    required this.success,
    this.user,
    this.error,
    this.code,
  });

  factory LoginResult.success(User user) {
    return LoginResult._(
      success: true,
      user: user,
    );
  }

  factory LoginResult.failure(String error, {int? code}) {
    return LoginResult._(
      success: false,
      error: error,
      code: code,
    );
  }
}
