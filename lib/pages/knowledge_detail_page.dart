import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  /// 检查是否有文档正在解析中
  bool _hasRunningDocuments() {
    return _documents.any((doc) => 
      doc.run == '1' || doc.run == 'RUNNING'
    );
  }

  /// 启动自动刷新定时器
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    if (_hasRunningDocuments()) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        // 静默刷新，不显示加载状态
        _loadDocuments(silent: true).then((_) {
          // 刷新后检查是否还有正在解析的文档
          if (mounted && !_hasRunningDocuments()) {
            timer.cancel();
          }
        });
      });
    }
  }

  /// 停止自动刷新定时器
  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> _loadDocuments({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final result = await DocumentService.getDocumentList(
        kbId: widget.kbId,
        keywords: _searchKeywords,
        page: _currentPage,
        pageSize: _pageSize,
      );

      // 在更新前检查是否有正在解析的文档
      final hadRunningDocuments = _hasRunningDocuments();

      setState(() {
        _documents = result.documents;
        _total = result.total;
        _isLoading = false;
      });

      // 在更新后检查是否有正在解析的文档
      final hasRunningNow = _hasRunningDocuments();
      if (hasRunningNow && !hadRunningDocuments) {
        // 有新的文档开始解析，启动定时刷新
        _startAutoRefresh();
      } else if (!hasRunningNow && hadRunningDocuments) {
        // 所有文档都解析完成，停止定时刷新
        _stopAutoRefresh();
      } else if (hasRunningNow) {
        // 继续刷新（确保定时器在运行）
        _startAutoRefresh();
      } else {
        // 没有正在解析的文档，确保停止定时器
        _stopAutoRefresh();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted && !silent) {
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
    return Stack(
      children: [
        Column(
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
                                  Row(
                                    children: [
                                      Text('片段: ${doc.chunkNum} | Token: ${doc.tokenNum}'),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(doc.run ?? doc.status),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          _getStatusText(doc.run ?? doc.status),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  // 显示"解析"选项：未开始、已取消、失败状态
                                  if (doc.run == '0' || 
                                      doc.run == 'UNSTART' || 
                                      doc.run == null ||
                                      doc.run == '2' ||
                                      doc.run == 'CANCEL' ||
                                      doc.run == '4' ||
                                      doc.run == 'FAIL')
                                    const PopupMenuItem(
                                      value: 'parse',
                                      child: Row(
                                        children: [
                                          Icon(Icons.play_arrow, size: 20),
                                          SizedBox(width: 8),
                                          Text('解析'),
                                        ],
                                      ),
                                    ),
                                  // 显示"取消解析"选项：解析中状态
                                  if (doc.run == '1' || doc.run == 'RUNNING')
                                    const PopupMenuItem(
                                      value: 'cancel',
                                      child: Row(
                                        children: [
                                          Icon(Icons.stop, size: 20, color: Colors.orange),
                                          SizedBox(width: 8),
                                          Text('取消解析', style: TextStyle(color: Colors.orange)),
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
                                    _showDocumentDetail(doc);
                                  } else if (value == 'download') {
                                    _downloadDocument(doc);
                                  } else if (value == 'parse') {
                                    _parseDocument(doc);
                                  } else if (value == 'cancel') {
                                    _cancelParseDocument(doc);
                                  } else if (value == 'delete') {
                                    _deleteDocument(doc.id);
                                  }
                                },
                              ),
                              onTap: () {
                                _showDocumentDetail(doc);
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
        ),
        // 上传按钮
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _uploadDocument,
            child: const Icon(Icons.upload),
            tooltip: '上传文件',
          ),
        ),
      ],
    );
  }

  void _showDocumentDetail(Document doc) {
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
              Text('状态: ${_getStatusText(doc.run ?? doc.status)}'),
              if (doc.description != null)
                Text('描述: ${doc.description}'),
              if (doc.createTime != null)
                Text('创建时间: ${_formatDateTime(doc.createTime!)}'),
              if (doc.updateTime != null)
                Text('更新时间: ${_formatDateTime(doc.updateTime!)}'),
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
  }

  String _getStatusText(String? status) {
    if (status == null) return '未知';
    switch (status) {
      case '0':
      case 'UNSTART':
        return '未开始';
      case '1':
      case 'RUNNING':
        return '解析中';
      case '2':
      case 'CANCEL':
        return '已取消';
      case '3':
      case 'DONE':
        return '已完成';
      case '4':
      case 'FAIL':
        return '失败';
      default:
        return status;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status) {
      case '0':
      case 'UNSTART':
        return Colors.grey;
      case '1':
      case 'RUNNING':
        return Colors.blue;
      case '2':
      case 'CANCEL':
        return Colors.orange;
      case '3':
      case 'DONE':
        return Colors.green;
      case '4':
      case 'FAIL':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _downloadDocument(Document doc) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('正在下载...')),
        );
      }

      final fileBytes = await DocumentService.downloadDocument(doc.id);
      if (fileBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('下载失败')),
          );
        }
        return;
      }

      // 保存文件到下载目录
      final directory = await getApplicationDocumentsDirectory();
      final fileName = doc.name;
      final filePath = '${directory.path}/$fileName';
      final savedFile = File(filePath);
      await savedFile.writeAsBytes(fileBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('下载成功: $filePath')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('下载失败: $e')),
        );
      }
    }
  }

  Future<void> _parseDocument(Document doc) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('正在启动解析...')),
        );
      }

      final success = await DocumentService.runDocument(
        docIds: [doc.id],
        run: 1,
        shouldDelete: false,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('解析已启动')),
        );
        _loadDocuments(); // 刷新列表
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('启动解析失败')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('启动解析失败: $e')),
        );
      }
    }
  }

  Future<void> _cancelParseDocument(Document doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认取消'),
        content: Text('确定要取消解析文档 "${doc.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('正在取消解析...')),
          );
        }

        final success = await DocumentService.runDocument(
          docIds: [doc.id],
          run: 2, // 2 表示取消（CANCEL）
          shouldDelete: false,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已取消解析')),
          );
          _loadDocuments(); // 刷新列表
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('取消解析失败')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('取消解析失败: $e')),
          );
        }
      }
    }
  }

  Future<void> _uploadDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('正在上传...')),
          );
        }

        bool allSuccess = true;
        List<String> uploadedDocIds = [];

        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            final documents = await DocumentService.uploadDocument(widget.kbId, file);
            if (documents != null && documents.isNotEmpty) {
              uploadedDocIds.addAll(documents.map((d) => d.id));
            } else {
              allSuccess = false;
            }
          }
        }

        if (mounted) {
          if (allSuccess && uploadedDocIds.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('上传成功，正在启动解析...')),
            );
            // 自动启动解析
            await DocumentService.runDocument(
              docIds: uploadedDocIds,
              run: 1,
              shouldDelete: false,
            );
            _loadDocuments(); // 刷新列表
          } else if (uploadedDocIds.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('部分文件上传失败')),
            );
            _loadDocuments(); // 刷新列表
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('上传失败')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('上传失败: $e')),
        );
      }
    }
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
