import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_config.dart';
import '../models/user.dart';

class Storage {
  static const String _serverConfigKey = 'server_config';
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  static Future<void> saveServerConfig(ServerConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverConfigKey, jsonEncode(config.toJson()));
  }

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
}
