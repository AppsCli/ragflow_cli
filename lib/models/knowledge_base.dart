class KnowledgeBase {
  final String id;
  final String name;
  final String? description;
  final String? avatar;
  final String language;
  final String embeddingModel;
  final String? status;
  final int chunkNum;
  final int documentNum;
  final DateTime? createTime;
  final DateTime? updateTime;
  
  // 配置字段
  final String? permission; // 'me' | 'team'
  final String? parserId; // 解析器ID
  final Map<String, dynamic>? parserConfig; // 解析器配置
  final int? pagerank; // 页面排名
  final List<String>? tagKbIds; // 标签集

  KnowledgeBase({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    this.language = 'Chinese',
    this.embeddingModel = '',
    this.status,
    this.chunkNum = 0,
    this.documentNum = 0,
    this.createTime,
    this.updateTime,
    this.permission,
    this.parserId,
    this.parserConfig,
    this.pagerank,
    this.tagKbIds,
  });

  factory KnowledgeBase.fromJson(Map<String, dynamic> json) {
    return KnowledgeBase(
      id: json['id'] ?? json['kb_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      avatar: json['avatar'] ?? json['icon'],
      language: json['language'] ?? 'Chinese',
      embeddingModel: json['embedding_model'] ?? json['embd_id'] ?? '',
      status: json['status'],
      chunkNum: json['chunk_num'] ?? 0,
      documentNum: json['document_num'] ?? json['doc_num'] ?? 0,
      createTime: json['create_time'] != null
          ? _parseTimestamp(json['create_time'])
          : null,
      updateTime: json['update_time'] != null
          ? _parseTimestamp(json['update_time'])
          : null,
      permission: json['permission'],
      parserId: json['parser_id'] ?? json['chunk_method'],
      parserConfig: json['parser_config'] as Map<String, dynamic>?,
      pagerank: json['pagerank'] as int?,
      tagKbIds: json['tag_kb_ids'] != null
          ? (json['tag_kb_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList()
          : null,
    );
  }

  /// 解析时间戳（支持秒级和毫秒级）
  /// 如果时间戳大于 10^10（10000000000），说明是毫秒级，直接使用
  /// 否则是秒级，需要乘以 1000 转换为毫秒
  static DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    
    final ts = timestamp is int ? timestamp : int.tryParse(timestamp.toString());
    if (ts == null) return null;
    
    // 如果时间戳大于 10^10（10000000000），说明是毫秒级
    // 否则是秒级，需要乘以 1000
    final milliseconds = ts > 10000000000 ? ts : ts * 1000;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'language': language,
      'embedding_model': embeddingModel,
      'status': status,
      'chunk_num': chunkNum,
      'document_num': documentNum,
      'create_time': createTime?.millisecondsSinceEpoch,
      'update_time': updateTime?.millisecondsSinceEpoch,
      'permission': permission,
      'parser_id': parserId,
      'parser_config': parserConfig,
      'pagerank': pagerank,
      'tag_kb_ids': tagKbIds,
    };
  }
}
