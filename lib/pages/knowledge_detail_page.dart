import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/knowledge_base.dart';
import '../models/document.dart';
import '../models/search_result.dart';
import '../services/knowledge_service.dart';
import '../services/document_service.dart';
import '../services/chunk_service.dart';
import '../services/llm_service.dart';
import '../constants/knowledge.dart';

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
      // 知识库详情页的检索测试只传入当前知识库 ID
      // ChunkService 会将单个 ID 的数组转换为字符串传给 API
      final result = await ChunkService.retrievalTest(
        kbIds: [widget.kbId], // 只传入当前知识库 ID
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
  late TextEditingController _chunkTokenNumController;
  late TextEditingController _delimiterController;
  late TextEditingController _autoKeywordsController;
  late TextEditingController _autoQuestionsController;
  
  bool _isSaving = false;
  bool _isLoadingModels = false;
  bool _isLoadingKb = false;
  
  // 配置状态
  String? _avatarBase64;
  PermissionType _permission = PermissionType.me;
  LanguageType _language = LanguageType.chinese;
  DocumentParserType _parserId = DocumentParserType.naive;
  String? _selectedEmbeddingModel;
  List<LLMModel> _embeddingModels = [];
  String _layoutRecognize = 'DeepDOC';
  bool _html4excel = false;
  bool _useRaptor = false;
  bool _useGraphrag = false;
  int _pagerank = 0;
  
  KnowledgeBase? _currentKb;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.knowledgeBase?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.knowledgeBase?.description ?? '',
    );
    
    final parserConfig = widget.knowledgeBase?.parserConfig ?? {};
    _chunkTokenNumController = TextEditingController(
      text: (parserConfig['chunk_token_num'] ?? 512).toString(),
    );
    _delimiterController = TextEditingController(
      text: parserConfig['delimiter'] ?? '\n',
    );
    _autoKeywordsController = TextEditingController(
      text: (parserConfig['auto_keywords'] ?? 0).toString(),
    );
    _autoQuestionsController = TextEditingController(
      text: (parserConfig['auto_questions'] ?? 0).toString(),
    );
    
    // 初始化配置值
    _permission = PermissionType.fromString(widget.knowledgeBase?.permission);
    _language = LanguageType.fromString(widget.knowledgeBase?.language);
    _parserId = DocumentParserType.fromString(widget.knowledgeBase?.parserId) ?? DocumentParserType.naive;
    _selectedEmbeddingModel = widget.knowledgeBase?.embeddingModel;
    _avatarBase64 = widget.knowledgeBase?.avatar;
    _layoutRecognize = parserConfig['layout_recognize'] ?? 'DeepDOC';
    _html4excel = parserConfig['html4excel'] ?? false;
    _pagerank = widget.knowledgeBase?.pagerank ?? 0;
    
    final raptorConfig = parserConfig['raptor'] as Map<String, dynamic>?;
    _useRaptor = raptorConfig?['use_raptor'] ?? false;
    
    final graphragConfig = parserConfig['graphrag'] as Map<String, dynamic>?;
    _useGraphrag = graphragConfig?['use_graphrag'] ?? false;
    
    _loadKnowledgeBase();
    _loadEmbeddingModels();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _chunkTokenNumController.dispose();
    _delimiterController.dispose();
    _autoKeywordsController.dispose();
    _autoQuestionsController.dispose();
    super.dispose();
  }

  Future<void> _loadKnowledgeBase() async {
    setState(() {
      _isLoadingKb = true;
    });
    
    try {
      final kb = await KnowledgeService.getKnowledgeBaseDetail(widget.kbId);
      if (kb != null && mounted) {
        setState(() {
          _currentKb = kb;
          _isLoadingKb = false;
          // 更新表单值
          _nameController.text = kb.name;
          _descriptionController.text = kb.description ?? '';
          _permission = PermissionType.fromString(kb.permission);
          _language = LanguageType.fromString(kb.language);
          _parserId = DocumentParserType.fromString(kb.parserId) ?? DocumentParserType.naive;
          _selectedEmbeddingModel = kb.embeddingModel;
          _avatarBase64 = kb.avatar;
          _pagerank = kb.pagerank ?? 0;
          
          final parserConfig = kb.parserConfig ?? {};
          _chunkTokenNumController.text = (parserConfig['chunk_token_num'] ?? 512).toString();
          _delimiterController.text = parserConfig['delimiter'] ?? '\n';
          _autoKeywordsController.text = (parserConfig['auto_keywords'] ?? 0).toString();
          _autoQuestionsController.text = (parserConfig['auto_questions'] ?? 0).toString();
          _layoutRecognize = parserConfig['layout_recognize'] ?? 'DeepDOC';
          _html4excel = parserConfig['html4excel'] ?? false;
          
          final raptorConfig = parserConfig['raptor'] as Map<String, dynamic>?;
          _useRaptor = raptorConfig?['use_raptor'] ?? false;
          
          final graphragConfig = parserConfig['graphrag'] as Map<String, dynamic>?;
          _useGraphrag = graphragConfig?['use_graphrag'] ?? false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingKb = false;
        });
      }
    }
  }

  Future<void> _loadEmbeddingModels() async {
    setState(() {
      _isLoadingModels = true;
    });
    
    try {
      final models = await LLMService.getEmbeddingModels();
      if (mounted) {
        setState(() {
          _embeddingModels = models;
          _isLoadingModels = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingModels = false;
        });
      }
    }
  }

  Future<void> _pickAvatar() async {
    try {
      final picker = ImagePicker();
      
      // 显示选择来源对话框
      final ImageSource? source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('选择图片来源'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('从相册选择'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('拍照'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );
      
      if (source == null) {
        return; // 用户取消了选择
      }
      
      // 在 macOS 上，ImagePicker 使用文件选择对话框，不支持 maxWidth/maxHeight/imageQuality
      // 所以我们需要根据平台来决定是否传递这些参数
      XFile? pickedFile;
      try {
        if (Platform.isMacOS) {
          // macOS 上直接调用，不传递压缩参数
          pickedFile = await picker.pickImage(source: source);
        } else {
          // 其他平台可以使用压缩参数
          pickedFile = await picker.pickImage(
            source: source,
            maxWidth: 512,
            maxHeight: 512,
            imageQuality: 85,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('打开图片选择器失败: $e')),
          );
        }
        return;
      }
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          
          // 检查文件大小（限制为 4MB）
          if (bytes.length > 4 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('图片大小不能超过 4MB')),
              );
            }
            return;
          }
          
          // 转换为 base64，并添加 data URL 前缀（服务端要求）
          final base64String = base64Encode(bytes);
          // 根据文件扩展名确定 MIME 类型
          final extension = pickedFile.path.split('.').last.toLowerCase();
          final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
          final dataUrl = 'data:$mimeType;base64,$base64String';
          
          if (mounted) {
            setState(() {
              _avatarBase64 = dataUrl;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('图片已选择')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('文件不存在')),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
      // 打印详细错误信息用于调试
      debugPrint('Image picker error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // 构建 parser_config
      final parserConfig = <String, dynamic>{
        'layout_recognize': _layoutRecognize,
        'chunk_token_num': int.tryParse(_chunkTokenNumController.text) ?? 512,
        'delimiter': _delimiterController.text,
        'html4excel': _html4excel,
        'auto_keywords': int.tryParse(_autoKeywordsController.text) ?? 0,
        'auto_questions': int.tryParse(_autoQuestionsController.text) ?? 0,
      };
      
      if (_useRaptor) {
        parserConfig['raptor'] = {
          'use_raptor': true,
        };
      }
      
      if (_useGraphrag) {
        parserConfig['graphrag'] = {
          'use_graphrag': true,
        };
      }

      final success = await KnowledgeService.updateKnowledgeBase(
        id: widget.kbId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        parserId: _parserId.value,
        permission: _permission.value,
        embdId: _selectedEmbeddingModel,
        language: _language.value,
        avatar: _avatarBase64,
        parserConfig: parserConfig,
        pagerank: _pagerank,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存成功')),
        );
        // 重新加载知识库信息
        _loadKnowledgeBase();
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
    if (_isLoadingKb) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 基本信息
            _buildSectionTitle('基本信息'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '知识库名称 *',
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
            // 知识库图片
            _buildAvatarSection(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // 权限
            _buildPermissionSelector(),
            const SizedBox(height: 16),
            // 语言
            _buildLanguageSelector(),
            const SizedBox(height: 24),
            
            // 解析配置
            _buildSectionTitle('解析配置'),
            // 解析器（切片方法）
            _buildParserSelector(),
            const SizedBox(height: 16),
            // 嵌入模型
            _buildEmbeddingModelSelector(),
            const SizedBox(height: 16),
            // 建议文本块大小
            TextFormField(
              controller: _chunkTokenNumController,
              decoration: const InputDecoration(
                labelText: '建议文本块大小（Token数）',
                border: OutlineInputBorder(),
                helperText: '设置创建分块的Token阈值',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // 文本分段标识符
            TextFormField(
              controller: _delimiterController,
              decoration: const InputDecoration(
                labelText: '文本分段标识符',
                border: OutlineInputBorder(),
                helperText: '用于分割文本的标识符，如 \\n',
              ),
            ),
            const SizedBox(height: 16),
            // 布局识别
            _buildLayoutRecognizeSelector(),
            const SizedBox(height: 16),
            // 页面排名
            _buildPagerankSelector(),
            const SizedBox(height: 24),
            
            // 高级选项
            _buildSectionTitle('高级选项'),
            // 自动关键词提取
            TextFormField(
              controller: _autoKeywordsController,
              decoration: const InputDecoration(
                labelText: '自动关键词提取数量',
                border: OutlineInputBorder(),
                helperText: '0表示不提取',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // 自动问题提取
            TextFormField(
              controller: _autoQuestionsController,
              decoration: const InputDecoration(
                labelText: '自动问题提取数量',
                border: OutlineInputBorder(),
                helperText: '0表示不提取',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // 表格转HTML
            SwitchListTile(
              title: const Text('表格转HTML'),
              subtitle: const Text('将Excel表格转换为HTML格式'),
              value: _html4excel,
              onChanged: (value) {
                setState(() {
                  _html4excel = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // 使用召回增强 RAPTOR 策略
            SwitchListTile(
              title: const Text('使用召回增强 RAPTOR 策略'),
              subtitle: const Text('启用RAPTOR策略以增强召回效果'),
              value: _useRaptor,
              onChanged: (value) {
                setState(() {
                  _useRaptor = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // 提取知识图谱
            SwitchListTile(
              title: const Text('提取知识图谱'),
              subtitle: const Text('启用知识图谱提取功能'),
              value: _useGraphrag,
              onChanged: (value) {
                setState(() {
                  _useGraphrag = value;
                });
              },
            ),
            const SizedBox(height: 24),
            
            // 保存按钮
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '知识库图片',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (_avatarBase64 != null && _avatarBase64!.isNotEmpty)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildAvatarImage(_avatarBase64!),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, size: 40),
              ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _pickAvatar,
              icon: const Icon(Icons.upload),
              label: const Text('上传图片'),
            ),
            if (_avatarBase64 != null && _avatarBase64!.isNotEmpty) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _avatarBase64 = null;
                  });
                },
                child: const Text('清除'),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarImage(String avatarData) {
    try {
      String base64String = avatarData;
      
      // 如果是 data URL 格式（如 data:image/png;base64,xxx），提取 base64 部分
      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }
      
      // 解码 base64 字符串为 Uint8List
      final Uint8List imageBytes = base64Decode(base64String);
      
      // 使用 Image.memory 显示图片，添加错误处理
      return Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // 如果图片加载失败，显示默认图标
          return const Icon(Icons.image, size: 40);
        },
      );
    } catch (e) {
      // base64 解码失败，显示默认图标
      return const Icon(Icons.image, size: 40);
    }
  }

  Widget _buildPermissionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '权限',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SegmentedButton<PermissionType>(
          segments: PermissionType.values.map((type) {
            return ButtonSegment<PermissionType>(
              value: type,
              label: Text(type.label),
            );
          }).toList(),
          selected: {_permission},
          onSelectionChanged: (Set<PermissionType> newSelection) {
            setState(() {
              _permission = newSelection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return DropdownButtonFormField<LanguageType>(
      value: _language,
      decoration: const InputDecoration(
        labelText: '文档语言',
        border: OutlineInputBorder(),
      ),
      items: LanguageType.values.map((type) {
        return DropdownMenuItem<LanguageType>(
          value: type,
          child: Text(type.label),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _language = value;
          });
        }
      },
    );
  }

  Widget _buildParserSelector() {
    return DropdownButtonFormField<DocumentParserType>(
      value: _parserId,
      decoration: const InputDecoration(
        labelText: '切片方法（解析器）',
        border: OutlineInputBorder(),
        helperText: '选择文档解析和切片的方法',
      ),
      items: DocumentParserType.values.map((type) {
        return DropdownMenuItem<DocumentParserType>(
          value: type,
          child: Text(type.label),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _parserId = value;
          });
        }
      },
    );
  }

  Widget _buildEmbeddingModelSelector() {
    // 确保选中的值在列表中，如果不在则设为 null
    final validSelectedValue = _selectedEmbeddingModel != null &&
            _embeddingModels.any((model) => model.modelId == _selectedEmbeddingModel)
        ? _selectedEmbeddingModel
        : null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: validSelectedValue,
          decoration: InputDecoration(
            labelText: '嵌入模型',
            border: const OutlineInputBorder(),
            helperText: _currentKb?.chunkNum != null && _currentKb!.chunkNum > 0
                ? '注意：已有分块时更改嵌入模型需要删除所有分块'
                : '选择用于生成嵌入向量的模型',
            suffixIcon: _isLoadingModels
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadEmbeddingModels,
                  ),
          ),
          items: _embeddingModels.map((model) {
            return DropdownMenuItem<String>(
              value: model.modelId,
              child: Row(
                children: [
                  Text(model.displayName),
                  if (!model.available)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        '(不可用)',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: _currentKb?.chunkNum != null && _currentKb!.chunkNum > 0
              ? null
              : (value) {
                  setState(() {
                    _selectedEmbeddingModel = value;
                  });
                },
        ),
        if (_embeddingModels.isEmpty && !_isLoadingModels)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '暂无可用模型',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildLayoutRecognizeSelector() {
    return DropdownButtonFormField<String>(
      value: _layoutRecognize,
      decoration: const InputDecoration(
        labelText: '布局识别',
        border: OutlineInputBorder(),
        helperText: '选择布局识别方式',
      ),
      items: const [
        DropdownMenuItem(value: 'DeepDOC', child: Text('DeepDOC')),
        DropdownMenuItem(value: 'Plain Text', child: Text('纯文本')),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _layoutRecognize = value;
          });
        }
      },
    );
  }

  Widget _buildPagerankSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '页面排名',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _pagerank.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: _pagerank.toString(),
                onChanged: (value) {
                  setState(() {
                    _pagerank = value.toInt();
                  });
                },
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                _pagerank.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Text(
          '页面排名值，用于搜索结果排序',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
