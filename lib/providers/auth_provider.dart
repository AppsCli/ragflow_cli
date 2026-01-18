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
    _loadUser();
    _loadServerConfig();
  }

  Future<void> _loadUser() async {
    _user = await Storage.getUser();
    notifyListeners();
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
        if (_serverConfig != null) {
          final updatedConfig = _serverConfig!.copyWith(
            token: result.user!.accessToken,
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
    await Storage.clear();
    _serverConfig = null;
    notifyListeners();
  }
}
