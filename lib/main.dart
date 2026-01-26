import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'services/api_client.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API client
  await ApiClient.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer3<LocaleProvider, ThemeProvider, AuthProvider>(
        builder: (context, localeProvider, themeProvider, authProvider, child) {
          return MaterialApp(
            title: 'RAGFlow',
            debugShowCheckedModeBanner: false,
            // 国际化配置
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // 英文
              Locale('zh'), // 简体中文
              Locale('zh', 'TW'), // 繁体中文
              Locale('ja'), // 日语
              Locale('ko'), // 韩语
              Locale('de'), // 德语
              Locale('es'), // 西班牙语
              Locale('fr'), // 法语
              Locale('it'), // 意大利语
              Locale('ru'), // 俄语
              Locale('ar'), // 阿拉伯语
            ],
            theme: themeProvider.themeData,
            darkTheme: themeProvider.darkThemeData,
            // 根据登录状态决定显示登录页面还是主页
            // 如果已登录（token有效），显示主页；否则显示登录页面
            home: authProvider.isAuthenticated ? const HomePage() : const LoginPage(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/home': (context) => const HomePage(),
            },
          );
        },
      ),
    );
  }
}
