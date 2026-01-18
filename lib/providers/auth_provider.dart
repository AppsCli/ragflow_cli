import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/server_config.dart';
import '../services/user_service.dart';
import '../services/api_client.dart';
import '../utils/storage.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  ServerConfig? _serverConfig;
  bool _isLoading = false;

  User? get user => _user;
  ServerConfig? get serverConfig => _serverConfig;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // 只加载服务器配置，不自动加载用户信息
    // 这样每次打开APP都会显示登录界面
    _loadServerConfig();
  }

  Future<void> _loadServerConfig() async {
    _serverConfig = await Storage.getServerConfig();
    if (_serverConfig != null) {
      ApiClient.setBaseUrl(_serverConfig!.baseUrl);
      if (_serverConfig!.token != null) {
        ApiClient.setToken(_serverConfig!.token);
      }
    }
    notifyListeners();
  }

  Future<bool> setServerConfig(String baseUrl) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Normalize base URL (remove trailing slash)
      final normalizedUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

      final config = ServerConfig(baseUrl: normalizedUrl);
      await Storage.saveServerConfig(config);
      _serverConfig = config;
      ApiClient.setBaseUrl(normalizedUrl);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String? _lastLoginError;

  String? get lastLoginError => _lastLoginError;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _lastLoginError = null;
    notifyListeners();

    try {
      final result = await UserService.login(email, password);
      
      if (result.success && result.user != null) {
        _user = result.user;
        await Storage.saveUser(result.user!);
        
        // Update server config with token
        // 使用 ApiClient 中当前保存的 token（从响应headers中获取的完整Authorization值）
        final currentToken = ApiClient.getToken();
        if (_serverConfig != null && currentToken != null) {
          final updatedConfig = _serverConfig!.copyWith(
            token: currentToken, // 这个值应该已经是完整的Authorization header值
            lastUpdated: DateTime.now(),
          );
          await Storage.saveServerConfig(updatedConfig);
          _serverConfig = updatedConfig;
        }
        
        _isLoading = false;
        _lastLoginError = null;
        notifyListeners();
        return true;
      } else {
        _lastLoginError = result.error ?? '登录失败';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _lastLoginError = '登录异常: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await UserService.logout();
    _user = null;
    // 只清除用户信息和token，保留服务器配置
    await Storage.clearUser();
    // 清除token但保留服务器地址
    if (_serverConfig != null) {
      final updatedConfig = _serverConfig!.copyWith(
        token: null,
        lastUpdated: DateTime.now(),
      );
      await Storage.saveServerConfig(updatedConfig);
      _serverConfig = updatedConfig;
    }
    ApiClient.setToken(null);
    notifyListeners();
  }
}
