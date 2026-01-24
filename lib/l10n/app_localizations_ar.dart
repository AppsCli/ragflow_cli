// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'RAGFlow';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get serverSettings => 'إعدادات الخادم';

  @override
  String get addServer => 'إضافة خادم';

  @override
  String get serverName => 'اسم الخادم (اختياري)';

  @override
  String get serverAddress => 'عنوان الخادم';

  @override
  String get exampleServerAddress => 'مثال: http://192.168.1.100:9380';

  @override
  String get activate => 'تفعيل';

  @override
  String get delete => 'حذف';

  @override
  String get active => 'نشط';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String deleteServerConfirm(String serverName) {
    return 'هل أنت متأكد من حذف الخادم \"$serverName\"?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'بعد التبديل إلى الخادم \"$serverName\"، ستحتاج إلى تسجيل الدخول مرة أخرى. هل تريد المتابعة؟';
  }

  @override
  String currentServer(String serverAddress) {
    return 'الخادم الحالي: $serverAddress';
  }

  @override
  String get serverAdded => 'تمت إضافة الخادم بنجاح';

  @override
  String get serverDeleted => 'تم حذف الخادم';

  @override
  String get switchFailed => 'فشل التبديل';

  @override
  String get addFailed => 'فشلت الإضافة، يرجى التحقق من تنسيق العنوان';

  @override
  String get saveFailed => 'فشل الحفظ';

  @override
  String get serverAddressRequired => 'يرجى إدخال عنوان الخادم';

  @override
  String get serverAddressFormatError =>
      'يجب أن يبدأ العنوان بـ http:// أو https://';

  @override
  String get serverList => 'قائمة الخوادم';

  @override
  String get noServerConfig => 'لا توجد إعدادات خادم';

  @override
  String get addServerHint => 'انقر على الزر أدناه لإضافة خادم';

  @override
  String get systemVersion => 'إصدار RAGFlow';

  @override
  String get systemStatus => 'حالة النظام';

  @override
  String get refresh => 'تحديث';

  @override
  String get cannotGetSystemStatus => 'لا يمكن الحصول على حالة النظام';

  @override
  String get serverAddressHint =>
      'يجب أن يكون عنوان الخادم عنوان URL كاملاً، على سبيل المثال:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com';

  @override
  String get documentEngine => 'محرك المستندات';

  @override
  String get storage => 'التخزين';

  @override
  String get database => 'قاعدة البيانات';

  @override
  String get redis => 'Redis';

  @override
  String get normal => 'طبيعي';

  @override
  String get abnormal => 'غير طبيعي';

  @override
  String get unknown => 'غير معروف';

  @override
  String responseTime(String elapsed) {
    return 'وقت الاستجابة: ${elapsed}ms';
  }

  @override
  String type(String type) {
    return 'النوع';
  }

  @override
  String storageInfo(String storage) {
    return 'التخزين: $storage';
  }

  @override
  String databaseInfo(String database) {
    return 'قاعدة البيانات: $database';
  }

  @override
  String error(String error) {
    return 'خطأ: $error';
  }

  @override
  String get language => 'اللغة';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get followSystem => 'اتباع النظام';

  @override
  String get chinese => 'الصينية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get traditionalChinese => 'الصينية التقليدية';

  @override
  String get japanese => 'اليابانية';

  @override
  String get korean => 'الكورية';

  @override
  String get german => 'الألمانية';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get french => 'الفرنسية';

  @override
  String get italian => 'الإيطالية';

  @override
  String get russian => 'الروسية';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get account => 'الحساب';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get confirmLogout => 'هل أنت متأكد من تسجيل الخروج؟';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور بنجاح';

  @override
  String get passwordChangeFailed =>
      'فشل تغيير كلمة المرور، يرجى التحقق من صحة كلمة المرور الحالية';

  @override
  String get passwordRequired => 'يرجى إدخال كلمة المرور';

  @override
  String get newPasswordRequired => 'يرجى إدخال كلمة المرور الجديدة';

  @override
  String get confirmPasswordRequired => 'يرجى تأكيد كلمة المرور الجديدة';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get emailRequired => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get invalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صحيح';

  @override
  String get loginFailed =>
      'فشل تسجيل الدخول، يرجى التحقق من البريد الإلكتروني وكلمة المرور';

  @override
  String get configureServerAddress => 'تكوين عنوان الخادم';

  @override
  String get pleaseConfigureServer =>
      'يرجى تكوين عنوان الخادم قبل تسجيل الدخول';

  @override
  String get goToSettings => 'انتقل إلى الإعدادات';

  @override
  String get setServerAddress => 'تعيين عنوان الخادم';

  @override
  String get knowledgeBase => 'قاعدة المعرفة';

  @override
  String get chat => 'الدردشة';

  @override
  String get search => 'البحث';

  @override
  String get agent => 'الوكيل';

  @override
  String get file => 'الملف';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get create => 'إنشاء';

  @override
  String get edit => 'تعديل';

  @override
  String get name => 'الاسم';

  @override
  String get description => 'الوصف';

  @override
  String get status => 'الحالة';

  @override
  String get actions => 'الإجراءات';

  @override
  String get details => 'التفاصيل';

  @override
  String get back => 'رجوع';

  @override
  String get submit => 'إرسال';

  @override
  String get close => 'إغلاق';

  @override
  String get searchPlaceholder => 'بحث...';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get upload => 'رفع';

  @override
  String get download => 'تنزيل';

  @override
  String get view => 'عرض';

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get updatedAt => 'تاريخ التحديث';

  @override
  String get size => 'الحجم';

  @override
  String get operation => 'العملية';

  @override
  String get success => 'نجح';

  @override
  String get failed => 'فشل';

  @override
  String get pleaseWait => 'يرجى الانتظار...';

  @override
  String get areYouSure => 'هل أنت متأكد؟';

  @override
  String get deleteConfirm => 'هل أنت متأكد من حذف هذا العنصر؟';

  @override
  String get operationSuccess => 'تمت العملية بنجاح';

  @override
  String get operationFailed => 'فشلت العملية';

  @override
  String get networkError => 'خطأ في الشبكة، يرجى التحقق من الاتصال';

  @override
  String get unknownError => 'حدث خطأ غير معروف';

  @override
  String get createKnowledgeBase => 'إنشاء قاعدة معرفة';

  @override
  String get knowledgeBaseName => 'اسم قاعدة المعرفة';

  @override
  String get enterKnowledgeBaseName => 'يرجى إدخال اسم قاعدة المعرفة';

  @override
  String get loadingFailed => 'فشل التحميل';

  @override
  String get creating => 'جاري الإنشاء...';

  @override
  String get createSuccess => 'تم الإنشاء بنجاح';

  @override
  String get createFailed => 'فشل الإنشاء، يرجى المحاولة مرة أخرى';

  @override
  String get noKnowledgeBase => 'لا توجد قاعدة معرفة';

  @override
  String get documents => 'المستندات';

  @override
  String get chunks => 'الأجزاء';

  @override
  String get updated => 'محدث';

  @override
  String get send => 'إرسال';

  @override
  String get enterMessage => 'أدخل الرسالة...';

  @override
  String get noChatHistory => 'لا يوجد سجل محادثة';

  @override
  String get newChat => 'محادثة جديدة';

  @override
  String get clear => 'مسح';

  @override
  String get noAgents => 'لا يوجد وكلاء';

  @override
  String get createAgent => 'إنشاء وكيل';

  @override
  String get noFiles => 'لا توجد ملفات';

  @override
  String get uploadFile => 'رفع ملف';

  @override
  String get fileName => 'اسم الملف';

  @override
  String get fileSize => 'حجم الملف';

  @override
  String get uploadTime => 'وقت الرفع';

  @override
  String get resetAgent => 'إعادة تعيين الوكيل';

  @override
  String get resetAgentConfirm =>
      'هل أنت متأكد من إعادة تعيين الوكيل؟ سيتم مسح سجل المحادثة الحالي.';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get resetSuccess => 'تمت إعادة التعيين بنجاح';

  @override
  String get resetFailed => 'فشلت إعادة التعيين';

  @override
  String get thinking => 'جاري التفكير...';

  @override
  String get you => 'أنت';

  @override
  String sendFailed(String message) {
    return 'فشل الإرسال: $message';
  }

  @override
  String get requestFailed => 'فشل الطلب';

  @override
  String get stop => 'إيقاف';

  @override
  String get createNewConversation => 'إنشاء محادثة جديدة';

  @override
  String get conversationName => 'اسم المحادثة';

  @override
  String get noConversations => 'لا توجد محادثات';

  @override
  String get hideList => 'إخفاء القائمة';

  @override
  String get showList => 'إظهار القائمة';

  @override
  String get refreshConversationList => 'تحديث قائمة المحادثات';

  @override
  String get selectConversation => 'يرجى اختيار محادثة';

  @override
  String loadConversationListFailed(String error) {
    return 'فشل تحميل قائمة المحادثات: $error';
  }

  @override
  String get getConversationInfoFailed => 'فشل الحصول على معلومات المحادثة';

  @override
  String get knowledgeBaseDetail => 'تفاصيل قاعدة المعرفة';

  @override
  String get dataset => 'مجموعة البيانات';

  @override
  String get retrievalTest => 'اختبار الاسترجاع';

  @override
  String get config => 'الإعدادات';

  @override
  String get searchDocuments => 'البحث في المستندات...';

  @override
  String get noDocuments => 'لا توجد مستندات';

  @override
  String get tokens => 'الرموز';

  @override
  String get update => 'تحديث';

  @override
  String get detail => 'التفاصيل';

  @override
  String get parse => 'تحليل';

  @override
  String get cancelParse => 'إلغاء التحليل';

  @override
  String get deleteDocument => 'حذف المستند';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get confirmDeleteDocument => 'هل أنت متأكد من حذف هذا المستند؟';

  @override
  String get deleteSuccess => 'تم الحذف بنجاح';

  @override
  String get deleteFailed => 'فشل الحذف';

  @override
  String totalDocuments(int count) {
    return 'إجمالي $count مستند';
  }

  @override
  String get previousPage => 'الصفحة السابقة';

  @override
  String get nextPage => 'الصفحة التالية';

  @override
  String get id => 'المعرف';

  @override
  String get suffix => 'اللاحقة';

  @override
  String get chunkCount => 'عدد الأجزاء';

  @override
  String get tokenCount => 'عدد الرموز';

  @override
  String get createTime => 'وقت الإنشاء';

  @override
  String get updateTime => 'وقت التحديث';

  @override
  String get notStarted => 'لم يبدأ';

  @override
  String get parsing => 'جاري التحليل';

  @override
  String get cancelled => 'ملغى';

  @override
  String get completed => 'مكتمل';

  @override
  String get downloading => 'جاري التنزيل...';

  @override
  String downloadSuccess(String path) {
    return 'تم التنزيل بنجاح: $path';
  }

  @override
  String get downloadFailed => 'فشل التنزيل';

  @override
  String get startingParse => 'جاري بدء التحليل...';

  @override
  String get parseStarted => 'تم بدء التحليل';

  @override
  String get startParseFailed => 'فشل بدء التحليل';

  @override
  String get confirmCancel => 'تأكيد الإلغاء';

  @override
  String confirmCancelParse(String name) {
    return 'هل أنت متأكد من إلغاء تحليل المستند \"$name\"?';
  }

  @override
  String get cancellingParse => 'جاري إلغاء التحليل...';

  @override
  String get parseCancelled => 'تم إلغاء التحليل';

  @override
  String get cancelParseFailed => 'فشل إلغاء التحليل';

  @override
  String get uploading => 'جاري الرفع...';

  @override
  String get uploadSuccess => 'تم الرفع بنجاح، جاري بدء التحليل...';

  @override
  String get uploadFailed => 'فشل الرفع';

  @override
  String get partialUploadFailed => 'فشل رفع بعض الملفات';

  @override
  String loadDocumentsFailed(String error) {
    return 'فشل تحميل المستندات: $error';
  }

  @override
  String get enterQuestionForRetrieval => 'أدخل سؤالاً لاختبار الاسترجاع...';

  @override
  String get test => 'اختبار';

  @override
  String get retrieving => 'جاري الاسترجاع...';

  @override
  String get enterQuestionForRetrievalTest =>
      'يرجى إدخال سؤال لاختبار الاسترجاع';

  @override
  String retrievalResults(int count) {
    return 'نتائج الاسترجاع (إجمالي $count)';
  }

  @override
  String similarity(String percent) {
    return 'التشابه: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return 'فشل اختبار الاسترجاع: $error';
  }

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get knowledgeBaseNameRequired => 'يرجى إدخال اسم قاعدة المعرفة';

  @override
  String get knowledgeBaseImage => 'صورة قاعدة المعرفة';

  @override
  String get uploadImage => 'رفع صورة';

  @override
  String get imageSelected => 'تم اختيار الصورة';

  @override
  String get fileNotExists => 'الملف غير موجود';

  @override
  String get selectImageSource => 'اختر مصدر الصورة';

  @override
  String get selectFromGallery => 'اختر من المعرض';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get imageTooLarge => 'حجم الصورة لا يمكن أن يتجاوز 4 ميجابايت';

  @override
  String selectImageFailed(String error) {
    return 'فشل اختيار الصورة: $error';
  }

  @override
  String get permission => 'الصلاحية';

  @override
  String get permissionOnlyMe => 'أنا فقط';

  @override
  String get permissionTeam => 'الفريق';

  @override
  String get documentLanguage => 'لغة المستند';

  @override
  String get languageChinese => 'الصينية';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get parserNaive => 'عام';

  @override
  String get parserQa => 'سؤال وجواب';

  @override
  String get parserResume => 'السيرة الذاتية';

  @override
  String get parserManual => 'يدوي';

  @override
  String get parserTable => 'جدول';

  @override
  String get parserPaper => 'ورقة';

  @override
  String get parserBook => 'كتاب';

  @override
  String get parserLaws => 'القوانين';

  @override
  String get parserPresentation => 'عرض تقديمي';

  @override
  String get parserPicture => 'صورة';

  @override
  String get parserOne => 'صفحة واحدة';

  @override
  String get parserAudio => 'صوتي';

  @override
  String get parserEmail => 'بريد إلكتروني';

  @override
  String get parserTag => 'علامة';

  @override
  String get parserKnowledgeGraph => 'رسم بياني للمعرفة';

  @override
  String get parseConfig => 'إعدادات التحليل';

  @override
  String get sliceMethod => 'طريقة التقطيع (المحلل)';

  @override
  String get sliceMethodHelper => 'اختر طريقة تحليل وتقطيع المستند';

  @override
  String get embeddingModel => 'نموذج التضمين';

  @override
  String get embeddingModelHelper => 'اختر نموذجاً لإنشاء متجهات التضمين';

  @override
  String get embeddingModelWarning =>
      'ملاحظة: تغيير نموذج التضمين عند وجود أجزاء يتطلب حذف جميع الأجزاء';

  @override
  String get noModelsAvailable => 'لا توجد نماذج متاحة';

  @override
  String get suggestedChunkSize => 'حجم الجزء المقترح (عدد الرموز)';

  @override
  String get chunkSizeHelper => 'تعيين عتبة الرموز لإنشاء الأجزاء';

  @override
  String get textDelimiter => 'محدد النص';

  @override
  String get delimiterHelper => 'محدد لتقسيم النص، على سبيل المثال \\n';

  @override
  String get layoutRecognition => 'التعرف على التخطيط';

  @override
  String get layoutRecognitionHelper => 'اختر طريقة التعرف على التخطيط';

  @override
  String get plainText => 'نص عادي';

  @override
  String get pageRank => 'ترتيب الصفحة';

  @override
  String get pageRankHelper => 'قيمة ترتيب الصفحة لترتيب نتائج البحث';

  @override
  String get advancedOptions => 'خيارات متقدمة';

  @override
  String get autoKeywordsCount => 'عدد الكلمات المفتاحية المستخرجة تلقائياً';

  @override
  String get autoKeywordsHelper => '0 يعني عدم الاستخراج';

  @override
  String get autoQuestionsCount => 'عدد الأسئلة المستخرجة تلقائياً';

  @override
  String get autoQuestionsHelper => '0 يعني عدم الاستخراج';

  @override
  String get tableToHtml => 'جدول إلى HTML';

  @override
  String get tableToHtmlSubtitle => 'تحويل جداول Excel إلى تنسيق HTML';

  @override
  String get useRaptor => 'استخدام استراتيجية RAPTOR لتحسين الاسترجاع';

  @override
  String get useRaptorSubtitle =>
      'تفعيل استراتيجية RAPTOR لتحسين تأثير الاسترجاع';

  @override
  String get extractKnowledgeGraph => 'استخراج رسم بياني للمعرفة';

  @override
  String get extractKnowledgeGraphSubtitle => 'تفعيل استخراج رسم بياني للمعرفة';

  @override
  String get saveConfig => 'حفظ الإعدادات';

  @override
  String get saveSuccess => 'تم الحفظ بنجاح';

  @override
  String get fileManagement => 'إدارة الملفات';

  @override
  String get rootDirectory => 'الدليل الجذري';

  @override
  String get currentFolder => 'المجلد الحالي';

  @override
  String get searchFiles => 'البحث في الملفات...';

  @override
  String get folder => 'مجلد';

  @override
  String get preview => 'معاينة';

  @override
  String cannotOpenPreview(String url) {
    return 'لا يمكن فتح المعاينة: $url';
  }

  @override
  String previewFailed(String error) {
    return 'فشلت المعاينة: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return 'هل أنت متأكد من حذف \"$name\"?';
  }

  @override
  String totalFiles(int count) {
    return 'إجمالي $count ملف';
  }

  @override
  String get unnamed => 'بدون اسم';

  @override
  String loadFailed(String error) {
    return 'فشل التحميل: $error';
  }

  @override
  String totalAgents(int count) {
    return 'إجمالي $count وكيل';
  }

  @override
  String get searchAgents => 'البحث في الوكلاء...';

  @override
  String get noDescription => 'لا يوجد وصف';

  @override
  String get createNewDialog => 'إنشاء حوار جديد';

  @override
  String get dialogName => 'اسم الحوار';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get noDialogs => 'لا توجد حوارات';

  @override
  String get selectKnowledgeBase => 'اختر قاعدة المعرفة:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase =>
      'يرجى اختيار قاعدة معرفة واحدة على الأقل';

  @override
  String get enterQuestion => 'أدخل سؤالاً...';

  @override
  String get ask => 'اسأل';

  @override
  String get answer => 'الإجابة:';

  @override
  String get relatedFiles => 'الملفات ذات الصلة:';

  @override
  String get relatedQuestions => 'الأسئلة ذات الصلة:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'يرجى اختيار قاعدة المعرفة وإدخال سؤال للبحث';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'فشل تحميل قاعدة المعرفة: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return 'فشل طرح السؤال: $error';
  }

  @override
  String get exampleProduction => 'مثال: الإنتاج';
}
