import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_config.dart';
import '../models/user.dart';

class Storage {
  static const String _serverConfigKey = 'server_config';
  static const String _serverConfigsKey = 'server_configs';
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';
  static const String _rsaPublicKeyKey = 'rsa_public_key';

  /// 保存单个服务器配置（向后兼容，已废弃，使用 saveServerConfigs）
  @Deprecated('Use saveServerConfigs instead')
  static Future<void> saveServerConfig(ServerConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverConfigKey, jsonEncode(config.toJson()));
  }

  /// 获取单个服务器配置（向后兼容，已废弃，使用 getServerConfigs）
  @Deprecated('Use getServerConfigs instead')
  static Future<ServerConfig?> getServerConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configStr = prefs.getString(_serverConfigKey);
    if (configStr == null) return null;
    try {
      final configMap = jsonDecode(configStr) as Map<String, dynamic>;
      return ServerConfig.fromJson(configMap);
    } catch (e) {
      return null;
    }
  }

  /// 保存多个服务器配置
  static Future<void> saveServerConfigs(List<ServerConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final configsJson = configs.map((config) => config.toJson()).toList();
    await prefs.setString(_serverConfigsKey, jsonEncode(configsJson));
  }

  /// 获取所有服务器配置
  static Future<List<ServerConfig>> getServerConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 首先尝试从新的多服务器配置中加载
    final configsStr = prefs.getString(_serverConfigsKey);
    if (configsStr != null) {
      try {
        final configsList = jsonDecode(configsStr) as List<dynamic>;
        return configsList
            .map((configMap) => ServerConfig.fromJson(configMap as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // 如果解析失败，继续尝试旧格式
      }
    }
    
    // 向后兼容：尝试从旧的单服务器配置中加载
    final oldConfigStr = prefs.getString(_serverConfigKey);
    if (oldConfigStr != null) {
      try {
        final configMap = jsonDecode(oldConfigStr) as Map<String, dynamic>;
        final oldConfig = ServerConfig.fromJson(configMap);
        // 将旧配置标记为激活状态并迁移到新格式
        final migratedConfig = oldConfig.copyWith(isActive: true);
        await saveServerConfigs([migratedConfig]);
        // 删除旧配置
        await prefs.remove(_serverConfigKey);
        return [migratedConfig];
      } catch (e) {
        // 解析失败，返回空列表
      }
    }
    
    return [];
  }

  /// 获取当前激活的服务器配置
  static Future<ServerConfig?> getActiveServerConfig() async {
    final configs = await getServerConfigs();
    if (configs.isEmpty) return null;
    
    try {
      return configs.firstWhere((config) => config.isActive);
    } catch (e) {
      // 如果没有激活的服务器，返回第一个
      return configs.first;
    }
  }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    if (user.accessToken != null) {
      await prefs.setString(_tokenKey, user.accessToken!);
    }
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr == null) return null;
    try {
      final userMap = jsonDecode(userStr) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// 清除用户相关数据（保留服务器配置）
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  /// 清除所有数据（包括服务器配置）- 仅用于完全重置
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_serverConfigKey);
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  /// 保存 RSA 公钥
  static Future<void> saveRsaPublicKey(String publicKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rsaPublicKeyKey, publicKey);
  }

  /// 获取 RSA 公钥
  static Future<String?> getRsaPublicKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rsaPublicKeyKey);
  }

  /// 删除 RSA 公钥（重置为默认值）
  static Future<void> removeRsaPublicKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rsaPublicKeyKey);
  }
}
