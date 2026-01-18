import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: '知识库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '聊天',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '搜索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Agent',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: '文件',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '账号',
          ),
        ],
      ),
    );
  }
}
