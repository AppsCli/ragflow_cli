import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../models/dialog.dart';
import '../services/chat_service.dart';

class DialogDetailPage extends StatefulWidget {
  final String dialogId;
  final String dialogName;

  const DialogDetailPage({
    super.key,
    required this.dialogId,
    required this.dialogName,
  });

  @override
  State<DialogDetailPage> createState() => _DialogDetailPageState();
}

class _DialogDetailPageState extends State<DialogDetailPage> {
  List<Conversation> _conversations = [];
  bool _isLoading = false;
  Conversation? _selectedConversation;
  bool _isSidebarVisible = true; // 控制左侧列表显示/隐藏

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final list = await ChatService.getConversationList(widget.dialogId);
      setState(() {
        _conversations = list;
        _isLoading = false;
      });
      
      // 如果有对话，默认选择第一个
      if (_conversations.isNotEmpty && _selectedConversation == null) {
        _selectedConversation = _conversations.first;
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载对话列表失败: $e')),
        );
      }
    }
  }

  Future<void> _selectConversation(String conversationId) async {
    try {
      // 通过 /v1/conversation/get?conversation_id= 获取完整的 conversation 信息
      final conversation = await ChatService.getConversation(conversationId);
      if (conversation != null && mounted) {
        setState(() {
          _selectedConversation = conversation;
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('获取对话信息失败')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('获取对话信息失败: $e')),
        );
      }
    }
  }

  Future<void> _createConversation() async {
    final nameController = TextEditingController(text: 'New conversation');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建新对话'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: '对话名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context, true);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('创建'),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.trim().isNotEmpty) {
      try {
        // 第一步：创建 conversation
        final newConversation = await ChatService.createConversation(
          dialogId: widget.dialogId,
          name: nameController.text.trim(),
        );

        if (newConversation != null) {
          // 第二步：刷新列表（获取创建后的列表）
          await _loadConversations();
          
          // 第三步：自动选择新创建的 conversation
          setState(() {
            _selectedConversation = newConversation;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('创建成功')),
            );
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('创建失败')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('创建失败: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dialogName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // 隐藏/显示列表按钮
          IconButton(
            icon: Icon(_isSidebarVisible ? Icons.menu_open : Icons.menu),
            onPressed: () {
              setState(() {
                _isSidebarVisible = !_isSidebarVisible;
              });
            },
            tooltip: _isSidebarVisible ? '隐藏列表' : '显示列表',
          ),
          // 刷新按钮
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConversations,
            tooltip: '刷新对话列表',
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧：对话列表（可隐藏）
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSidebarVisible ? 120 : 0, // 进一步减小宽度到 120
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              border: _isSidebarVisible
                  ? Border(
                      right: BorderSide(color: Colors.grey[300]!),
                    )
                  : null,
            ),
            child: _isSidebarVisible
                ? Column(
                    children: [
                      // 创建按钮
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _createConversation,
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('新建对话'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      // 对话列表
                      Expanded(
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : _conversations.isEmpty
                                ? const Center(
                                    child: Text('暂无对话', style: TextStyle(fontSize: 16)),
                                  )
                                : ListView.builder(
                                    itemCount: _conversations.length,
                                    padding: const EdgeInsets.all(8),
                                    itemBuilder: (context, index) {
                                      final conversation = _conversations[index];
                                      final isSelected =
                                          _selectedConversation?.id == conversation.id;
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        color: isSelected ? Colors.blue[50] : null,
                                        child: ListTile(
                                          title: Text(
                                            conversation.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          selected: isSelected,
                                          onTap: () {
                                            _selectConversation(conversation.id);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          // 右侧：聊天界面
          Expanded(
            child: _selectedConversation != null
                ? ChatView(
                    key: ValueKey(_selectedConversation!.id), // 添加 key 确保 conversation 改变时重建
                    conversation: _selectedConversation!,
                    dialogId: widget.dialogId,
                  )
                : const Center(
                    child: Text('请选择一个对话', style: TextStyle(fontSize: 16)),
                  ),
          ),
        ],
      ),
    );
  }
}

/// 聊天界面
class ChatView extends StatefulWidget {
  final Conversation conversation;
  final String dialogId;

  const ChatView({
    super.key,
    required this.conversation,
    required this.dialogId,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isSending = false;
  StreamSubscription? _completionSubscription;
  String _streamingAnswer = '';

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.conversation.messages);
  }

  @override
  void didUpdateWidget(ChatView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当 conversation 改变时，更新消息列表（参考 web 前端的 useEffect）
    if (oldWidget.conversation.id != widget.conversation.id ||
        oldWidget.conversation.messages.length != widget.conversation.messages.length) {
      setState(() {
        _messages = List.from(widget.conversation.messages);
        _streamingAnswer = '';
        _isSending = false;
      });
      // 取消之前的订阅
      _completionSubscription?.cancel();
      _completionSubscription = null;
      // 滚动到底部
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _completionSubscription?.cancel();
    super.dispose();
  }

  void _stopMessage() {
    // 终止消息发送
    _completionSubscription?.cancel();
    _completionSubscription = null;
    setState(() {
      _isSending = false;
      // 如果有流式内容，保存当前内容
      if (_streamingAnswer.isNotEmpty) {
        _messages.add(
          Message(content: _streamingAnswer, role: MessageRole.assistant),
        );
        _streamingAnswer = '';
      }
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    // 添加用户消息
    final userMessage = Message(content: text, role: MessageRole.user);
    setState(() {
      _messages.add(userMessage);
      _isSending = true;
      _streamingAnswer = '';
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      // 构建消息列表（格式：{"role": "user", "content": "..."}）
      final messagesForApi = _messages.map((msg) => {
        'role': msg.role.toString(),
        'content': msg.content,
      }).toList();

      // 使用 SSE 流式接收响应
      _completionSubscription?.cancel();
      _completionSubscription = ChatService.completion(
        conversationId: widget.conversation.id,
        messages: messagesForApi,
      ).listen(
        (data) {
          if (data['error'] == true) {
            setState(() {
              _isSending = false;
              _streamingAnswer = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('发送失败: ${data['message']}')),
            );
            return;
          }

          final answerData = data['data'] as Map<String, dynamic>?;
          if (answerData != null) {
            // SSE 流式响应中，answer 字段是增量更新的（delta），需要累加
            final delta = answerData['answer'] as String?;
            if (delta != null && delta.isNotEmpty) {
              setState(() {
                _streamingAnswer += delta; // 累加增量内容
              });
              _scrollToBottom();
            }
          }
        },
        onDone: () {
          // 流式响应完成，保存完整答案
          setState(() {
            if (_streamingAnswer.isNotEmpty) {
              _messages.add(
                Message(content: _streamingAnswer, role: MessageRole.assistant),
              );
            }
            _streamingAnswer = '';
            _isSending = false;
          });
          _scrollToBottom();
        },
        onError: (error) {
          setState(() {
            _isSending = false;
            _streamingAnswer = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('发送失败: $error')),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isSending = false;
        _streamingAnswer = '';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('发送失败: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 消息列表
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_streamingAnswer.isNotEmpty ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _messages.length) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              } else {
                // 显示流式响应
                return _buildMessageBubble(
                  Message(content: _streamingAnswer, role: MessageRole.assistant),
                  isStreaming: true,
                );
              }
            },
          ),
        ),
        // 输入框
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: '输入消息...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  enabled: !_isSending,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isSending ? _stopMessage : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSending ? Colors.red : null,
                ),
                child: _isSending
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('终止', style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : const Text('发送'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message, {bool isStreaming = false}) {
    final isUser = message.role == MessageRole.user;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.smart_toy, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: isUser
                  ? Text(
                      message.content,
                      style: const TextStyle(fontSize: 16),
                    )
                  : MarkdownBody(
                      data: message.content,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 16),
                        h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        h2: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        h3: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        code: TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.grey[300],
                          fontFamily: 'monospace',
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        blockquote: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
