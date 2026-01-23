import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/agent_service.dart';
import 'agent_detail_page.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  List<Map<String, dynamic>> _agents = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 30;
  int _total = 0;
  String _searchKeywords = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAgents({int? page, String? keywords}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pageNum = page ?? _currentPage;
      final keywordsStr = keywords ?? _searchController.text;
      
      final result = await AgentService.getAgentList(
        page: pageNum,
        pageSize: _pageSize,
        keywords: keywordsStr,
      );
      
      setState(() {
        _agents = result.agents;
        _total = result.total;
        _currentPage = pageNum;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loadFailed(e.toString()))),
        );
      }
    }
  }

  void _handleSearch(String keywords) {
    _loadAgents(page: 1, keywords: keywords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadAgents(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchAgents,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchKeywords.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchKeywords = '';
                          });
                          _handleSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: _handleSearch,
              onChanged: (value) {
                setState(() {
                  _searchKeywords = value;
                });
                // 如果搜索框为空，自动刷新列表
                if (value.isEmpty) {
                  _handleSearch('');
                }
              },
            ),
          ),
          // Agent列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _agents.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!.noAgents, style: const TextStyle(fontSize: 16)),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadAgents(),
                        child: ListView.builder(
                          itemCount: _agents.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final agent = _agents[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: _buildAvatar(agent['avatar']),
                                title: Text(agent['title'] ?? AppLocalizations.of(context)!.unnamed),
                                subtitle: Text(
                                  agent['description'] ?? agent['title'] ?? AppLocalizations.of(context)!.noDescription,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AgentDetailPage(
                                        agentId: agent['id'] ?? '',
                                        agentName: agent['title'] ?? AppLocalizations.of(context)!.unnamed,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
          // 分页信息
          if (_total > 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalAgents(_total),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  if (_currentPage > 1)
                    TextButton.icon(
                      onPressed: () => _loadAgents(page: _currentPage - 1),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: Text(AppLocalizations.of(context)!.previousPage),
                    ),
                  if ((_currentPage * _pageSize) < _total)
                    TextButton.icon(
                      onPressed: () => _loadAgents(page: _currentPage + 1),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(AppLocalizations.of(context)!.nextPage),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 构建头像 Widget
  /// 如果有 avatar base64 数据则显示图片，否则显示默认图标
  Widget _buildAvatar(dynamic avatar) {
    if (avatar == null || avatar.toString().isEmpty) {
      return const Icon(Icons.smart_toy);
    }

    try {
      // 处理 base64 字符串
      String base64String = avatar.toString();
      
      // 如果是 data URL 格式（如 data:image/png;base64,xxx），提取 base64 部分
      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }

      // 解码 base64 字符串为 Uint8List
      final Uint8List imageBytes = base64Decode(base64String);

      // 使用 Image.memory 显示图片
      return ClipOval(
        child: Image.memory(
          imageBytes,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // 如果图片加载失败，显示默认图标
            return const Icon(Icons.smart_toy);
          },
        ),
      );
    } catch (e) {
      // 如果 base64 解码失败，显示默认图标
      return const Icon(Icons.smart_toy);
    }
  }
}
