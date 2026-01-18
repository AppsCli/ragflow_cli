import '../models/user.dart';
import '../utils/rsa_encrypt.dart';
import 'api_client.dart';
import 'login_result.dart';

class UserService {
  static const String loginEndpoint = '/v1/user/login';
  static const String logoutEndpoint = '/v1/user/logout';
  static const String userInfoEndpoint = '/v1/user/info';
  static const String registerEndpoint = '/v1/user/register';

  static Future<LoginResult> login(String email, String password) async {
    // 使用 RSA 加密密码（与 web 前端保持一致）
    final encryptedPassword = rsaEncryptPassword(password);
    
    final response = await ApiClient.post(
      loginEndpoint,
      body: {
        'email': email,
        'password': encryptedPassword,
      },
    );

    if (!response.success) {
      return LoginResult.failure(
        response.error ?? '登录失败',
        code: response.code,
      );
    }

    if (response.data == null) {
      return LoginResult.failure('服务器返回空响应');
    }

    final data = response.data!['data'] as Map<String, dynamic>?;
    if (data == null) {
      return LoginResult.failure(
        response.data!['message'] as String? ?? '登录响应数据格式错误',
      );
    }

    try {
      final user = User.fromJson(data);
      final accessToken = data['access_token'] as String?;
      if (accessToken != null) {
        ApiClient.setToken(accessToken);
        user.accessToken = accessToken;
      }
      return LoginResult.success(user);
    } catch (e) {
      return LoginResult.failure('解析用户数据失败: $e');
    }
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
    // 注册时也需要加密密码
    final encryptedPassword = rsaEncryptPassword(password);
    
    final response = await ApiClient.post(
      registerEndpoint,
      body: {
        'email': email,
        'password': encryptedPassword,
        'nickname': nickname,
      },
    );
    return response.success;
  }
}
