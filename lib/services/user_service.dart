import '../models/user.dart';
import 'api_client.dart';

class UserService {
  static const String loginEndpoint = '/v1/user/login';
  static const String logoutEndpoint = '/v1/user/logout';
  static const String userInfoEndpoint = '/v1/user/info';
  static const String registerEndpoint = '/v1/user/register';

  static Future<User?> login(String email, String password) async {
    final response = await ApiClient.post(
      loginEndpoint,
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        final user = User.fromJson(data);
        ApiClient.setToken(data['access_token'] as String?);
        return user;
      }
    }
    return null;
  }

  static Future<bool> logout() async {
    final response = await ApiClient.get(logoutEndpoint);
    return response.success;
  }

  static Future<User?> getUserInfo() async {
    final response = await ApiClient.get(userInfoEndpoint);
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return User.fromJson(data);
      }
    }
    return null;
  }

  static Future<bool> register(String email, String password, String nickname) async {
    final response = await ApiClient.post(
      registerEndpoint,
      body: {
        'email': email,
        'password': password,
        'nickname': nickname,
      },
    );
    return response.success;
  }
}
