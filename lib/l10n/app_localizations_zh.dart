// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'RAGFlow';

  @override
  String get login => '登录';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get serverSettings => '服务器设置';

  @override
  String get addServer => '添加服务器';

  @override
  String get serverName => '服务器名称（可选）';

  @override
  String get serverAddress => '服务器地址';

  @override
  String get exampleServerAddress => '例如: http://192.168.1.100:9380';

  @override
  String get activate => '激活';

  @override
  String get delete => '删除';

  @override
  String get active => '已激活';

  @override
  String get confirm => '确定';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String deleteServerConfirm(String serverName) {
    return '确定要删除服务器 \"$serverName\" 吗？';
  }

  @override
  String switchServerConfirm(String serverName) {
    return '切换到服务器 \"$serverName\" 后需要重新登录，确定要继续吗？';
  }

  @override
  String currentServer(String serverAddress) {
    return '当前服务器: $serverAddress';
  }

  @override
  String get serverAdded => '服务器添加成功';

  @override
  String get serverDeleted => '服务器已删除';

  @override
  String get switchFailed => '切换失败';

  @override
  String get addFailed => '添加失败，请检查地址格式';

  @override
  String get saveFailed => '保存失败';

  @override
  String get serverAddressRequired => '请输入服务器地址';

  @override
  String get serverAddressFormatError => '地址必须以 http:// 或 https:// 开头';

  @override
  String get serverList => '服务器列表';

  @override
  String get noServerConfig => '暂无服务器配置';

  @override
  String get addServerHint => '点击下方按钮添加服务器';

  @override
  String get systemVersion => 'RAGFlow 版本';

  @override
  String get systemStatus => '系统状态';

  @override
  String get refresh => '刷新';

  @override
  String get cannotGetSystemStatus => '无法获取系统状态';

  @override
  String get serverAddressHint =>
      '提示: 服务器地址应该是完整的URL，例如:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com';

  @override
  String get documentEngine => '文档引擎';

  @override
  String get storage => '存储';

  @override
  String get database => '数据库';

  @override
  String get redis => 'Redis';

  @override
  String get normal => '正常';

  @override
  String get abnormal => '异常';

  @override
  String get unknown => '未知';

  @override
  String responseTime(String elapsed) {
    return '响应时间: ${elapsed}ms';
  }

  @override
  String type(String type) {
    return '类型';
  }

  @override
  String storageInfo(String storage) {
    return '存储: $storage';
  }

  @override
  String databaseInfo(String database) {
    return '数据库: $database';
  }

  @override
  String error(String error) {
    return '错误';
  }

  @override
  String get language => '语言';

  @override
  String get languageSettings => '语言设置';

  @override
  String get followSystem => '跟随系统';

  @override
  String get chinese => '中文';

  @override
  String get english => '英文';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get account => '账号';

  @override
  String get changePassword => '修改密码';

  @override
  String get logout => '退出登录';

  @override
  String get confirmLogout => '确定要退出登录吗？';

  @override
  String get currentPassword => '当前密码';

  @override
  String get newPassword => '新密码';

  @override
  String get confirmNewPassword => '确认新密码';

  @override
  String get passwordChanged => '密码修改成功';

  @override
  String get passwordChangeFailed => '密码修改失败，请检查当前密码是否正确';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get newPasswordRequired => '请输入新密码';

  @override
  String get confirmPasswordRequired => '请确认新密码';

  @override
  String get passwordTooShort => '密码长度至少为8位';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get emailRequired => '请输入邮箱';

  @override
  String get invalidEmail => '请输入有效的邮箱地址';

  @override
  String get loginFailed => '登录失败，请检查邮箱和密码';

  @override
  String get configureServerAddress => '配置服务器地址';

  @override
  String get pleaseConfigureServer => '请先配置服务器地址才能登录';

  @override
  String get goToSettings => '去设置';

  @override
  String get setServerAddress => '设置服务器地址';

  @override
  String get knowledgeBase => '知识库';

  @override
  String get chat => '聊天';

  @override
  String get search => '搜索';

  @override
  String get agent => 'Agent';

  @override
  String get file => '文件';

  @override
  String get noData => '暂无数据';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get create => '创建';

  @override
  String get edit => '编辑';

  @override
  String get name => '名称';

  @override
  String get description => '描述';

  @override
  String get status => '状态';

  @override
  String get actions => '操作';

  @override
  String get details => '详情';

  @override
  String get back => '返回';

  @override
  String get submit => '提交';

  @override
  String get close => '关闭';

  @override
  String get searchPlaceholder => '搜索...';

  @override
  String get noResults => '未找到结果';

  @override
  String get upload => '上传';

  @override
  String get download => '下载';

  @override
  String get view => '查看';

  @override
  String get createdAt => '创建时间';

  @override
  String get updatedAt => '更新时间';

  @override
  String get size => '大小';

  @override
  String get operation => '操作';

  @override
  String get success => '成功';

  @override
  String get failed => '失败';

  @override
  String get pleaseWait => '请稍候...';

  @override
  String get areYouSure => '确定吗？';

  @override
  String get deleteConfirm => '确定要删除此项吗？';

  @override
  String get operationSuccess => '操作成功';

  @override
  String get operationFailed => '操作失败';

  @override
  String get networkError => '网络错误，请检查您的连接';

  @override
  String get unknownError => '发生未知错误';

  @override
  String get createKnowledgeBase => '创建知识库';

  @override
  String get knowledgeBaseName => '知识库名称';

  @override
  String get enterKnowledgeBaseName => '请输入知识库名称';

  @override
  String get loadingFailed => '加载失败';

  @override
  String get creating => '正在创建...';

  @override
  String get createSuccess => '创建成功';

  @override
  String get createFailed => '创建失败';

  @override
  String get noKnowledgeBase => '暂无知识库';

  @override
  String get documents => '文档';

  @override
  String get chunks => '片段';

  @override
  String get updated => '更新';

  @override
  String get send => '发送';

  @override
  String get enterMessage => '输入消息...';

  @override
  String get noChatHistory => '暂无聊天记录';

  @override
  String get newChat => '新建聊天';

  @override
  String get clear => '清除';

  @override
  String get noAgents => '暂无Agent';

  @override
  String get createAgent => '创建Agent';

  @override
  String get noFiles => '暂无文件';

  @override
  String get uploadFile => '上传文件';

  @override
  String get fileName => '文件名';

  @override
  String get fileSize => '文件大小';

  @override
  String get uploadTime => '上传时间';

  @override
  String get resetAgent => '重置 Agent';

  @override
  String get resetAgentConfirm => '确定要重置 Agent 吗？这将清除当前对话历史。';

  @override
  String get reset => '重置';

  @override
  String get resetSuccess => '重置成功';

  @override
  String get resetFailed => '重置失败';

  @override
  String get thinking => '思考中...';

  @override
  String get you => '你';

  @override
  String sendFailed(String message) {
    return '发送失败: $message';
  }

  @override
  String get requestFailed => '请求失败';

  @override
  String get stop => '终止';

  @override
  String get createNewConversation => '创建新对话';

  @override
  String get conversationName => '对话名称';

  @override
  String get noConversations => '暂无对话';

  @override
  String get hideList => '隐藏列表';

  @override
  String get showList => '显示列表';

  @override
  String get refreshConversationList => '刷新对话列表';

  @override
  String get selectConversation => '请选择一个对话';

  @override
  String loadConversationListFailed(String error) {
    return '加载对话列表失败: $error';
  }

  @override
  String get getConversationInfoFailed => '获取对话信息失败';

  @override
  String get knowledgeBaseDetail => '知识库详情';

  @override
  String get dataset => '数据集';

  @override
  String get retrievalTest => '检索测试';

  @override
  String get config => '配置';

  @override
  String get searchDocuments => '搜索文档...';

  @override
  String get noDocuments => '暂无文档';

  @override
  String get tokens => 'Token';

  @override
  String get update => '更新';

  @override
  String get detail => '详情';

  @override
  String get parse => '解析';

  @override
  String get cancelParse => '取消解析';

  @override
  String get deleteDocument => '删除';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get confirmDeleteDocument => '确定要删除这个文档吗？';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get deleteFailed => '删除失败';

  @override
  String totalDocuments(int count) {
    return '共 $count 个文档';
  }

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get id => 'ID';

  @override
  String get suffix => '后缀';

  @override
  String get chunkCount => '片段数';

  @override
  String get tokenCount => 'Token数';

  @override
  String get createTime => '创建时间';

  @override
  String get updateTime => '更新时间';

  @override
  String get notStarted => '未开始';

  @override
  String get parsing => '解析中';

  @override
  String get cancelled => '已取消';

  @override
  String get completed => '已完成';

  @override
  String get downloading => '正在下载...';

  @override
  String downloadSuccess(String path) {
    return '下载成功: $path';
  }

  @override
  String get downloadFailed => '下载失败';

  @override
  String get startingParse => '正在启动解析...';

  @override
  String get parseStarted => '解析已启动';

  @override
  String get startParseFailed => '启动解析失败';

  @override
  String get confirmCancel => '确认取消';

  @override
  String confirmCancelParse(String name) {
    return '确定要取消解析文档 \"$name\" 吗？';
  }

  @override
  String get cancellingParse => '正在取消解析...';

  @override
  String get parseCancelled => '已取消解析';

  @override
  String get cancelParseFailed => '取消解析失败';

  @override
  String get uploading => '正在上传...';

  @override
  String get uploadSuccess => '上传成功，正在启动解析...';

  @override
  String get uploadFailed => '上传失败';

  @override
  String get partialUploadFailed => '部分文件上传失败';

  @override
  String loadDocumentsFailed(String error) {
    return '加载文档失败: $error';
  }

  @override
  String get enterQuestionForRetrieval => '输入问题进行检索测试...';

  @override
  String get test => '测试';

  @override
  String get retrieving => '检索中...';

  @override
  String get enterQuestionForRetrievalTest => '请输入问题进行检索测试';

  @override
  String retrievalResults(int count) {
    return '检索结果 (共 $count 条)';
  }

  @override
  String similarity(String percent) {
    return '相似度: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return '检索测试失败: $error';
  }

  @override
  String get basicInfo => '基本信息';

  @override
  String get knowledgeBaseNameRequired => '请输入知识库名称';

  @override
  String get knowledgeBaseImage => '知识库图片';

  @override
  String get uploadImage => '上传图片';

  @override
  String get imageSelected => '图片已选择';

  @override
  String get fileNotExists => '文件不存在';

  @override
  String get selectImageSource => '选择图片来源';

  @override
  String get selectFromGallery => '从相册选择';

  @override
  String get takePhoto => '拍照';

  @override
  String get imageTooLarge => '图片大小不能超过 4MB';

  @override
  String selectImageFailed(String error) {
    return '选择图片失败: $error';
  }

  @override
  String get permission => '权限';

  @override
  String get documentLanguage => '文档语言';

  @override
  String get parseConfig => '解析配置';

  @override
  String get sliceMethod => '切片方法（解析器）';

  @override
  String get sliceMethodHelper => '选择文档解析和切片的方法';

  @override
  String get embeddingModel => '嵌入模型';

  @override
  String get embeddingModelHelper => '选择用于生成嵌入向量的模型';

  @override
  String get embeddingModelWarning => '注意：已有分块时更改嵌入模型需要删除所有分块';

  @override
  String get noModelsAvailable => '暂无可用模型';

  @override
  String get suggestedChunkSize => '建议文本块大小（Token数）';

  @override
  String get chunkSizeHelper => '设置创建分块的Token阈值';

  @override
  String get textDelimiter => '文本分段标识符';

  @override
  String get delimiterHelper => '用于分割文本的标识符，如 \\n';

  @override
  String get layoutRecognition => '布局识别';

  @override
  String get layoutRecognitionHelper => '选择布局识别方式';

  @override
  String get plainText => '纯文本';

  @override
  String get pageRank => '页面排名';

  @override
  String get pageRankHelper => '页面排名值，用于搜索结果排序';

  @override
  String get advancedOptions => '高级选项';

  @override
  String get autoKeywordsCount => '自动关键词提取数量';

  @override
  String get autoKeywordsHelper => '0表示不提取';

  @override
  String get autoQuestionsCount => '自动问题提取数量';

  @override
  String get autoQuestionsHelper => '0表示不提取';

  @override
  String get tableToHtml => '表格转HTML';

  @override
  String get tableToHtmlSubtitle => '将Excel表格转换为HTML格式';

  @override
  String get useRaptor => '使用召回增强 RAPTOR 策略';

  @override
  String get useRaptorSubtitle => '启用RAPTOR策略以增强召回效果';

  @override
  String get extractKnowledgeGraph => '提取知识图谱';

  @override
  String get extractKnowledgeGraphSubtitle => '启用知识图谱提取功能';

  @override
  String get saveConfig => '保存配置';

  @override
  String get saveSuccess => '保存成功';

  @override
  String get fileManagement => '文件管理';

  @override
  String get rootDirectory => '根目录';

  @override
  String get currentFolder => '当前文件夹';

  @override
  String get searchFiles => '搜索文件...';

  @override
  String get folder => '文件夹';

  @override
  String get preview => '预览';

  @override
  String cannotOpenPreview(String url) {
    return '无法打开预览: $url';
  }

  @override
  String previewFailed(String error) {
    return '预览失败: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return '确定要删除 \"$name\" 吗？';
  }

  @override
  String totalFiles(int count) {
    return '共 $count 个文件';
  }

  @override
  String get unnamed => '未命名';

  @override
  String loadFailed(String error) {
    return '加载失败: $error';
  }

  @override
  String totalAgents(int count) {
    return '共 $count 个Agent';
  }

  @override
  String get searchAgents => '搜索Agent...';

  @override
  String get noDescription => '暂无描述';

  @override
  String get createNewDialog => '创建新对话';

  @override
  String get dialogName => '对话名称';

  @override
  String get descriptionOptional => '描述（可选）';

  @override
  String get noDialogs => '暂无对话';

  @override
  String get selectKnowledgeBase => '选择知识库:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase => '请至少选择一个知识库';

  @override
  String get enterQuestion => '输入问题...';

  @override
  String get ask => '提问';

  @override
  String get answer => '答案:';

  @override
  String get relatedFiles => '相关文件:';

  @override
  String get relatedQuestions => '相关问题:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion => '请选择知识库并输入问题进行搜索';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return '加载知识库失败: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return '提问失败: $error';
  }

  @override
  String get exampleProduction => '例如: 生产环境';
}
