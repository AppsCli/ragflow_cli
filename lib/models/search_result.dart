/// 搜索结果中的答案
class SearchAnswer {
  final String answer;
  final List<Map<String, dynamic>> reference;
  final bool? done;

  SearchAnswer({
    required this.answer,
    required this.reference,
    this.done,
  });

  factory SearchAnswer.fromJson(Map<String, dynamic> json) {
    return SearchAnswer(
      answer: json['answer'] ?? '',
      reference: (json['reference'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>() ??
          [],
      done: json['done'],
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
