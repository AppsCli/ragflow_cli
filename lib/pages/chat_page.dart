import 'package:flutter/material.dart';
import '../models/dialog.dart' as models;
import '../services/chat_service.dart';

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
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('聊天'),
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
              ? const Center(
                  child: Text('暂无对话', style: TextStyle(fontSize: 16)),
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
                          leading: CircleAvatar(
                            backgroundImage:
                                dialog.icon != null ? NetworkImage(dialog.icon!) : null,
                            child: dialog.icon == null
                                ? const Icon(Icons.chat)
                                : null,
                          ),
                          title: Text(dialog.name),
                          subtitle: Text(
                            dialog.description ?? '暂无描述',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to chat detail
                          },
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Show create dialog dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
