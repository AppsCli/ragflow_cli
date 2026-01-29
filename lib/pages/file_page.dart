import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker_ohos/file_picker_ohos.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import '../strings.dart';
import '../services/file_service.dart';
import 'file_detail_page.dart';

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
      final result = await FileService.getFileList();
      setState(() {
        _files = result.files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.loadFailed(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.fileManagement),
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
              ? Center(
                  child: Text(Strings.noFiles, style: const TextStyle(fontSize: 16)),
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
                          title: Text(file['name'] ?? Strings.unnamed),
                          subtitle: isFolder
                              ? null
                              : Text(
                                  '${Strings.size}: ${_formatFileSize(file['size'] ?? 0)}',
                                ),
                                trailing: file['type'] == 'folder'
                                    ? const Icon(Icons.chevron_right)
                                    : PopupMenuButton<String>(
                                        onSelected: (value) async {
                                          if (value == 'preview') {
                                            await _previewFile(file);
                                          } else if (value == 'download') {
                                            await _downloadFile(file);
                                          } else if (value == 'delete') {
                                            await _deleteFile(file);
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
                                                Text(Strings.preview),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'download',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.download, size: 20),
                                                const SizedBox(width: 8),
                                                Text(Strings.download),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'detail',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.info, size: 20),
                                                const SizedBox(width: 8),
                                                Text(Strings.detail),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.delete, color: Colors.red, size: 20),
                                                const SizedBox(width: 8),
                                                Text(Strings.delete, style: const TextStyle(color: Colors.red)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                onTap: () {
                                  if (file['type'] == 'folder') {
                                    // 进入文件夹
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FileDetailPage(
                                          parentId: file['id'],
                                          folderName: file['name'],
                                        ),
                                      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        child: const Icon(Icons.upload),
        tooltip: Strings.uploadFile,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.cannotOpenPreview(previewUrl))),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.previewFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _downloadFile(Map<String, dynamic> file) async {
    final fileId = file['id'] as String?;
    final fileName = file['name'] as String? ?? 'file';
    if (fileId == null) return;

    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.downloading)),
        );
      }

      final fileBytes = await FileService.downloadFile(fileId);
      if (fileBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.downloadFailed)),
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
          SnackBar(content: Text(Strings.downloadSuccess(filePath))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.downloadFailed}: $e')),
        );
      }
    }
  }

  Future<void> _deleteFile(Map<String, dynamic> file) async {
    final fileId = file['id'] as String?;
    final fileName = file['name'] as String? ?? Strings.unnamed;
    if (fileId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Strings.confirmDelete),
          content: Text(Strings.confirmDeleteFile(fileName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(Strings.delete, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final success = await FileService.deleteFile([fileId]);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.deleteSuccess)),
          );
          _loadFiles(); // 刷新列表
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.deleteFailed)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${Strings.deleteFailed}: $e')),
          );
        }
      }
    }
  }

  void _showFileDetail(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(file['name'] ?? Strings.unnamed),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('${Strings.id}: ${file['id']}'),
              Text('${Strings.type}: ${file['type'] ?? Strings.unknown}'),
              Text('${Strings.size}: ${_formatFileSize(file['size'] ?? 0)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.close),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.uploading)),
          );
        }

        bool allSuccess = true;
        for (final platformFile in result.files) {
          if (platformFile.path != null) {
            final file = File(platformFile.path!);
            final success = await FileService.uploadFile(file);
            if (!success) {
              allSuccess = false;
            }
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(allSuccess ? Strings.uploadSuccess : Strings.partialUploadFailed),
            ),
          );
          _loadFiles(); // 刷新列表
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.uploadFailed}: $e')),
        );
      }
    }
  }
}
