class Dialog {
  final String id;
  final String dialogId;
  final String name;
  final String? description;
  final String? icon;
  final List<String> kbIds;
  final List<String> kbNames;
  final String llmId;
  final DateTime? createTime;
  final DateTime? updateTime;

  Dialog({
    required this.id,
    required this.dialogId,
    required this.name,
    this.description,
    this.icon,
    this.kbIds = const [],
    this.kbNames = const [],
    this.llmId = '',
    this.createTime,
    this.updateTime,
  });

  factory Dialog.fromJson(Map<String, dynamic> json) {
    return Dialog(
      id: json['id'] ?? '',
      dialogId: json['dialog_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      icon: json['icon'],
      kbIds: (json['kb_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      kbNames: (json['kb_names'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      llmId: json['llm_id'] ?? '',
      createTime: json['create_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['create_time'] * 1000)
          : null,
      updateTime: json['update_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['update_time'] * 1000)
          : null,
    );
  }
}

class Conversation {
  final String id;
  final String dialogId;
  final String name;
  final String? avatar;
  final List<Message> messages;
  final DateTime? createTime;
  final DateTime? updateTime;
  final bool isNew;

  Conversation({
    required this.id,
    required this.dialogId,
    required this.name,
    this.avatar,
    this.messages = const [],
    this.createTime,
    this.updateTime,
    this.isNew = false,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      dialogId: json['dialog_id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      messages: (json['message'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e))
              .toList() ??
          [],
      createTime: _parseTimestamp(json['create_time']),
      updateTime: _parseTimestamp(json['update_time']),
      isNew: json['is_new'] ?? false,
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
}

class Message {
  final String content;
  final MessageRole role;

  Message({
    required this.content,
    required this.role,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] ?? '',
      role: MessageRole.fromString(json['role'] ?? 'user'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role.toString(),
    };
  }
}

enum MessageRole {
  user,
  assistant,
  system;

  static MessageRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'user':
        return MessageRole.user;
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.user;
    }
  }

  @override
  String toString() {
    switch (this) {
      case MessageRole.user:
        return 'user';
      case MessageRole.assistant:
        return 'assistant';
      case MessageRole.system:
        return 'system';
    }
  }
}
