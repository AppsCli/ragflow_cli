import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../strings.dart';
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
              SnackBar(content: Text(Strings.sendFailed(data['message'] ?? Strings.requestFailed))),
            );
            return;
          }

          if (data['code'] != null && data['code'] != 0) {
            setState(() {
              _isSending = false;
              _streamingAnswer = '';
            });
            final errorMessage = data['message'] as String? ?? Strings.requestFailed;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(Strings.sendFailed(errorMessage))),
            );
            return;
          }

          // Agent SSE 格式与聊天一致: data:{"code": 0, "message": "", "data": {"answer": "...", "reference": []}}
          // 每一行都是当前完整答案，直接替换；data 为 true 表示流结束
          final dataField = data['data'];
          if (dataField == true && dataField is bool) return;

          if (dataField is Map<String, dynamic>) {
            final completeAnswer = dataField['answer'] as String?;
            if (completeAnswer != null) {
              setState(() {
                _streamingAnswer = completeAnswer;
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
            SnackBar(content: Text(Strings.sendFailed(error.toString()))),
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
          SnackBar(content: Text(Strings.sendFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _resetAgent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Strings.resetAgent),
          content: Text(Strings.resetAgentConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(Strings.reset),
            ),
          ],
        );
      },
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
            SnackBar(content: Text(Strings.resetSuccess)),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.resetFailed)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${Strings.resetFailed}: $e')),
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
            tooltip: Strings.resetAgent,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(Strings.thinking),
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
                      decoration: InputDecoration(
                        hintText: Strings.enterMessage,
                        border: const OutlineInputBorder(),
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
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(Strings.stop, style: const TextStyle(color: Colors.white)),
                            ],
                          )
                        : Text(Strings.send),
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
                    isUser ? Strings.you : 'Agent',
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
