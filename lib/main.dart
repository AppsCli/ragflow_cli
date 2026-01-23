import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/locale_provider.dart';
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
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
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
              Locale('zh'), // 中文
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            // 始终显示登录界面，不自动登录
            // 即使用户已保存，也需要重新登录
            home: const LoginPage(),
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
