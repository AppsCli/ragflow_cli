import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../services/agent_service.dart';

class AgentDetailPage extends StatefulWidget {
  final String agentId;
  final String agentName;

  const AgentDetailPage({
    super.key,
    required this.agentId,
    required this.agentName,
  });

  @override
  State<AgentDetailPage> createState() => _AgentDetailPageState();
}

class _AgentDetailPageState extends State<AgentDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isSending = false;
  StreamSubscription? _completionSubscription;
  String _streamingAnswer = '';
  String? _sessionId;

  @override
  void initState() {
    super.initState();
    _loadAgentDetail();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _completionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadAgentDetail() async {
    // 可以在这里加载 agent 详情信息
    // final detail = await AgentService.getAgentDetail(widget.agentId);
  }

  void _stopMessage() {
    // 终止消息发送
    _completionSubscription?.cancel();
    _completionSubscription = null;
    setState(() {
      _isSending = false;
      // 如果有流式内容，保存当前内容
      if (_streamingAnswer.isNotEmpty) {
        _messages.add({
          'role': 'assistant',
          'content': _streamingAnswer,
        });
        _streamingAnswer = '';
      }
    });
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    // 添加用户消息
    setState(() {
      _messages.add({
        'role': 'user',
        'content': text,
      });
      _isSending = true;
      _streamingAnswer = '';
      _messageController.clear();
    });

    _scrollToBottom();

    try {
      // 使用 SSE 流式接收响应
      _completionSubscription?.cancel();
      _completionSubscription = AgentService.agentCompletion(
        agentId: widget.agentId,
        query: text,
        sessionId: _sessionId,
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

          // Agent 的 SSE 响应格式: {"event": "message", "data": {"content": "...", ...}, "session_id": "..."}
          // 根据 API 代码，直接返回 ans 对象，包含 event、data、session_id 等字段
          if (data['session_id'] != null) {
            setState(() {
              _sessionId = data['session_id'] as String;
            });
          }

          // 处理消息内容
          if (data['event'] == 'message' && data['data'] != null) {
            final messageData = data['data'] as Map<String, dynamic>;
            final content = messageData['content'] as String?;
            if (content != null && content.isNotEmpty) {
              setState(() {
                _streamingAnswer += content; // 累加增量内容
              });
              _scrollToBottom();
            }
          }
        },
        onDone: () {
          // 流式响应完成，保存完整答案
          setState(() {
            if (_streamingAnswer.isNotEmpty) {
              _messages.add({
                'role': 'assistant',
                'content': _streamingAnswer,
              });
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

  Future<void> _resetAgent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置 Agent'),
        content: const Text('确定要重置 Agent 吗？这将清除当前对话历史。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('重置'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await AgentService.resetAgent(widget.agentId);
        if (success && mounted) {
          setState(() {
            _messages.clear();
            _sessionId = null;
            _streamingAnswer = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('重置成功')),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('重置失败')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('重置失败: $e')),
          );
        }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.agentName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetAgent,
            tooltip: '重置 Agent',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length + (_streamingAnswer.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  final message = _messages[index];
                  return _buildMessageBubble(
                    message['role'] as String,
                    message['content'] as String,
                  );
                } else {
                  // 显示流式响应中的部分答案
                  return _buildMessageBubble('assistant', _streamingAnswer, isStreaming: true);
                }
              },
            ),
          ),
          if (_isSending && _streamingAnswer.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('思考中...'),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String role, String content, {bool isStreaming = false}) {
    final isUser = role == 'user';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isUser ? '你' : 'Agent',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isUser ? Colors.blue[800] : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  isUser
                      ? Text(
                          content,
                          style: const TextStyle(fontSize: 16.0),
                        )
                      : MarkdownBody(
                          data: content,
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
                  if (isStreaming)
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                ],
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
