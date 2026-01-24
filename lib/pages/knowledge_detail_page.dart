import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';
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
        title: Text(_knowledgeBase?.name ?? AppLocalizations.of(context)!.knowledgeBaseDetail),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.dataset),
            Tab(text: AppLocalizations.of(context)!.retrievalTest),
            Tab(text: AppLocalizations.of(context)!.config),
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loadDocumentsFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _deleteDocument(String id) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.confirmDelete),
          content: Text(l10n.confirmDeleteDocument),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final l10n = AppLocalizations.of(context)!;
      final success = await DocumentService.deleteDocument(id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deleteSuccess)),
        );
        _loadDocuments();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deleteFailed)),
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
              hintText: AppLocalizations.of(context)!.searchDocuments,
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
                  ? Center(
                      child: Text(AppLocalizations.of(context)!.noDocuments, style: const TextStyle(fontSize: 16)),
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
                                      Text('${AppLocalizations.of(context)!.chunks}: ${doc.chunkNum} | ${AppLocalizations.of(context)!.tokens}: ${doc.tokenNum}'),
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
                                      '${AppLocalizations.of(context)!.update}: ${_formatDateTime(doc.updateTime!)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'detail',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.info, size: 20),
                                        const SizedBox(width: 8),
                                        Text(AppLocalizations.of(context)!.detail),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'download',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.download, size: 20),
                                        const SizedBox(width: 8),
                                        Text(AppLocalizations.of(context)!.download),
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
                                    PopupMenuItem(
                                      value: 'parse',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.play_arrow, size: 20),
                                          const SizedBox(width: 8),
                                          Text(AppLocalizations.of(context)!.parse),
                                        ],
                                      ),
                                    ),
                                  // 显示"取消解析"选项：解析中状态
                                  if (doc.run == '1' || doc.run == 'RUNNING')
                                    PopupMenuItem(
                                      value: 'cancel',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.stop, size: 20, color: Colors.orange),
                                          const SizedBox(width: 8),
                                          Text(AppLocalizations.of(context)!.cancelParse, style: const TextStyle(color: Colors.orange)),
                                        ],
                                      ),
                                    ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.delete, size: 20, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Text(AppLocalizations.of(context)!.deleteDocument, style: const TextStyle(color: Colors.red)),
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
                  AppLocalizations.of(context)!.totalDocuments(_total),
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
                    label: Text(AppLocalizations.of(context)!.previousPage),
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
                    label: Text(AppLocalizations.of(context)!.nextPage),
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
            tooltip: AppLocalizations.of(context)!.uploadFile,
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
              Text('${AppLocalizations.of(context)!.id}: ${doc.id}'),
              Text('${AppLocalizations.of(context)!.suffix}: ${doc.suffix}'),
              Text('${AppLocalizations.of(context)!.size}: ${_formatFileSize(doc.size)}'),
              Text('${AppLocalizations.of(context)!.chunkCount}: ${doc.chunkNum}'),
              Text('${AppLocalizations.of(context)!.tokenCount}: ${doc.tokenNum}'),
              Text('${AppLocalizations.of(context)!.status}: ${_getStatusText(doc.run ?? doc.status)}'),
              if (doc.description != null)
                Text('${AppLocalizations.of(context)!.description}: ${doc.description}'),
              if (doc.createTime != null)
                Text('${AppLocalizations.of(context)!.createTime}: ${_formatDateTime(doc.createTime!)}'),
              if (doc.updateTime != null)
                Text('${AppLocalizations.of(context)!.updateTime}: ${_formatDateTime(doc.updateTime!)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String? status) {
    final l10n = AppLocalizations.of(context)!;
    if (status == null) return l10n.unknown;
    switch (status) {
      case '0':
      case 'UNSTART':
        return l10n.notStarted;
      case '1':
      case 'RUNNING':
        return l10n.parsing;
      case '2':
      case 'CANCEL':
        return l10n.cancelled;
      case '3':
      case 'DONE':
        return l10n.completed;
      case '4':
      case 'FAIL':
        return l10n.failed;
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
      final l10n = AppLocalizations.of(context)!;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.downloading)),
        );
      }

      final fileBytes = await DocumentService.downloadDocument(doc.id);
      if (fileBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.downloadFailed)),
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
          SnackBar(content: Text(l10n.downloadSuccess(filePath))),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.downloadFailed}: $e')),
        );
      }
    }
  }

  Future<void> _parseDocument(Document doc) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.startingParse)),
        );
      }

      final success = await DocumentService.runDocument(
        docIds: [doc.id],
        run: 1,
        shouldDelete: false,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.parseStarted)),
        );
        _loadDocuments(); // 刷新列表
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.startParseFailed)),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.startParseFailed}: $e')),
        );
      }
    }
  }

  Future<void> _cancelParseDocument(Document doc) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.confirmCancel),
          content: Text(l10n.confirmCancelParse(doc.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.confirm, style: const TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final l10n = AppLocalizations.of(context)!;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cancellingParse)),
          );
        }

        final success = await DocumentService.runDocument(
          docIds: [doc.id],
          run: 2, // 2 表示取消（CANCEL）
          shouldDelete: false,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.parseCancelled)),
          );
          _loadDocuments(); // 刷新列表
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cancelParseFailed)),
          );
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.cancelParseFailed}: $e')),
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
        final l10n = AppLocalizations.of(context)!;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.uploading)),
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
              SnackBar(content: Text(l10n.uploadSuccess)),
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
              SnackBar(content: Text(l10n.partialUploadFailed)),
            );
            _loadDocuments(); // 刷新列表
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.uploadFailed)),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.uploadFailed}: $e')),
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
    final l10n = AppLocalizations.of(context)!;
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterQuestion)),
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.retrievalTestFailed(e.toString()))),
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
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterQuestionForRetrieval,
                    border: const OutlineInputBorder(),
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
                label: Text(AppLocalizations.of(context)!.test),
              ),
            ],
          ),
        ),
        // 结果列表
        Expanded(
          child: _chunks.isEmpty
              ? Center(
                  child: Text(
                    _isLoading ? AppLocalizations.of(context)!.retrieving : AppLocalizations.of(context)!.enterQuestionForRetrievalTest,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.retrievalResults(_total),
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
                                    AppLocalizations.of(context)!.similarity((chunk.similarity! * 100).toStringAsFixed(1)),
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
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.selectImageSource),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(l10n.selectFromGallery),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(l10n.takePhoto),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          );
        },
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
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.selectImageFailed(e.toString()))),
          );
        }
        return;
      }
      
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          
          // 检查文件大小（限制为 4MB）
          final l10n = AppLocalizations.of(context)!;
          if (bytes.length > 4 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.imageTooLarge)),
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
              SnackBar(content: Text(l10n.imageSelected)),
            );
          }
        } else {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.fileNotExists)),
            );
          }
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.selectImageFailed(e.toString()))),
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

      final l10n = AppLocalizations.of(context)!;
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saveSuccess)),
        );
        // 重新加载知识库信息
        _loadKnowledgeBase();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.saveFailed)),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.saveFailed}: $e')),
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
            _buildSectionTitle(AppLocalizations.of(context)!.basicInfo),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${AppLocalizations.of(context)!.knowledgeBaseName} *',
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)!.knowledgeBaseNameRequired;
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.description,
                border: const OutlineInputBorder(),
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
            _buildSectionTitle(AppLocalizations.of(context)!.parseConfig),
            // 解析器（切片方法）
            _buildParserSelector(),
            const SizedBox(height: 16),
            // 嵌入模型
            _buildEmbeddingModelSelector(),
            const SizedBox(height: 16),
            // 建议文本块大小
            TextFormField(
              controller: _chunkTokenNumController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.suggestedChunkSize,
                border: const OutlineInputBorder(),
                helperText: AppLocalizations.of(context)!.chunkSizeHelper,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // 文本分段标识符
            TextFormField(
              controller: _delimiterController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.textDelimiter,
                border: const OutlineInputBorder(),
                helperText: AppLocalizations.of(context)!.delimiterHelper,
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
            _buildSectionTitle(AppLocalizations.of(context)!.advancedOptions),
            // 自动关键词提取
            TextFormField(
              controller: _autoKeywordsController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.autoKeywordsCount,
                border: const OutlineInputBorder(),
                helperText: AppLocalizations.of(context)!.autoKeywordsHelper,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // 自动问题提取
            TextFormField(
              controller: _autoQuestionsController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.autoQuestionsCount,
                border: const OutlineInputBorder(),
                helperText: AppLocalizations.of(context)!.autoQuestionsHelper,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            // 表格转HTML
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.tableToHtml),
              subtitle: Text(AppLocalizations.of(context)!.tableToHtmlSubtitle),
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
              title: Text(AppLocalizations.of(context)!.useRaptor),
              subtitle: Text(AppLocalizations.of(context)!.useRaptorSubtitle),
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
              title: Text(AppLocalizations.of(context)!.extractKnowledgeGraph),
              subtitle: Text(AppLocalizations.of(context)!.extractKnowledgeGraphSubtitle),
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
              label: Text(AppLocalizations.of(context)!.saveConfig),
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
        Text(
          AppLocalizations.of(context)!.knowledgeBaseImage,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
              label: Text(AppLocalizations.of(context)!.uploadImage),
            ),
            if (_avatarBase64 != null && _avatarBase64!.isNotEmpty) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _avatarBase64 = null;
                  });
                },
                child: Text(AppLocalizations.of(context)!.clear),
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.permission,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SegmentedButton<PermissionType>(
          segments: PermissionType.values.map((type) {
            return ButtonSegment<PermissionType>(
              value: type,
              label: Text(
                switch (type) {
                  PermissionType.me => l10n.permissionOnlyMe,
                  PermissionType.team => l10n.permissionTeam,
                },
              ),
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
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<LanguageType>(
      value: _language,
      decoration: InputDecoration(
        labelText: l10n.documentLanguage,
        border: const OutlineInputBorder(),
      ),
      items: LanguageType.values.map((type) {
        return DropdownMenuItem<LanguageType>(
          value: type,
          child: Text(
            switch (type) {
              LanguageType.chinese => l10n.languageChinese,
              LanguageType.english => l10n.languageEnglish,
            },
          ),
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
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<DocumentParserType>(
      value: _parserId,
      decoration: InputDecoration(
        labelText: l10n.sliceMethod,
        border: const OutlineInputBorder(),
        helperText: l10n.sliceMethodHelper,
      ),
      items: DocumentParserType.values.map((type) {
        return DropdownMenuItem<DocumentParserType>(
          value: type,
          child: Text(
            switch (type) {
              DocumentParserType.naive => l10n.parserNaive,
              DocumentParserType.qa => l10n.parserQa,
              DocumentParserType.resume => l10n.parserResume,
              DocumentParserType.manual => l10n.parserManual,
              DocumentParserType.table => l10n.parserTable,
              DocumentParserType.paper => l10n.parserPaper,
              DocumentParserType.book => l10n.parserBook,
              DocumentParserType.laws => l10n.parserLaws,
              DocumentParserType.presentation => l10n.parserPresentation,
              DocumentParserType.picture => l10n.parserPicture,
              DocumentParserType.one => l10n.parserOne,
              DocumentParserType.audio => l10n.parserAudio,
              DocumentParserType.email => l10n.parserEmail,
              DocumentParserType.tag => l10n.parserTag,
              DocumentParserType.knowledgeGraph => l10n.parserKnowledgeGraph,
            },
          ),
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
            labelText: AppLocalizations.of(context)!.embeddingModel,
            border: const OutlineInputBorder(),
            helperText: _currentKb?.chunkNum != null && _currentKb!.chunkNum > 0
                ? AppLocalizations.of(context)!.embeddingModelWarning
                : AppLocalizations.of(context)!.embeddingModelHelper,
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
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              AppLocalizations.of(context)!.noModelsAvailable,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildLayoutRecognizeSelector() {
    return DropdownButtonFormField<String>(
      value: _layoutRecognize,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.layoutRecognition,
        border: const OutlineInputBorder(),
        helperText: AppLocalizations.of(context)!.layoutRecognitionHelper,
      ),
      items: [
        const DropdownMenuItem(value: 'DeepDOC', child: Text('DeepDOC')),
        DropdownMenuItem(value: 'Plain Text', child: Text(AppLocalizations.of(context)!.plainText)),
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
        Text(
          AppLocalizations.of(context)!.pageRank,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
        Text(
          AppLocalizations.of(context)!.pageRankHelper,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
