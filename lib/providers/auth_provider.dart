import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/server_config.dart';
import '../services/user_service.dart';
import '../services/api_client.dart';
import '../utils/storage.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  List<ServerConfig> _serverConfigs = [];
  bool _isLoading = false;

  User? get user => _user;
  // 向后兼容：返回当前激活的服务器配置
  ServerConfig? get serverConfig {
    if (_serverConfigs.isEmpty) return null;
    
    try {
      return _serverConfigs.firstWhere((config) => config.isActive);
    } catch (e) {
      // 如果没有激活的服务器，返回第一个
      return _serverConfigs.first;
    }
  }
  // 获取所有服务器配置
  List<ServerConfig> get serverConfigs => _serverConfigs;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    // 只加载服务器配置，不自动加载用户信息
    // 这样每次打开APP都会显示登录界面
    _loadServerConfigs();
  }

  Future<void> _loadServerConfigs() async {
    _serverConfigs = await Storage.getServerConfigs();
    final activeConfig = _serverConfigs.firstWhere(
      (config) => config.isActive,
      orElse: () => _serverConfigs.isNotEmpty ? _serverConfigs.first : ServerConfig(baseUrl: ''),
    );
    
    if (activeConfig.baseUrl.isNotEmpty) {
      ApiClient.setBaseUrl(activeConfig.baseUrl);
      if (activeConfig.token != null) {
        ApiClient.setToken(activeConfig.token);
      }
    }
    notifyListeners();
  }

  /// 添加新服务器配置
  Future<bool> addServer(String baseUrl, {String? name}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Normalize base URL (remove trailing slash)
      final normalizedUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

      // 检查是否已存在相同的服务器地址
      final existingIndex = _serverConfigs.indexWhere(
        (config) => config.baseUrl == normalizedUrl,
      );

      if (existingIndex >= 0) {
        // 如果已存在，更新名称（如果提供了）
        if (name != null && name.isNotEmpty) {
          _serverConfigs[existingIndex] = _serverConfigs[existingIndex].copyWith(name: name);
        }
      } else {
        // 如果不存在，添加新服务器
        final serverName = (name != null && name.isNotEmpty)
            ? name
            : _generateServerName(normalizedUrl);
        final newConfig = ServerConfig(
          baseUrl: normalizedUrl,
          name: serverName,
          isActive: _serverConfigs.isEmpty, // 如果是第一个服务器，自动激活
        );
        _serverConfigs.add(newConfig);
      }

      await Storage.saveServerConfigs(_serverConfigs);
      await _loadServerConfigs();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 激活指定的服务器
  Future<bool> activateServer(String baseUrl) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Normalize base URL
      final normalizedUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

      // 将所有服务器标记为非激活，然后激活指定的服务器
      _serverConfigs = _serverConfigs.map((config) {
        if (config.baseUrl == normalizedUrl) {
          // 激活这个服务器
          ApiClient.setBaseUrl(normalizedUrl);
          if (config.token != null) {
            ApiClient.setToken(config.token);
          }
          return config.copyWith(isActive: true);
        } else {
          // 其他服务器标记为非激活
          return config.copyWith(isActive: false);
        }
      }).toList();

      await Storage.saveServerConfigs(_serverConfigs);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 删除服务器配置
  Future<bool> deleteServer(String baseUrl) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Normalize base URL
      final normalizedUrl = baseUrl.endsWith('/')
          ? baseUrl.substring(0, baseUrl.length - 1)
          : baseUrl;

      final wasActive = _serverConfigs.any(
        (config) => config.baseUrl == normalizedUrl && config.isActive,
      );

      // 删除指定的服务器
      _serverConfigs.removeWhere((config) => config.baseUrl == normalizedUrl);

      // 如果删除的是激活的服务器，激活第一个服务器（如果还有的话）
      if (wasActive && _serverConfigs.isNotEmpty) {
        _serverConfigs[0] = _serverConfigs[0].copyWith(isActive: true);
        ApiClient.setBaseUrl(_serverConfigs[0].baseUrl);
        if (_serverConfigs[0].token != null) {
          ApiClient.setToken(_serverConfigs[0].token);
        }
      } else if (_serverConfigs.isEmpty) {
        // 如果没有服务器了，清除 API 客户端配置
        ApiClient.setBaseUrl('');
        ApiClient.setToken(null);
      }

      await Storage.saveServerConfigs(_serverConfigs);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// 生成服务器名称（从 URL 提取）
  String _generateServerName(String baseUrl) {
    try {
      final uri = Uri.parse(baseUrl);
      if (uri.host.isNotEmpty) {
        return uri.host;
      }
      return baseUrl;
    } catch (e) {
      return baseUrl;
    }
  }

  /// 向后兼容：设置服务器配置（如果已存在则更新，否则添加）
  Future<bool> setServerConfig(String baseUrl) async {
    return await addServer(baseUrl);
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
        final activeConfig = serverConfig;
        if (activeConfig != null && activeConfig.baseUrl.isNotEmpty && currentToken != null) {
          // 更新激活服务器的 token
          _serverConfigs = _serverConfigs.map((config) {
            if (config.baseUrl == activeConfig.baseUrl) {
              return config.copyWith(
                token: currentToken, // 这个值应该已经是完整的Authorization header值
                lastUpdated: DateTime.now(),
              );
            }
            return config;
          }).toList();
          await Storage.saveServerConfigs(_serverConfigs);
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
    // 清除激活服务器的token但保留服务器地址
    final activeConfig = serverConfig;
    if (activeConfig != null && activeConfig.baseUrl.isNotEmpty) {
      _serverConfigs = _serverConfigs.map((config) {
        if (config.baseUrl == activeConfig.baseUrl) {
          return config.copyWith(
            token: null,
            lastUpdated: DateTime.now(),
          );
        }
        return config;
      }).toList();
      await Storage.saveServerConfigs(_serverConfigs);
    }
    ApiClient.setToken(null);
    notifyListeners();
  }
}
