class Document {
  final String id;
  final String name;
  final String? description;
  final String? thumbnail;
  final String suffix;
  final int size;
  final String status;
  final String? run;
  final int chunkNum;
  final int tokenNum;
  final DateTime? createTime;
  final DateTime? updateTime;
  final String? sourceType;
  final String? type;
  final double? progress;
  final String? parserId;
  final Map<String, dynamic>? parserConfig;

  Document({
    required this.id,
    required this.name,
    this.description,
    this.thumbnail,
    required this.suffix,
    this.size = 0,
    required this.status,
    this.run,
    this.chunkNum = 0,
    this.tokenNum = 0,
    this.createTime,
    this.updateTime,
    this.sourceType,
    this.type,
    this.progress,
    this.parserId,
    this.parserConfig,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] ?? json['document_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      thumbnail: json['thumbnail'],
      suffix: json['suffix'] ?? '',
      size: json['size'] ?? 0,
      status: json['status'] ?? '1',
      run: json['run']?.toString(),
      chunkNum: json['chunk_num'] ?? json['chunk_count'] ?? 0,
      tokenNum: json['token_num'] ?? json['token_count'] ?? 0,
      createTime: _parseTimestamp(json['create_time']),
      updateTime: _parseTimestamp(json['update_time']),
      sourceType: json['source_type'],
      type: json['type'],
      progress: json['progress'] != null ? (json['progress'] as num).toDouble() : null,
      parserId: json['parser_id'] ?? json['chunk_method'],
      parserConfig: json['parser_config'] as Map<String, dynamic>?,
    );
  }

  /// 解析时间戳（支持秒级和毫秒级）
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
      'thumbnail': thumbnail,
      'suffix': suffix,
      'size': size,
      'status': status,
      'run': run,
      'chunk_num': chunkNum,
      'token_num': tokenNum,
      'create_time': createTime?.millisecondsSinceEpoch,
      'update_time': updateTime?.millisecondsSinceEpoch,
      'source_type': sourceType,
      'type': type,
      'progress': progress,
      'parser_id': parserId,
      'parser_config': parserConfig,
    };
  }
}
