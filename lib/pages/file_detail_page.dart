import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/file_service.dart';
import '../services/api_client.dart';

class FileDetailPage extends StatefulWidget {
  final String? parentId;
  final String? folderName;

  const FileDetailPage({
    super.key,
    this.parentId,
    this.folderName,
  });

  @override
  State<FileDetailPage> createState() => _FileDetailPageState();
}

class _FileDetailPageState extends State<FileDetailPage> {
  List<Map<String, dynamic>> _files = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  int _total = 0;
  String _searchKeywords = '';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _breadcrumbs = [];
  Map<String, dynamic>? _currentFolder;

  @override
  void initState() {
    super.initState();
    _loadFiles();
    _loadBreadcrumbs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBreadcrumbs() async {
    if (widget.parentId == null) {
      setState(() {
        _breadcrumbs = [];
      });
      return;
    }

    try {
      final parentFolders = await FileService.getAllParentFolder(widget.parentId!);
      setState(() {
        _breadcrumbs = parentFolders;
      });
    } catch (e) {
      // 忽略错误，继续显示
    }
  }

  Future<void> _loadFiles({int? page, String? keywords}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pageNum = page ?? _currentPage;
      final keywordsStr = keywords ?? _searchKeywords;
      
      final result = await FileService.getFileList(
        parentId: widget.parentId,
        keywords: keywordsStr,
        page: pageNum,
        pageSize: _pageSize,
      );
      
      setState(() {
        _files = result.files;
        _total = result.total;
        _currentPage = pageNum;
        _currentFolder = result.parentFolder;
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
    _loadFiles(page: 1, keywords: keywords);
  }

  void _navigateToFolder(String folderId, String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FileDetailPage(
          parentId: folderId,
          folderName: folderName,
        ),
      ),
    );
  }

  void _navigateToBreadcrumb(String? folderId) {
    if (folderId == null) {
      // 返回根目录
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FileDetailPage(
            parentId: folderId,
          ),
        ),
      );
    }
  }

  void _showFileDetail(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(file['name'] ?? AppLocalizations.of(context)!.unnamed),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('${AppLocalizations.of(context)!.id}: ${file['id']}'),
              Text('${AppLocalizations.of(context)!.type}: ${file['type'] ?? AppLocalizations.of(context)!.unknown}'),
              if (file['size'] != null)
                Text('${AppLocalizations.of(context)!.size}: ${_formatFileSize(file['size'])}'),
              if (file['create_time'] != null)
                Text('${AppLocalizations.of(context)!.createTime}: ${_formatDateTime(file['create_time'])}'),
              if (file['update_time'] != null)
                Text('${AppLocalizations.of(context)!.updateTime}: ${_formatDateTime(file['update_time'])}'),
              if (file['location'] != null)
                Text('位置: ${file['location']}'), // TODO: 国际化位置标签
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDateTime(dynamic timestamp) {
    final l10n = AppLocalizations.of(context)!;
    if (timestamp == null) return l10n.unknown;
    try {
      final ts = timestamp is int ? timestamp : int.tryParse(timestamp.toString());
      if (ts == null) return l10n.unknown;
      
      // 如果时间戳大于 10^10（10000000000），说明是毫秒级
      // 否则是秒级，需要乘以 1000
      final milliseconds = ts > 10000000000 ? ts : ts * 1000;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      return l10n.unknown;
    }
  }

  Future<void> _previewFile(Map<String, dynamic> file) async {
    final fileId = file['id'] as String?;
    final fileName = file['name'] as String? ?? '';
    if (fileId == null) return;

    try {
      final previewUrl = FileService.getFilePreviewUrl(fileId, fileName);
      final uri = Uri.parse(previewUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cannotOpenPreview(previewUrl))),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.previewFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _downloadFile(Map<String, dynamic> file) async {
    final fileId = file['id'] as String?;
    final fileName = file['name'] as String? ?? 'file';
    if (fileId == null) return;

    try {
      final l10n = AppLocalizations.of(context)!;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.downloading)),
        );
      }

      final fileBytes = await FileService.downloadFile(fileId);
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

  Future<void> _deleteFile(Map<String, dynamic> file) async {
    final fileId = file['id'] as String?;
    final fileName = file['name'] as String? ?? AppLocalizations.of(context)!.unnamed;
    if (fileId == null) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.confirmDelete),
          content: Text(l10n.confirmDeleteFile(fileName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final l10n = AppLocalizations.of(context)!;
        final success = await FileService.deleteFile([fileId]);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deleteSuccess)),
          );
          _loadFiles(); // 刷新列表
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.deleteFailed)),
          );
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.deleteFailed}: $e')),
          );
        }
      }
    }
  }

  Future<void> _uploadFile() async {
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
        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            final success = await FileService.uploadFile(
              file,
              parentId: widget.parentId,
            );
            if (!success) {
              allSuccess = false;
            }
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(allSuccess ? l10n.uploadSuccess : l10n.partialUploadFailed),
            ),
          );
          _loadFiles(); // 刷新列表
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName ?? AppLocalizations.of(context)!.fileManagement),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadFiles(),
          ),
        ],
      ),
      body: Column(
        children: [
          // 面包屑导航
          if (_breadcrumbs.isNotEmpty || widget.parentId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // 根目录
                    InkWell(
                      onTap: () => _navigateToBreadcrumb(null),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          AppLocalizations.of(context)!.rootDirectory,
                          style: TextStyle(
                            color: widget.parentId == null
                                ? Theme.of(context).primaryColor
                                : Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    // 上级文件夹
                    ..._breadcrumbs.map((folder) {
                      return Row(
                        children: [
                          const Text(' / '),
                          InkWell(
                            onTap: () => _navigateToBreadcrumb(folder['id']),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                folder['name'] ?? AppLocalizations.of(context)!.unnamed,
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    // 当前文件夹
                    if (widget.parentId != null) ...[
                      const Text(' / '),
                      Text(
                        widget.folderName ?? _currentFolder?['name'] ?? AppLocalizations.of(context)!.currentFolder,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          // 搜索框
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchFiles,
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
                if (value.isEmpty) {
                  _handleSearch('');
                }
              },
            ),
          ),
          // 文件列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _files.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!.noFiles, style: const TextStyle(fontSize: 16)),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadFiles(),
                        child: ListView.builder(
                          itemCount: _files.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final file = _files[index];
                            final isFolder = file['type'] == 'folder';
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: Icon(
                                  isFolder ? Icons.folder : Icons.insert_drive_file,
                                  color: isFolder ? Colors.orange : null,
                                ),
                                title: Text(file['name'] ?? '未命名'),
                                subtitle: isFolder
                                    ? Text(AppLocalizations.of(context)!.folder)
                                    : Text(
                                        '${AppLocalizations.of(context)!.size}: ${_formatFileSize(file['size'] ?? 0)}',
                                      ),
                                trailing: isFolder
                                    ? const Icon(Icons.chevron_right)
                                    : PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'preview') {
                                            _previewFile(file);
                                          } else if (value == 'download') {
                                            _downloadFile(file);
                                          } else if (value == 'delete') {
                                            _deleteFile(file);
                                          } else if (value == 'detail') {
                                            _showFileDetail(file);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'preview',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.preview, size: 20),
                                                const SizedBox(width: 8),
                                                Text(AppLocalizations.of(context)!.preview),
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
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.delete, color: Colors.red, size: 20),
                                                const SizedBox(width: 8),
                                                Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                onTap: () {
                                  if (isFolder) {
                                    // 进入文件夹
                                    _navigateToFolder(
                                      file['id'] ?? '',
                                      file['name'] ?? AppLocalizations.of(context)!.unnamed,
                                    );
                                  } else {
                                    // 查看文件详情
                                    _showFileDetail(file);
                                  }
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
                    AppLocalizations.of(context)!.totalFiles(_total),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  if (_currentPage > 1)
                    TextButton.icon(
                      onPressed: () => _loadFiles(page: _currentPage - 1),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: Text(AppLocalizations.of(context)!.previousPage),
                    ),
                  if ((_currentPage * _pageSize) < _total)
                    TextButton.icon(
                      onPressed: () => _loadFiles(page: _currentPage + 1),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(AppLocalizations.of(context)!.nextPage),
                    ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        child: const Icon(Icons.upload),
        tooltip: AppLocalizations.of(context)!.uploadFile,
      ),
    );
  }
}
