import 'package:flutter/material.dart';
import '../models/knowledge_base.dart';
import '../models/document.dart';
import '../models/search_result.dart';
import '../services/knowledge_service.dart';
import '../services/document_service.dart';
import '../services/chunk_service.dart';

class KnowledgeDetailPage extends StatefulWidget {
  final String knowledgeBaseId;

  const KnowledgeDetailPage({
    super.key,
    required this.knowledgeBaseId,
  });

  @override
  State<KnowledgeDetailPage> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  KnowledgeBase? _knowledgeBase;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadKnowledgeBase();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadKnowledgeBase() async {
    final kb = await KnowledgeService.getKnowledgeBaseDetail(widget.knowledgeBaseId);
    if (mounted) {
      setState(() {
        _knowledgeBase = kb;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_knowledgeBase?.name ?? '知识库详情'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '数据集'),
            Tab(text: '检索测试'),
            Tab(text: '配置'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DocumentListTab(kbId: widget.knowledgeBaseId),
          RetrievalTestTab(kbId: widget.knowledgeBaseId),
          KnowledgeConfigTab(kbId: widget.knowledgeBaseId, knowledgeBase: _knowledgeBase),
        ],
      ),
    );
  }
}

/// 数据集 Tab
class DocumentListTab extends StatefulWidget {
  final String kbId;

  const DocumentListTab({super.key, required this.kbId});

  @override
  State<DocumentListTab> createState() => _DocumentListTabState();
}

class _DocumentListTabState extends State<DocumentListTab> {
  List<Document> _documents = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  int _total = 0;
  String _searchKeywords = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await DocumentService.getDocumentList(
        kbId: widget.kbId,
        keywords: _searchKeywords,
        page: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        _documents = result.documents;
        _total = result.total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载文档失败: $e')),
        );
      }
    }
  }

  Future<void> _deleteDocument(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个文档吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await DocumentService.deleteDocument(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('删除成功')),
        );
        _loadDocuments();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('删除失败')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索文档...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchKeywords.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchKeywords = '';
                        });
                        _loadDocuments();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                _searchKeywords = value;
                _currentPage = 1;
              });
              _loadDocuments();
            },
            onChanged: (value) {
              setState(() {
                _searchKeywords = value;
              });
              if (value.isEmpty) {
                _loadDocuments();
              }
            },
          ),
        ),
        // 文档列表
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _documents.isEmpty
                  ? const Center(
                      child: Text('暂无文档', style: TextStyle(fontSize: 16)),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadDocuments,
                      child: ListView.builder(
                        itemCount: _documents.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final doc = _documents[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.insert_drive_file),
                              title: Text(doc.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('片段: ${doc.chunkNum} | Token: ${doc.tokenNum}'),
                                  if (doc.updateTime != null)
                                    Text(
                                      '更新: ${_formatDateTime(doc.updateTime!)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'detail',
                                    child: Row(
                                      children: [
                                        Icon(Icons.info, size: 20),
                                        SizedBox(width: 8),
                                        Text('详情'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'download',
                                    child: Row(
                                      children: [
                                        Icon(Icons.download, size: 20),
                                        SizedBox(width: 8),
                                        Text('下载'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('删除', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'detail') {
                                    // TODO: 显示文档详情
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(doc.name),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('ID: ${doc.id}'),
                                              Text('后缀: ${doc.suffix}'),
                                              Text('大小: ${_formatFileSize(doc.size)}'),
                                              Text('片段数: ${doc.chunkNum}'),
                                              Text('Token数: ${doc.tokenNum}'),
                                              if (doc.description != null)
                                                Text('描述: ${doc.description}'),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('关闭'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (value == 'download') {
                                    // TODO: 下载文档
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('下载功能待实现')),
                                    );
                                  } else if (value == 'delete') {
                                    _deleteDocument(doc.id);
                                  }
                                },
                              ),
                              onTap: () {
                                // TODO: 显示文档详情
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
                  '共 $_total 个文档',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                if (_currentPage > 1)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentPage--;
                      });
                      _loadDocuments();
                    },
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('上一页'),
                  ),
                if ((_currentPage * _pageSize) < _total)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentPage++;
                      });
                      _loadDocuments();
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('下一页'),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

/// 检索测试 Tab
class RetrievalTestTab extends StatefulWidget {
  final String kbId;

  const RetrievalTestTab({super.key, required this.kbId});

  @override
  State<RetrievalTestTab> createState() => _RetrievalTestTabState();
}

class _RetrievalTestTabState extends State<RetrievalTestTab> {
  final TextEditingController _questionController = TextEditingController();
  bool _isLoading = false;
  List<RetrievalChunk> _chunks = [];
  int _total = 0;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _testRetrieval() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入问题')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _chunks = [];
    });

    try {
      final result = await ChunkService.retrievalTest(
        kbIds: [widget.kbId],
        question: question,
        page: 1,
        size: 30,
        highlight: true,
      );

      setState(() {
        _chunks = result.chunks;
        _total = result.total;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('检索测试失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 问题输入
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    hintText: '输入问题进行检索测试...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  enabled: !_isLoading,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _testRetrieval,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: const Text('测试'),
              ),
            ],
          ),
        ),
        // 结果列表
        Expanded(
          child: _chunks.isEmpty
              ? Center(
                  child: Text(
                    _isLoading ? '检索中...' : '请输入问题进行检索测试',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '检索结果 (共 $_total 条)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._chunks.map((chunk) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              chunk.docName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (chunk.similarity != null)
                                  Text(
                                    '相似度: ${(chunk.similarity! * 100).toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Text(chunk.content),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

/// 配置 Tab
class KnowledgeConfigTab extends StatefulWidget {
  final String kbId;
  final KnowledgeBase? knowledgeBase;

  const KnowledgeConfigTab({
    super.key,
    required this.kbId,
    this.knowledgeBase,
  });

  @override
  State<KnowledgeConfigTab> createState() => _KnowledgeConfigTabState();
}

class _KnowledgeConfigTabState extends State<KnowledgeConfigTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.knowledgeBase?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.knowledgeBase?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final success = await KnowledgeService.updateKnowledgeBase(
        id: widget.kbId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存失败')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '知识库名称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入知识库名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveConfig,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('保存配置'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
