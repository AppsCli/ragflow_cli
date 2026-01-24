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
      final languageCode = systemLocale.languageCode;
      final countryCode = systemLocale.countryCode;
      
      // 检查支持的语言
      if (languageCode == 'zh') {
        // 繁体中文
        if (countryCode == 'TW' || countryCode == 'HK' || countryCode == 'MO') {
          return const Locale('zh', 'TW');
        }
        // 简体中文
        return const Locale('zh');
      } else if (languageCode == 'ja') {
        return const Locale('ja');
      } else if (languageCode == 'ko') {
        return const Locale('ko');
      } else if (languageCode == 'de') {
        return const Locale('de');
      } else if (languageCode == 'es') {
        return const Locale('es');
      } else if (languageCode == 'fr') {
        return const Locale('fr');
      } else if (languageCode == 'it') {
        return const Locale('it');
      } else if (languageCode == 'ru') {
        return const Locale('ru');
      } else if (languageCode == 'ar') {
        return const Locale('ar');
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
          // 解析语言代码（可能包含国家代码）
          final parts = localeCode.split('_');
          if (parts.length == 2) {
            _locale = Locale(parts[0], parts[1]);
          } else {
            _locale = Locale(localeCode);
          }
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
        // 保存完整的语言代码（包括国家代码）
        final localeCode = locale.countryCode != null 
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;
        await prefs.setString(_localeKey, localeCode);
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
