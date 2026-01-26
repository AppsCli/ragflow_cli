import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import '../services/api_client.dart';
import 'knowledge_page.dart';
import 'chat_page.dart';
import 'search_page.dart';
import 'agent_page.dart';
import 'file_page.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const KnowledgePage(),
    const ChatPage(),
    const SearchPage(),
    const AgentPage(),
    const FilePage(),
    const AccountPage(),
  ];

  /// 检查用户信息，如果认证失败则跳转到登录页面
  Future<bool> _checkUserInfo() async {
    try {
      final response = await ApiClient.get(UserService.userInfoEndpoint);
      
      // 检查是否为认证错误（401 HTTP状态码 或 code 401）
      // 如果响应不成功或 code 为 401，说明认证失败
      if (!response.success || response.code == 401) {
        // Token失效，清除登录状态
        if (mounted) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.logout();
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return false;
      }
      
      // 检查响应数据是否存在
      if (response.data == null) {
        // 数据为空，可能是其他错误，清除登录状态并跳转到登录页面
        if (mounted) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.logout();
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return false;
      }
      
      // 认证通过
      return true;
    } catch (e) {
      // 请求异常，清除登录状态并跳转到登录页面
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          // 在切换菜单前检查用户信息
          final isValid = await _checkUserInfo();
          if (!isValid) {
            // 认证失败，已经跳转到登录页面，直接返回
            return;
          }
          
          // 认证通过，切换页面
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books),
            label: l10n.knowledgeBase,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat),
            label: l10n.chat,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: l10n.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.smart_toy),
            label: l10n.agent,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder),
            label: l10n.file,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.account,
          ),
        ],
      ),
    );
  }
}
