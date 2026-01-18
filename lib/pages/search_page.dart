import 'package:flutter/material.dart';
import '../services/search_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> _searches = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSearches();
  }

  Future<void> _loadSearches() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await SearchService.getSearchList();
      setState(() {
        _searches = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSearches,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searches.isEmpty
              ? const Center(
                  child: Text('暂无搜索配置', style: TextStyle(fontSize: 16)),
                )
              : RefreshIndicator(
                  onRefresh: _loadSearches,
                  child: ListView.builder(
                    itemCount: _searches.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final search = _searches[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.search),
                          title: Text(search['name'] ?? '未命名'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to search detail
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show create search dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
