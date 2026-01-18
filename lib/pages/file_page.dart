import 'package:flutter/material.dart';
import '../services/file_service.dart';

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  List<Map<String, dynamic>> _files = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await FileService.getFileList();
      setState(() {
        _files = list;
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
        title: const Text('文件管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFiles,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? const Center(
                  child: Text('暂无文件', style: TextStyle(fontSize: 16)),
                )
              : RefreshIndicator(
                  onRefresh: _loadFiles,
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
                          leading: Icon(isFolder ? Icons.folder : Icons.insert_drive_file),
                          title: Text(file['name'] ?? '未命名'),
                          subtitle: isFolder
                              ? null
                              : Text(
                                  '大小: ${_formatFileSize(file['size'] ?? 0)}',
                                ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Handle file/folder tap
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () {
              // TODO: Show file picker
            },
            child: const Icon(Icons.upload),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'folder',
            onPressed: () {
              // TODO: Show create folder dialog
            },
            child: const Icon(Icons.create_new_folder),
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
}
