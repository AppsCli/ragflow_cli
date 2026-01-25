import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 主题配色方案枚举
enum ColorSchemeType {
  blue,      // 蓝色（默认）
  green,     // 绿色
  purple,    // 紫色
  orange,    // 橙色
  red,       // 红色
  teal,      // 青色
  pink,      // 粉色
  indigo,    // 靛蓝色
  brown,     // 棕色
  cyan,      // 青色
}

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'selected_color_scheme';
  ColorSchemeType _colorScheme = ColorSchemeType.blue;

  ThemeProvider() {
    _loadTheme();
  }

  ColorSchemeType get colorScheme => _colorScheme;

  /// 获取当前主题的种子颜色
  Color get seedColor {
    switch (_colorScheme) {
      case ColorSchemeType.blue:
        return Colors.blue;
      case ColorSchemeType.green:
        return Colors.green;
      case ColorSchemeType.purple:
        return Colors.purple;
      case ColorSchemeType.orange:
        return Colors.orange;
      case ColorSchemeType.red:
        return Colors.red;
      case ColorSchemeType.teal:
        return Colors.teal;
      case ColorSchemeType.pink:
        return Colors.pink;
      case ColorSchemeType.indigo:
        return Colors.indigo;
      case ColorSchemeType.brown:
        return Colors.brown;
      case ColorSchemeType.cyan:
        return Colors.cyan;
    }
  }

  /// 获取主题数据
  ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  /// 获取暗色主题数据
  ThemeData get darkThemeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }

  /// 加载保存的主题设置
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      
      if (themeIndex != null && themeIndex >= 0 && themeIndex < ColorSchemeType.values.length) {
        _colorScheme = ColorSchemeType.values[themeIndex];
      }
      notifyListeners();
    } catch (e) {
      // 如果加载失败，使用默认主题
      _colorScheme = ColorSchemeType.blue;
      notifyListeners();
    }
  }

  /// 设置主题
  Future<void> setColorScheme(ColorSchemeType scheme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, scheme.index);
      _colorScheme = scheme;
      notifyListeners();
    } catch (e) {
      // 设置失败，不做任何操作
    }
  }

  /// 获取配色方案的显示名称
  String getColorSchemeName(ColorSchemeType scheme) {
    switch (scheme) {
      case ColorSchemeType.blue:
        return 'Blue';
      case ColorSchemeType.green:
        return 'Green';
      case ColorSchemeType.purple:
        return 'Purple';
      case ColorSchemeType.orange:
        return 'Orange';
      case ColorSchemeType.red:
        return 'Red';
      case ColorSchemeType.teal:
        return 'Teal';
      case ColorSchemeType.pink:
        return 'Pink';
      case ColorSchemeType.indigo:
        return 'Indigo';
      case ColorSchemeType.brown:
        return 'Brown';
      case ColorSchemeType.cyan:
        return 'Cyan';
    }
  }
}
