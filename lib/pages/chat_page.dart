import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../strings.dart';
import '../models/dialog.dart' as models;
import '../services/chat_service.dart';
import 'dialog_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<models.Dialog> _dialogs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDialogs();
  }

  Future<void> _loadDialogs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ChatService.getDialogList();
      setState(() {
        _dialogs = list;
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

  Future<void> _showCreateDialog() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Strings.createNewDialog),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: Strings.dialogName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: Strings.descriptionOptional,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Strings.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(Strings.create),
            ),
          ],
        );
      },
    );

    if (result == true && nameController.text.trim().isNotEmpty) {
      try {
        final dialog = await ChatService.createDialog(
          name: nameController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? null
              : descriptionController.text.trim(),
        );
        if (dialog != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.createSuccess)),
          );
          _loadDialogs();
          
          // 自动跳转到新创建的对话
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DialogDetailPage(
                dialogId: dialog.id,
                dialogName: dialog.name,
              ),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.createFailed)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${Strings.createFailed}: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.chat),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDialogs,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _dialogs.isEmpty
              ? Center(
                  child: Text(Strings.noDialogs, style: const TextStyle(fontSize: 16)),
                )
              : RefreshIndicator(
                  onRefresh: _loadDialogs,
                  child: ListView.builder(
                    itemCount: _dialogs.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final dialog = _dialogs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: _buildAvatar(dialog.icon),
                          title: Text(dialog.name),
                          subtitle: Text(
                            dialog.description ?? Strings.noDescription,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DialogDetailPage(
                                  dialogId: dialog.id,
                                  dialogName: dialog.name,
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
      ),
    );
  }

  /// 构建头像 Widget
  /// 支持 URL 和 base64 格式
  Widget _buildAvatar(String? avatar) {
    if (avatar == null || avatar.isEmpty) {
      return const CircleAvatar(
        child: Icon(Icons.chat),
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
          child: Icon(Icons.chat),
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
        child: Icon(Icons.chat),
      );
    }
  }
}
