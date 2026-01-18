import 'package:flutter/material.dart';
import '../models/knowledge_base.dart';
import '../services/knowledge_service.dart';

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
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('知识库'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadKnowledgeBases,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _knowledgeBases.isEmpty
              ? const Center(
                  child: Text('暂无知识库', style: TextStyle(fontSize: 16)),
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
                          leading: CircleAvatar(
                            backgroundImage: kb.avatar != null
                                ? NetworkImage(kb.avatar!)
                                : null,
                            child: kb.avatar == null
                                ? const Icon(Icons.library_books)
                                : null,
                          ),
                          title: Text(kb.name),
                          subtitle: Text(
                            '文档: ${kb.documentNum} | 片段: ${kb.chunkNum}',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to knowledge base detail
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show create knowledge base dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
