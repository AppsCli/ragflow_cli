/// 文档解析器类型
enum DocumentParserType {
  naive('naive', '通用'),
  qa('qa', '问答'),
  resume('resume', '简历'),
  manual('manual', '手动'),
  table('table', '表格'),
  paper('paper', '论文'),
  book('book', '书籍'),
  laws('laws', '法律'),
  presentation('presentation', '演示文稿'),
  picture('picture', '图片'),
  one('one', '单页'),
  audio('audio', '音频'),
  email('email', '邮件'),
  tag('tag', '标签'),
  knowledgeGraph('knowledge_graph', '知识图谱');

  final String value;
  final String label;

  const DocumentParserType(this.value, this.label);

  static DocumentParserType? fromString(String? value) {
    if (value == null) return null;
    for (final type in DocumentParserType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return null;
  }
}

/// 权限类型
enum PermissionType {
  // 注意：UI 显示请使用 Strings（不要直接用 label）
  me('me', 'Only me'),
  team('team', 'Team');

  final String value;
  final String label;

  const PermissionType(this.value, this.label);

  static PermissionType fromString(String? value) {
    if (value == null) return PermissionType.me;
    for (final type in PermissionType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return PermissionType.me;
  }
}

/// 语言类型
enum LanguageType {
  chinese('Chinese', '中文'),
  english('English', '英文');

  final String value;
  final String label;

  const LanguageType(this.value, this.label);

  static LanguageType fromString(String? value) {
    if (value == null) return LanguageType.chinese;
    for (final type in LanguageType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return LanguageType.chinese;
  }
}