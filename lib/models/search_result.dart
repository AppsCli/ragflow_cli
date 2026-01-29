/// 搜索结果中的答案
class SearchAnswer {
  final String answer;
  final Map<String, dynamic>? reference; // 改为 Map，因为后端返回的是对象，不是数组
  final bool? done;
  final bool? final_; // 后端返回 final 字段表示是否完成

  SearchAnswer({
    required this.answer,
    this.reference,
    this.done,
    this.final_,
  });

  factory SearchAnswer.fromJson(Map<String, dynamic> json) {
    return SearchAnswer(
      answer: json['answer'] ?? '',
      reference: json['reference'] as Map<String, dynamic>?,
      done: json['done'],
      final_: json['final'] as bool?,
    );
  }
}

/// 检索测试结果中的文件块
class RetrievalChunk {
  final String chunkId;
  final String docId;
  final String docName;
  final String content;
  final double? similarity;
  final Map<String, dynamic>? metadata;

  RetrievalChunk({
    required this.chunkId,
    required this.docId,
    required this.docName,
    required this.content,
    this.similarity,
    this.metadata,
  });

  factory RetrievalChunk.fromJson(Map<String, dynamic> json) {
    return RetrievalChunk(
      chunkId: json['chunk_id'] ?? json['id'] ?? '',
      docId: json['doc_id'] ?? '',
      docName: json['doc_name'] ?? json['document_name'] ?? '',
      content: json['content'] ?? json['text'] ?? '',
      similarity: json['similarity'] != null
          ? (json['similarity'] as num).toDouble()
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// 检索测试结果
class RetrievalTestResult {
  final List<RetrievalChunk> chunks;
  final List<Map<String, dynamic>> documents;
  final int total;

  RetrievalTestResult({
    required this.chunks,
    required this.documents,
    required this.total,
  });

  factory RetrievalTestResult.fromJson(Map<String, dynamic> json) {
    return RetrievalTestResult(
      chunks: (json['chunks'] as List<dynamic>?)
              ?.map((e) => RetrievalChunk.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      documents: (json['doc_aggs'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}
