import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../strings.dart';
import '../models/knowledge_base.dart';
import '../models/search_result.dart';
import '../services/knowledge_service.dart';
import '../services/conversation_service.dart';
import '../services/chunk_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // 知识库相关
  List<KnowledgeBase> _knowledgeBases = [];
  Set<String> _selectedKbIds = {};
  bool _isLoadingKb = false;

  // 搜索相关
  final TextEditingController _questionController = TextEditingController();
  bool _isAsking = false;
  String _currentAnswer = '';
  List<RetrievalChunk> _relatedChunks = [];
  List<String> _relatedQuestions = [];
  bool _isLoadingRelated = false;

  @override
  void initState() {
    super.initState();
    _loadKnowledgeBases();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  /// 加载知识库列表
  Future<void> _loadKnowledgeBases() async {
    setState(() {
      _isLoadingKb = true;
    });

    try {
      final kbs = await KnowledgeService.getKnowledgeBaseList(
        page: 1,
        pageSize: 100,
      );
      setState(() {
        _knowledgeBases = kbs;
        _isLoadingKb = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingKb = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.loadKnowledgeBaseFailed(e.toString()))),
        );
      }
    }
  }

  /// 切换知识库选择状态
  void _toggleKnowledgeBase(String kbId) {
    setState(() {
      if (_selectedKbIds.contains(kbId)) {
        _selectedKbIds.remove(kbId);
      } else {
        _selectedKbIds.add(kbId);
      }
    });
  }

  /// 发送问题
  Future<void> _askQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.enterQuestion)),
      );
      return;
    }

    if (_selectedKbIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.pleaseSelectAtLeastOneKnowledgeBase)),
      );
      return;
    }

    setState(() {
      _isAsking = true;
      _currentAnswer = '';
      _relatedChunks = [];
      _relatedQuestions = [];
    });

    try {
      // 1. 获取答案（SSE流式）
      // 参考 dialog_detail_page.dart 的实现，SSE 流式响应中每一行都是完整的答案，直接替换而不是累加
      await ConversationService.askQuestion(
        question: question,
        kbIds: _selectedKbIds.toList(),
        onUpdate: (answer) {
          setState(() {
            // SSE 流式响应中，每一行都是完整的答案，直接替换而不是累加
            // 参考 dialog_detail_page.dart 第 464-468 行
            final completeAnswer = answer.answer;
            if (completeAnswer != null) {
              _currentAnswer = completeAnswer; // 直接替换为完整答案
            }
            
            // 根据后端实现，只有 final=true 或 reference 不为空时才更新 reference
            // 流式传输过程中，中间消息的 reference 为空，只有最后一条消息包含完整的 reference
            if (answer.reference != null && answer.reference!.isNotEmpty) {
              // reference 格式：{"chunks": [...], "doc_aggs": [...]}
              final chunksList = answer.reference!['chunks'] as List<dynamic>?;
              if (chunksList != null && chunksList.isNotEmpty) {
                final chunks = chunksList
                    .map((chunk) {
                      try {
                        return RetrievalChunk.fromJson(chunk as Map<String, dynamic>);
                      } catch (e) {
                        return null;
                      }
                    })
                    .whereType<RetrievalChunk>()
                    .toList();
                
                if (chunks.isNotEmpty) {
                  _relatedChunks = chunks;
                }
              }
            }
          });
        },
      );

      // 2. 获取相关文件（如果 SSE 没有返回 reference，则使用 retrievalTest）
      // 注意：根据后端实现，SSE 流式传输的最后一条消息会包含完整的 reference
      // 如果已经通过 SSE 获取到了 chunks，则不需要再次调用 retrievalTest
      if (_relatedChunks.isEmpty) {
        try {
          final retrievalResult = await ChunkService.retrievalTest(
            kbIds: _selectedKbIds.toList(),
            question: question,
            page: 1,
            size: 10,
            highlight: true,
          );

          setState(() {
            _relatedChunks = retrievalResult.chunks;
          });
        } catch (e) {
          // 如果 retrievalTest 失败，不影响主流程
          print('获取相关文件失败: $e');
        }
      }

      // 3. 获取相关问题
      setState(() {
        _isLoadingRelated = true;
      });

      final related = await ConversationService.getRelatedQuestions(
        question: question,
      );

      setState(() {
        _relatedQuestions = related;
        _isLoadingRelated = false;
        _isAsking = false;
      });
    } catch (e) {
      setState(() {
        _isAsking = false;
        _isLoadingRelated = false;
      });
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.askQuestionFailed(e.toString()))),
          );
      }
    }
  }

  /// 点击相关问题
  void _onRelatedQuestionTap(String question) {
    _questionController.text = question;
    _askQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.search),
      ),
      body: Column(
        children: [
          // 知识库选择区域
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      Strings.selectKnowledgeBase,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _loadKnowledgeBases,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(Strings.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _isLoadingKb
                    ? const Center(child: CircularProgressIndicator())
                    : _knowledgeBases.isEmpty
                        ? Text(
                            Strings.noKnowledgeBase,
                            style: const TextStyle(color: Colors.grey),
                          )
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _knowledgeBases.map((kb) {
                              final isSelected = _selectedKbIds.contains(kb.id);
                              return FilterChip(
                                label: Text(kb.name),
                                selected: isSelected,
                                onSelected: (_) => _toggleKnowledgeBase(kb.id),
                              );
                            }).toList(),
                          ),
              ],
            ),
          ),

          // 问题输入区域
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: Strings.enterQuestion,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    enabled: !_isAsking,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isAsking ? null : _askQuestion,
                  icon: _isAsking
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(Strings.ask),
                ),
              ],
            ),
          ),

          // 结果展示区域
          Expanded(
            child: _isAsking || _currentAnswer.isNotEmpty || _relatedChunks.isNotEmpty || _relatedQuestions.isNotEmpty
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 答案显示（使用 Markdown 渲染）
                        if (_currentAnswer.isNotEmpty) ...[
                          Text(
                            Strings.answer,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: MarkdownBody(
                              data: _currentAnswer,
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
                          const SizedBox(height: 24),
                        ],

                        // 相关文件
                        if (_relatedChunks.isNotEmpty) ...[
                          Text(
                            Strings.relatedFiles,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._relatedChunks.map((chunk) {
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
                                        Strings.similarity((chunk.similarity! * 100).toStringAsFixed(1)),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      chunk.content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 24),
                        ],

                        // 相关问题
                        if (_isLoadingRelated)
                          const Center(child: CircularProgressIndicator())
                        else if (_relatedQuestions.isNotEmpty) ...[
                          Text(
                            Strings.relatedQuestions,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _relatedQuestions.map((q) {
                              return ActionChip(
                                label: Text(q),
                                onPressed: () => _onRelatedQuestionTap(q),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      Strings.pleaseSelectKnowledgeBaseAndEnterQuestion,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
