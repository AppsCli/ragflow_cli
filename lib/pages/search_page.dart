import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loadKnowledgeBaseFailed(e.toString()))),
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
    final l10n = AppLocalizations.of(context)!;
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterQuestion)),
      );
      return;
    }

    if (_selectedKbIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectAtLeastOneKnowledgeBase)),
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
      await ConversationService.askQuestion(
        question: question,
        kbIds: _selectedKbIds.toList(),
        onUpdate: (answer) {
          setState(() {
            _currentAnswer = answer.answer;
          });
        },
      );

      // 2. 获取相关文件
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.askQuestionFailed(e.toString()))),
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
        title: Text(AppLocalizations.of(context)!.search),
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
                      AppLocalizations.of(context)!.selectKnowledgeBase,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _loadKnowledgeBases,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(AppLocalizations.of(context)!.refresh),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _isLoadingKb
                    ? const Center(child: CircularProgressIndicator())
                    : _knowledgeBases.isEmpty
                        ? Text(
                            AppLocalizations.of(context)!.noKnowledgeBase,
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
                      hintText: AppLocalizations.of(context)!.enterQuestion,
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
                  label: Text(AppLocalizations.of(context)!.ask),
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
                        // 答案显示
                        if (_currentAnswer.isNotEmpty) ...[
                          Text(
                            AppLocalizations.of(context)!.answer,
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
                            child: SelectableText(
                              _currentAnswer,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 相关文件
                        if (_relatedChunks.isNotEmpty) ...[
                          Text(
                            AppLocalizations.of(context)!.relatedFiles,
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
                                        AppLocalizations.of(context)!.similarity((chunk.similarity! * 100).toStringAsFixed(1)),
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
                            AppLocalizations.of(context)!.relatedQuestions,
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
                      AppLocalizations.of(context)!.pleaseSelectKnowledgeBaseAndEnterQuestion,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
