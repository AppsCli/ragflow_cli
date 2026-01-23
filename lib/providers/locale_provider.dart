import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale? _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Locale? get locale => _locale;

  /// 获取系统语言
  Locale get systemLocale {
    final systemLocales = ui.PlatformDispatcher.instance.locales;
    if (systemLocales.isNotEmpty) {
      final systemLocale = systemLocales.first;
      // 检查是否支持中文
      if (systemLocale.languageCode == 'zh') {
        return const Locale('zh');
      }
      // 默认返回英文
      return const Locale('en');
    }
    return const Locale('en');
  }

  /// 加载保存的语言设置
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);
      
      if (localeCode != null && localeCode.isNotEmpty) {
        if (localeCode == 'system') {
          // 使用系统语言
          _locale = null; // null 表示使用系统语言
        } else {
          _locale = Locale(localeCode);
        }
      } else {
        // 如果没有保存的设置，使用系统语言
        _locale = null;
      }
      notifyListeners();
    } catch (e) {
      // 如果加载失败，使用系统语言
      _locale = null;
      notifyListeners();
    }
  }

  /// 设置语言
  Future<void> setLocale(Locale? locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (locale == null) {
        // 设置为跟随系统
        await prefs.setString(_localeKey, 'system');
        _locale = null;
      } else {
        await prefs.setString(_localeKey, locale.languageCode);
        _locale = locale;
      }
      notifyListeners();
    } catch (e) {
      // 设置失败，不做任何操作
    }
  }

  /// 获取当前有效的语言（如果为 null 则返回系统语言）
  Locale getEffectiveLocale() {
    return _locale ?? systemLocale;
  }

  /// 检查是否跟随系统
  bool get isFollowingSystem => _locale == null;
}
