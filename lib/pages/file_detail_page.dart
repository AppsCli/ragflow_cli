import 'package:flutter/material.dart';
import '../services/file_service.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
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
        title: Text(file['name'] ?? '未命名'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('ID: ${file['id']}'),
              Text('类型: ${file['type'] ?? '未知'}'),
              if (file['size'] != null)
                Text('大小: ${_formatFileSize(file['size'])}'),
              if (file['create_time'] != null)
                Text('创建时间: ${_formatDateTime(file['create_time'])}'),
              if (file['update_time'] != null)
                Text('更新时间: ${_formatDateTime(file['update_time'])}'),
              if (file['location'] != null)
                Text('位置: ${file['location']}'),
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDateTime(dynamic timestamp) {
    if (timestamp == null) return '未知';
    try {
      final ts = timestamp is int ? timestamp : int.tryParse(timestamp.toString());
      if (ts == null) return '未知';
      
      // 如果时间戳大于 10^10（10000000000），说明是毫秒级
      // 否则是秒级，需要乘以 1000
      final milliseconds = ts > 10000000000 ? ts : ts * 1000;
      final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return '未知';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName ?? '文件管理'),
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
                          '根目录',
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
                                folder['name'] ?? '未命名',
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
                        widget.folderName ?? _currentFolder?['name'] ?? '当前文件夹',
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
                hintText: '搜索文件...',
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
                    ? const Center(
                        child: Text('暂无文件', style: TextStyle(fontSize: 16)),
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
                                    ? Text('文件夹')
                                    : Text(
                                        '大小: ${_formatFileSize(file['size'] ?? 0)}',
                                      ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  if (isFolder) {
                                    // 进入文件夹
                                    _navigateToFolder(
                                      file['id'] ?? '',
                                      file['name'] ?? '未命名',
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
                    '共 $_total 个文件',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  if (_currentPage > 1)
                    TextButton.icon(
                      onPressed: () => _loadFiles(page: _currentPage - 1),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('上一页'),
                    ),
                  if ((_currentPage * _pageSize) < _total)
                    TextButton.icon(
                      onPressed: () => _loadFiles(page: _currentPage + 1),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('下一页'),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
