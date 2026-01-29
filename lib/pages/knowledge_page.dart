import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../models/knowledge_base.dart';
import '../services/knowledge_service.dart';
import 'knowledge_detail_page.dart';

class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  List<KnowledgeBase> _knowledgeBases = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKnowledgeBases();
  }

  Future<void> _loadKnowledgeBases() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await KnowledgeService.getKnowledgeBaseList();
      print(list);
      setState(() {
        _knowledgeBases = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.loadingFailed}: $e')),
        );
      }
    }
  }

  Future<void> _showCreateDialog() async {
    final nameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Strings.createKnowledgeBase),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: Strings.name,
                hintText: Strings.enterKnowledgeBaseName,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return Strings.enterKnowledgeBaseName;
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(Strings.create),
            ),
          ],
        );
      },
    );

    if (result == true && nameController.text.trim().isNotEmpty) {
      await _createKnowledgeBase(nameController.text.trim());
    }
  }

  Future<void> _createKnowledgeBase(String name) async {
    // 显示加载提示
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.creating)),
      );
    }

    try {
      final kbId = await KnowledgeService.createKnowledgeBase(name: name);
      
      if (kbId != null) {
        // 创建成功，刷新列表
        await _loadKnowledgeBases();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.createSuccess)),
          );
          
          // 导航到新创建的知识库详情页
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => KnowledgeDetailPage(
                knowledgeBaseId: kbId,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.createFailed)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.createFailed}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.knowledgeBase),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadKnowledgeBases,
            tooltip: Strings.refresh,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _knowledgeBases.isEmpty
              ? Center(
                  child: Text(Strings.noKnowledgeBase, style: const TextStyle(fontSize: 16)),
                )
              : RefreshIndicator(
                  onRefresh: _loadKnowledgeBases,
                  child: ListView.builder(
                    itemCount: _knowledgeBases.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final kb = _knowledgeBases[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: _buildAvatar(kb.avatar),
                          title: Text(kb.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${Strings.documents}: ${kb.documentNum} | ${Strings.chunks}: ${kb.chunkNum}',
                              ),
                              if (kb.updateTime != null)
                                Text(
                                  '${Strings.updated}: ${_formatDateTime(kb.updateTime!)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => KnowledgeDetailPage(
                                  knowledgeBaseId: kb.id,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
        tooltip: Strings.createKnowledgeBase,
      ),
    );
  }

  /// 构建头像 Widget
  /// 支持 URL 和 base64 格式
  Widget _buildAvatar(String? avatar) {
    if (avatar == null || avatar.isEmpty) {
      return const CircleAvatar(
        child: Icon(Icons.library_books),
      );
    }

    // 检查是否是有效的 URL（以 http:// 或 https:// 开头）
    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      try {
        return CircleAvatar(
          backgroundImage: NetworkImage(avatar),
          onBackgroundImageError: (exception, stackTrace) {
            // 如果网络图片加载失败，显示默认图标
          },
          child: null,
        );
      } catch (e) {
        return const CircleAvatar(
          child: Icon(Icons.library_books),
        );
      }
    }

    // 尝试作为 base64 图片处理
    try {
      String base64String = avatar;
      
      // 如果是 data URL 格式（如 data:image/png;base64,xxx），提取 base64 部分
      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }

      // 解码 base64 字符串为 Uint8List
      final Uint8List imageBytes = base64Decode(base64String);

      // 使用 Image.memory 显示图片
      return CircleAvatar(
        backgroundImage: MemoryImage(imageBytes),
        onBackgroundImageError: (exception, stackTrace) {
          // 如果图片加载失败，显示默认图标
        },
        child: null,
      );
    } catch (e) {
      // base64 解码失败，显示默认图标
      return const CircleAvatar(
        child: Icon(Icons.library_books),
      );
    }
  }

  /// 格式化日期时间
  /// 显示完整的年月日时分秒
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
