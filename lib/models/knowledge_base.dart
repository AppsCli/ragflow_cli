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
  });

  factory KnowledgeBase.fromJson(Map<String, dynamic> json) {
    return KnowledgeBase(
      id: json['id'] ?? json['kb_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      avatar: json['avatar'] ?? json['icon'],
      language: json['language'] ?? 'Chinese',
      embeddingModel: json['embedding_model'] ?? '',
      status: json['status'],
      chunkNum: json['chunk_num'] ?? 0,
      documentNum: json['document_num'] ?? 0,
      createTime: json['create_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['create_time'] * 1000)
          : null,
      updateTime: json['update_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['update_time'] * 1000)
          : null,
    );
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
    };
  }
}
