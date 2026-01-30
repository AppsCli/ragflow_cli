// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'RAGFlowCli';

  @override
  String get login => 'Войти';

  @override
  String get email => 'Эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get serverSettings => 'Настройки сервера';

  @override
  String get addServer => 'Добавить сервер';

  @override
  String get serverName => 'Имя сервера (необяз.)';

  @override
  String get serverAddress => 'Адрес сервера';

  @override
  String get exampleServerAddress => 'напр. http://192.168.1.100:9380';

  @override
  String get activate => 'Активировать';

  @override
  String get delete => 'Удалить';

  @override
  String get active => 'Активен';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String deleteServerConfirm(String serverName) {
    return 'Удалить сервер \"$serverName\"?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'После переключения на \"$serverName\" потребуется повторный вход. Продолжить?';
  }

  @override
  String currentServer(String serverAddress) {
    return 'Текущий сервер: $serverAddress';
  }

  @override
  String get serverAdded => 'Сервер добавлен';

  @override
  String get serverDeleted => 'Сервер удалён';

  @override
  String get switchFailed => 'Ошибка переключения';

  @override
  String get addFailed => 'Ошибка добавления. Проверьте формат адреса';

  @override
  String get saveFailed => 'Ошибка сохранения';

  @override
  String get serverAddressRequired => 'Введите адрес сервера';

  @override
  String get serverAddressFormatError =>
      'Адрес должен начинаться с http:// или https://';

  @override
  String get serverList => 'Список серверов';

  @override
  String get noServerConfig => 'Нет конфигурации сервера';

  @override
  String get addServerHint => 'Нажмите кнопку ниже, чтобы добавить сервер';

  @override
  String get systemVersion => 'Версия RAGFlow';

  @override
  String get systemStatus => 'Состояние системы';

  @override
  String get refresh => 'Обновить';

  @override
  String get cannotGetSystemStatus => 'Не удалось получить состояние системы';

  @override
  String get serverAddressHint =>
      'La dirección debe ser una URL completa. Ej.:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com';

  @override
  String get documentEngine => 'Motor de documentos';

  @override
  String get storage => 'Almacenamiento';

  @override
  String get database => 'Base de datos';

  @override
  String get redis => 'Redis';

  @override
  String get normal => 'Normal';

  @override
  String get abnormal => 'Anormal';

  @override
  String get unknown => 'Desconocido';

  @override
  String responseTime(String elapsed) {
    return 'Tiempo de respuesta: ${elapsed}ms';
  }

  @override
  String type(String type) {
    return 'Tipo';
  }

  @override
  String storageInfo(String storage) {
    return 'Almacenamiento: $storage';
  }

  @override
  String databaseInfo(String database) {
    return 'Base de datos: $database';
  }

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get language => 'Язык';

  @override
  String get languageSettings => 'Настройки языка';

  @override
  String get followSystem => 'Как в системе';

  @override
  String get theme => 'Тема';

  @override
  String get themeSettings => 'Настройки темы';

  @override
  String get colorSchemeBlue => 'Синий';

  @override
  String get colorSchemeGreen => 'Зелёный';

  @override
  String get colorSchemePurple => 'Фиолетовый';

  @override
  String get colorSchemeOrange => 'Оранжевый';

  @override
  String get colorSchemeRed => 'Красный';

  @override
  String get colorSchemeTeal => 'Бирюзовый';

  @override
  String get colorSchemePink => 'Розовый';

  @override
  String get colorSchemeIndigo => 'Индиго';

  @override
  String get colorSchemeBrown => 'Коричневый';

  @override
  String get colorSchemeCyan => 'Голубой';

  @override
  String get chinese => 'Китайский';

  @override
  String get english => 'Английский';

  @override
  String get traditionalChinese => 'Китайский (трад.)';

  @override
  String get japanese => 'Японский';

  @override
  String get korean => 'Корейский';

  @override
  String get german => 'Немецкий';

  @override
  String get spanish => 'Испанский';

  @override
  String get french => 'Французский';

  @override
  String get italian => 'Итальянский';

  @override
  String get russian => 'Русский';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get account => 'Аккаунт';

  @override
  String get changePassword => 'Сменить пароль';

  @override
  String get logout => 'Выйти';

  @override
  String get confirmLogout => 'Выйти?';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердите новый пароль';

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get passwordChangeFailed =>
      'Ошибка смены пароля. Проверьте текущий пароль';

  @override
  String get passwordRequired => 'Введите пароль';

  @override
  String get newPasswordRequired => 'Введите новый пароль';

  @override
  String get confirmPasswordRequired => 'Подтвердите новый пароль';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 8 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get emailRequired => 'Введите адрес электронной почты';

  @override
  String get invalidEmail => 'Введите правильный адрес электронной почты';

  @override
  String get loginFailed => 'Ошибка входа. Проверьте почту и пароль';

  @override
  String get configureServerAddress => 'Configurar dirección del servidor';

  @override
  String get pleaseConfigureServer =>
      'Configure la dirección del servidor antes de iniciar sesión';

  @override
  String get goToSettings => 'Ir a ajustes';

  @override
  String get setServerAddress => 'Establecer dirección del servidor';

  @override
  String get knowledgeBase => 'База знаний';

  @override
  String get chat => 'Чат';

  @override
  String get search => 'Поиск';

  @override
  String get agent => 'Agente';

  @override
  String get file => 'Archivo';

  @override
  String get noData => 'Sin datos';

  @override
  String get loading => 'Загрузка…';

  @override
  String get retry => 'Reintentar';

  @override
  String get create => 'Создать';

  @override
  String get edit => 'Изменить';

  @override
  String get name => 'Nombre';

  @override
  String get description => 'Descripción';

  @override
  String get status => 'Estado';

  @override
  String get actions => 'Acciones';

  @override
  String get details => 'Detalles';

  @override
  String get back => 'Назад';

  @override
  String get submit => 'Отправить';

  @override
  String get close => 'Закрыть';

  @override
  String get searchPlaceholder => 'Поиск…';

  @override
  String get noResults => 'Ничего не найдено';

  @override
  String get upload => 'Subir';

  @override
  String get download => 'Descargar';

  @override
  String get view => 'Просмотр';

  @override
  String get createdAt => 'Дата создания';

  @override
  String get updatedAt => 'Дата обновления';

  @override
  String get size => 'Размер';

  @override
  String get operation => 'Действие';

  @override
  String get success => 'Успех';

  @override
  String get failed => 'Сбой';

  @override
  String get pleaseWait => 'Подождите…';

  @override
  String get areYouSure => 'Вы уверены?';

  @override
  String get deleteConfirm => 'Удалить этот элемент?';

  @override
  String get operationSuccess => 'Операция выполнена';

  @override
  String get operationFailed => 'Ошибка операции';

  @override
  String get networkError => 'Сетевая ошибка. Проверьте подключение';

  @override
  String get unknownError => 'Произошла неизвестная ошибка';

  @override
  String get createKnowledgeBase => 'Создать базу знаний';

  @override
  String get knowledgeBaseName => 'Название базы знаний';

  @override
  String get enterKnowledgeBaseName => 'Введите название базы знаний';

  @override
  String get loadingFailed => 'Ошибка загрузки';

  @override
  String get creating => 'Создание…';

  @override
  String get createSuccess => 'Создано';

  @override
  String get createFailed => 'Ошибка создания. Попробуйте снова';

  @override
  String get noKnowledgeBase => 'Нет базы знаний';

  @override
  String get documents => 'Документы';

  @override
  String get chunks => 'Фрагменты';

  @override
  String get updated => 'Обновлено';

  @override
  String get send => 'Отправить';

  @override
  String get enterMessage => 'Введите сообщение…';

  @override
  String get noChatHistory => 'Нет истории чата';

  @override
  String get newChat => 'Новый чат';

  @override
  String get clear => 'Очистить';

  @override
  String get noAgents => 'Нет агентов';

  @override
  String get createAgent => 'Создать агента';

  @override
  String get noFiles => 'Нет файлов';

  @override
  String get uploadFile => 'Загрузить файл';

  @override
  String get fileName => 'Имя файла';

  @override
  String get fileSize => 'Размер файла';

  @override
  String get uploadTime => 'Время загрузки';

  @override
  String get resetAgent => 'Сбросить агента';

  @override
  String get resetAgentConfirm =>
      'Сбросить агента? Текущая история чата будет удалена.';

  @override
  String get reset => 'Сбросить';

  @override
  String get resetSuccess => 'Сброшено';

  @override
  String get resetFailed => 'Ошибка сброса';

  @override
  String get thinking => 'Думаю…';

  @override
  String get you => 'Вы';

  @override
  String sendFailed(String message) {
    return 'Ошибка отправки: $message';
  }

  @override
  String get requestFailed => 'Ошибка запроса';

  @override
  String get stop => 'Стоп';

  @override
  String get createNewConversation => 'Новый диалог';

  @override
  String get conversationName => 'Название диалога';

  @override
  String get noConversations => 'Нет диалогов';

  @override
  String get hideList => 'Скрыть список';

  @override
  String get showList => 'Показать список';

  @override
  String get refreshConversationList => 'Обновить список диалогов';

  @override
  String get selectConversation => 'Выберите диалог';

  @override
  String loadConversationListFailed(String error) {
    return 'Ошибка загрузки списка: $error';
  }

  @override
  String get getConversationInfoFailed =>
      'Не удалось загрузить информацию о диалоге';

  @override
  String get knowledgeBaseDetail => 'Подробности базы знаний';

  @override
  String get dataset => 'Набор данных';

  @override
  String get retrievalTest => 'Тест поиска';

  @override
  String get config => 'Настройки';

  @override
  String get searchDocuments => 'Поиск документов…';

  @override
  String get noDocuments => 'Нет документов';

  @override
  String get tokens => 'Токены';

  @override
  String get update => 'Обновить';

  @override
  String get detail => 'Подробнее';

  @override
  String get parse => 'Разбор';

  @override
  String get cancelParse => 'Отменить разбор';

  @override
  String get deleteDocument => 'Удалить документ';

  @override
  String get confirmDelete => 'Подтвердить удаление';

  @override
  String get confirmDeleteDocument => 'Удалить этот документ?';

  @override
  String get deleteSuccess => 'Удалено';

  @override
  String get deleteFailed => 'Ошибка удаления';

  @override
  String totalDocuments(int count) {
    return 'Всего $count документов';
  }

  @override
  String get previousPage => 'Пред. страница';

  @override
  String get nextPage => 'След. страница';

  @override
  String get id => 'ID';

  @override
  String get suffix => 'Суффикс';

  @override
  String get chunkCount => 'Число фрагментов';

  @override
  String get tokenCount => 'Число токенов';

  @override
  String get createTime => 'Дата создания';

  @override
  String get updateTime => 'Дата обновления';

  @override
  String get notStarted => 'Не начато';

  @override
  String get parsing => 'Разбор…';

  @override
  String get cancelled => 'Отменено';

  @override
  String get completed => 'Завершено';

  @override
  String get downloading => 'Загрузка…';

  @override
  String downloadSuccess(String path) {
    return 'Загружено: $path';
  }

  @override
  String get downloadFailed => 'Ошибка загрузки';

  @override
  String get startingParse => 'Запуск разбора…';

  @override
  String get parseStarted => 'Разбор запущен';

  @override
  String get startParseFailed => 'Не удалось запустить разбор';

  @override
  String get confirmCancel => 'Подтвердить отмену';

  @override
  String confirmCancelParse(String name) {
    return 'Отменить разбор документа «$name»?';
  }

  @override
  String get cancellingParse => 'Отмена разбора…';

  @override
  String get parseCancelled => 'Разбор отменён';

  @override
  String get cancelParseFailed => 'Не удалось отменить разбор';

  @override
  String get uploading => 'Отправка…';

  @override
  String get uploadSuccess => 'Загружено. Запуск разбора…';

  @override
  String get uploadFailed => 'Ошибка отправки';

  @override
  String get partialUploadFailed => 'Некоторые файлы не загружены';

  @override
  String loadDocumentsFailed(String error) {
    return 'Ошибка загрузки документов: $error';
  }

  @override
  String get enterQuestionForRetrieval => 'Введите вопрос для теста…';

  @override
  String get test => 'Тест';

  @override
  String get retrieving => 'Поиск…';

  @override
  String get enterQuestionForRetrievalTest => 'Введите вопрос для теста поиска';

  @override
  String retrievalResults(int count) {
    return 'Результаты (всего $count)';
  }

  @override
  String similarity(String percent) {
    return 'Сходство: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return 'Ошибка теста: $error';
  }

  @override
  String get basicInfo => 'Основная информация';

  @override
  String get knowledgeBaseNameRequired => 'Введите название базы знаний';

  @override
  String get knowledgeBaseImage => 'Изображение базы знаний';

  @override
  String get uploadImage => 'Загрузить изображение';

  @override
  String get imageSelected => 'Изображение выбрано';

  @override
  String get fileNotExists => 'Файл не найден';

  @override
  String get selectImageSource => 'Выберите источник изображения';

  @override
  String get selectFromGallery => 'Из галереи';

  @override
  String get takePhoto => 'Сфотографировать';

  @override
  String get imageTooLarge => 'Размер изображения не более 4 МБ';

  @override
  String selectImageFailed(String error) {
    return 'Ошибка выбора изображения: $error';
  }

  @override
  String get permission => 'Доступ';

  @override
  String get permissionOnlyMe => 'Только я';

  @override
  String get permissionTeam => 'Команда';

  @override
  String get documentLanguage => 'Язык документа';

  @override
  String get languageChinese => 'Chino';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get parserNaive => 'General';

  @override
  String get parserQa => 'P y R';

  @override
  String get parserResume => 'Currículum';

  @override
  String get parserManual => 'Manual';

  @override
  String get parserTable => 'Tabla';

  @override
  String get parserPaper => 'Artículo';

  @override
  String get parserBook => 'Libro';

  @override
  String get parserLaws => 'Legal';

  @override
  String get parserPresentation => 'Presentación';

  @override
  String get parserPicture => 'Imagen';

  @override
  String get parserOne => 'Una página';

  @override
  String get parserAudio => 'Audio';

  @override
  String get parserEmail => 'Correo';

  @override
  String get parserTag => 'Etiqueta';

  @override
  String get parserKnowledgeGraph => 'Grafo de conocimiento';

  @override
  String get parseConfig => 'Configuración de análisis';

  @override
  String get sliceMethod => 'Método de fragmentación (parser)';

  @override
  String get sliceMethodHelper =>
      'Seleccione el método de análisis y fragmentación';

  @override
  String get embeddingModel => 'Modelo de embebido';

  @override
  String get embeddingModelHelper => 'Modelo para vectores de embebido';

  @override
  String get embeddingModelWarning =>
      'Cambiar el modelo con fragmentos existentes requiere borrarlos todos';

  @override
  String get noModelsAvailable => 'No hay modelos disponibles';

  @override
  String get suggestedChunkSize => 'Tamaño de fragmento sugerido (tokens)';

  @override
  String get chunkSizeHelper => 'Umbral de tokens para fragmentos';

  @override
  String get textDelimiter => 'Delimitador de texto';

  @override
  String get delimiterHelper => 'Delimitador, p. ej. \\n';

  @override
  String get layoutRecognition => 'Reconocimiento de diseño';

  @override
  String get layoutRecognitionHelper => 'Método de reconocimiento de diseño';

  @override
  String get plainText => 'Texto plano';

  @override
  String get pageRank => 'Page Rank';

  @override
  String get pageRankHelper => 'Valor de Page Rank para ordenar resultados';

  @override
  String get advancedOptions => 'Opciones avanzadas';

  @override
  String get autoKeywordsCount => 'N.º de palabras clave auto';

  @override
  String get autoKeywordsHelper => '0 = sin extracción';

  @override
  String get autoQuestionsCount => 'N.º de preguntas auto';

  @override
  String get autoQuestionsHelper => '0 = sin extracción';

  @override
  String get tableToHtml => 'Tabla a HTML';

  @override
  String get tableToHtmlSubtitle => 'Convertir tablas Excel a HTML';

  @override
  String get useRaptor => 'Usar estrategia RAPTOR';

  @override
  String get useRaptorSubtitle => 'Activar RAPTOR para mejorar la recuperación';

  @override
  String get extractKnowledgeGraph => 'Extraer grafo de conocimiento';

  @override
  String get extractKnowledgeGraphSubtitle =>
      'Activar extracción de grafo de conocimiento';

  @override
  String get saveConfig => 'Сохранить настройки';

  @override
  String get saveSuccess => 'Сохранено';

  @override
  String get fileManagement => 'Управление файлами';

  @override
  String get rootDirectory => 'Корневая папка';

  @override
  String get currentFolder => 'Текущая папка';

  @override
  String get searchFiles => 'Поиск файлов…';

  @override
  String get folder => 'Папка';

  @override
  String get preview => 'Просмотр';

  @override
  String cannotOpenPreview(String url) {
    return 'Не удалось открыть: $url';
  }

  @override
  String previewFailed(String error) {
    return 'Ошибка просмотра: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return 'Удалить \"$name\"?';
  }

  @override
  String totalFiles(int count) {
    return 'Всего $count файлов';
  }

  @override
  String get unnamed => 'Без имени';

  @override
  String loadFailed(String error) {
    return 'Ошибка загрузки: $error';
  }

  @override
  String totalAgents(int count) {
    return 'Всего $count агентов';
  }

  @override
  String get searchAgents => 'Поиск агентов…';

  @override
  String get noDescription => 'Нет описания';

  @override
  String get createNewDialog => 'Новый диалог';

  @override
  String get dialogName => 'Название диалога';

  @override
  String get descriptionOptional => 'Описание (необяз.)';

  @override
  String get noDialogs => 'Нет диалогов';

  @override
  String get selectKnowledgeBase => 'Выберите базу знаний:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase =>
      'Выберите хотя бы одну базу знаний';

  @override
  String get enterQuestion => 'Введите вопрос…';

  @override
  String get ask => 'Спросить';

  @override
  String get answer => 'Ответ:';

  @override
  String get relatedFiles => 'Связанные файлы:';

  @override
  String get relatedQuestions => 'Связанные вопросы:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'Выберите базу и введите вопрос';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'Ошибка загрузки базы: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return 'Ошибка запроса: $error';
  }

  @override
  String get exampleProduction => 'напр. Продакшен';

  @override
  String get rsaPublicKey => 'RSA Public Key';

  @override
  String get rsaPublicKeySettings => 'RSA Public Key Settings';

  @override
  String get rsaPublicKeyHint =>
      'RSA public key used to encrypt login password';

  @override
  String get rsaPublicKeyRequired => 'Please enter RSA public key';

  @override
  String get rsaPublicKeyInvalid => 'Invalid RSA public key format';

  @override
  String get rsaPublicKeySaved => 'RSA public key saved';

  @override
  String get rsaPublicKeySaveFailed => 'Failed to save RSA public key';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get resetToDefaultConfirm =>
      'Are you sure you want to reset to the default public key?';

  @override
  String get resetToDefaultSuccess => 'Reset to default public key';

  @override
  String get resetToDefaultFailed => 'Reset failed';

  @override
  String get showRsaPublicKeySettings => 'Show RSA Public Key Settings';

  @override
  String get hideRsaPublicKeySettings => 'Hide RSA Public Key Settings';

  @override
  String get currentRsaPublicKey => 'Current Public Key';

  @override
  String get defaultRsaPublicKey => 'Default Public Key';
}
