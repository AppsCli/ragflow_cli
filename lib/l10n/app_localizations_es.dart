// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'RAGFlow';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get serverSettings => 'Configuración del servidor';

  @override
  String get addServer => 'Añadir servidor';

  @override
  String get serverName => 'Nombre del servidor (opcional)';

  @override
  String get serverAddress => 'Dirección del servidor';

  @override
  String get exampleServerAddress => 'ej.: http://192.168.1.100:9380';

  @override
  String get activate => 'Activar';

  @override
  String get delete => 'Eliminar';

  @override
  String get active => 'Activo';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String deleteServerConfirm(String serverName) {
    return '¿Eliminar el servidor \"$serverName\"?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'Al cambiar a \"$serverName\" deberá iniciar sesión de nuevo. ¿Continuar?';
  }

  @override
  String currentServer(String serverAddress) {
    return 'Servidor actual: $serverAddress';
  }

  @override
  String get serverAdded => 'Servidor añadido';

  @override
  String get serverDeleted => 'Servidor eliminado';

  @override
  String get switchFailed => 'Error al cambiar';

  @override
  String get addFailed =>
      'Error al añadir. Compruebe el formato de la dirección';

  @override
  String get saveFailed => 'Error al guardar';

  @override
  String get serverAddressRequired => 'Introduzca la dirección del servidor';

  @override
  String get serverAddressFormatError =>
      'La dirección debe comenzar por http:// o https://';

  @override
  String get serverList => 'Lista de servidores';

  @override
  String get noServerConfig => 'Sin configuración de servidor';

  @override
  String get addServerHint => 'Pulse el botón inferior para añadir un servidor';

  @override
  String get systemVersion => 'Versión RAGFlow';

  @override
  String get systemStatus => 'Estado del sistema';

  @override
  String get refresh => 'Actualizar';

  @override
  String get cannotGetSystemStatus =>
      'No se puede obtener el estado del sistema';

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
  String get language => 'Idioma';

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get followSystem => 'Usar el del sistema';

  @override
  String get theme => 'Tema';

  @override
  String get themeSettings => 'Configuración del tema';

  @override
  String get colorSchemeBlue => 'Azul';

  @override
  String get colorSchemeGreen => 'Verde';

  @override
  String get colorSchemePurple => 'Morado';

  @override
  String get colorSchemeOrange => 'Naranja';

  @override
  String get colorSchemeRed => 'Rojo';

  @override
  String get colorSchemeTeal => 'Verde azulado';

  @override
  String get colorSchemePink => 'Rosa';

  @override
  String get colorSchemeIndigo => 'Índigo';

  @override
  String get colorSchemeBrown => 'Marrón';

  @override
  String get colorSchemeCyan => 'Cian';

  @override
  String get chinese => 'Chino';

  @override
  String get english => 'Inglés';

  @override
  String get traditionalChinese => 'Chino tradicional';

  @override
  String get japanese => 'Japonés';

  @override
  String get korean => 'Coreano';

  @override
  String get german => 'Alemán';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get italian => 'Italiano';

  @override
  String get russian => 'Ruso';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get account => 'Cuenta';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get confirmLogout => '¿Cerrar sesión?';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get passwordChangeFailed =>
      'Error al cambiar. Compruebe la contraseña actual';

  @override
  String get passwordRequired => 'Introduzca la contraseña';

  @override
  String get newPasswordRequired => 'Introduzca la nueva contraseña';

  @override
  String get confirmPasswordRequired => 'Confirme la nueva contraseña';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get emailRequired => 'Introduzca el correo';

  @override
  String get invalidEmail => 'Introduzca un correo válido';

  @override
  String get loginFailed =>
      'Error al iniciar sesión. Compruebe correo y contraseña';

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
  String get knowledgeBase => 'Base de conocimiento';

  @override
  String get chat => 'Chat';

  @override
  String get search => 'Buscar';

  @override
  String get agent => 'Agente';

  @override
  String get file => 'Archivo';

  @override
  String get noData => 'Sin datos';

  @override
  String get loading => 'Cargando…';

  @override
  String get retry => 'Reintentar';

  @override
  String get create => 'Crear';

  @override
  String get edit => 'Editar';

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
  String get back => 'Atrás';

  @override
  String get submit => 'Enviar';

  @override
  String get close => 'Cerrar';

  @override
  String get searchPlaceholder => 'Buscar…';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get upload => 'Subir';

  @override
  String get download => 'Descargar';

  @override
  String get view => 'Ver';

  @override
  String get createdAt => 'Creado';

  @override
  String get updatedAt => 'Actualizado';

  @override
  String get size => 'Tamaño';

  @override
  String get operation => 'Operación';

  @override
  String get success => 'Éxito';

  @override
  String get failed => 'Fallido';

  @override
  String get pleaseWait => 'Espere…';

  @override
  String get areYouSure => '¿Está seguro?';

  @override
  String get deleteConfirm => '¿Eliminar este elemento?';

  @override
  String get operationSuccess => 'Operación correcta';

  @override
  String get operationFailed => 'Operación fallida';

  @override
  String get networkError => 'Error de red. Compruebe la conexión';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get createKnowledgeBase => 'Crear base de conocimiento';

  @override
  String get knowledgeBaseName => 'Nombre de la base de conocimiento';

  @override
  String get enterKnowledgeBaseName =>
      'Introduzca el nombre de la base de conocimiento';

  @override
  String get loadingFailed => 'Error al cargar';

  @override
  String get creating => 'Creando…';

  @override
  String get createSuccess => 'Creado';

  @override
  String get createFailed => 'Error al crear. Inténtelo de nuevo';

  @override
  String get noKnowledgeBase => 'Sin base de conocimiento';

  @override
  String get documents => 'Documentos';

  @override
  String get chunks => 'Fragmentos';

  @override
  String get updated => 'Actualizado';

  @override
  String get send => 'Enviar';

  @override
  String get enterMessage => 'Escriba un mensaje…';

  @override
  String get noChatHistory => 'Sin historial de chat';

  @override
  String get newChat => 'Nuevo chat';

  @override
  String get clear => 'Borrar';

  @override
  String get noAgents => 'Sin agentes';

  @override
  String get createAgent => 'Crear agente';

  @override
  String get noFiles => 'Sin archivos';

  @override
  String get uploadFile => 'Subir archivo';

  @override
  String get fileName => 'Nombre del archivo';

  @override
  String get fileSize => 'Tamaño del archivo';

  @override
  String get uploadTime => 'Fecha de subida';

  @override
  String get resetAgent => 'Restablecer agente';

  @override
  String get resetAgentConfirm =>
      '¿Restablecer agente? Se borrará el historial de chat actual.';

  @override
  String get reset => 'Restablecer';

  @override
  String get resetSuccess => 'Restablecido';

  @override
  String get resetFailed => 'Error al restablecer';

  @override
  String get thinking => 'Pensando…';

  @override
  String get you => 'Usted';

  @override
  String sendFailed(String message) {
    return 'Error al enviar: $message';
  }

  @override
  String get requestFailed => 'Error en la solicitud';

  @override
  String get stop => 'Detener';

  @override
  String get createNewConversation => 'Nueva conversación';

  @override
  String get conversationName => 'Nombre de la conversación';

  @override
  String get noConversations => 'Sin conversaciones';

  @override
  String get hideList => 'Ocultar lista';

  @override
  String get showList => 'Mostrar lista';

  @override
  String get refreshConversationList => 'Actualizar lista de conversaciones';

  @override
  String get selectConversation => 'Seleccione una conversación';

  @override
  String loadConversationListFailed(String error) {
    return 'Error al cargar la lista: $error';
  }

  @override
  String get getConversationInfoFailed =>
      'Error al obtener la información de la conversación';

  @override
  String get knowledgeBaseDetail => 'Detalles de la base de conocimiento';

  @override
  String get dataset => 'Conjunto de datos';

  @override
  String get retrievalTest => 'Prueba de recuperación';

  @override
  String get config => 'Configuración';

  @override
  String get searchDocuments => 'Buscar documentos…';

  @override
  String get noDocuments => 'Sin documentos';

  @override
  String get tokens => 'Tokens';

  @override
  String get update => 'Actualizar';

  @override
  String get detail => 'Detalle';

  @override
  String get parse => 'Analizar';

  @override
  String get cancelParse => 'Cancelar análisis';

  @override
  String get deleteDocument => 'Eliminar documento';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String get confirmDeleteDocument => '¿Eliminar este documento?';

  @override
  String get deleteSuccess => 'Eliminado';

  @override
  String get deleteFailed => 'Error al eliminar';

  @override
  String totalDocuments(int count) {
    return 'Total $count documentos';
  }

  @override
  String get previousPage => 'Página anterior';

  @override
  String get nextPage => 'Página siguiente';

  @override
  String get id => 'ID';

  @override
  String get suffix => 'Sufijo';

  @override
  String get chunkCount => 'N.º de fragmentos';

  @override
  String get tokenCount => 'N.º de tokens';

  @override
  String get createTime => 'Fecha de creación';

  @override
  String get updateTime => 'Fecha de actualización';

  @override
  String get notStarted => 'No iniciado';

  @override
  String get parsing => 'Analizando…';

  @override
  String get cancelled => 'Cancelado';

  @override
  String get completed => 'Completado';

  @override
  String get downloading => 'Descargando…';

  @override
  String downloadSuccess(String path) {
    return 'Descargado: $path';
  }

  @override
  String get downloadFailed => 'Error al descargar';

  @override
  String get startingParse => 'Iniciando análisis…';

  @override
  String get parseStarted => 'Análisis iniciado';

  @override
  String get startParseFailed => 'Error al iniciar el análisis';

  @override
  String get confirmCancel => 'Confirmar cancelación';

  @override
  String confirmCancelParse(String name) {
    return '¿Cancelar el análisis de \"$name\"?';
  }

  @override
  String get cancellingParse => 'Cancelando análisis…';

  @override
  String get parseCancelled => 'Análisis cancelado';

  @override
  String get cancelParseFailed => 'Error al cancelar el análisis';

  @override
  String get uploading => 'Subiendo…';

  @override
  String get uploadSuccess => 'Subido. Iniciando análisis…';

  @override
  String get uploadFailed => 'Error al subir';

  @override
  String get partialUploadFailed => 'Algunos archivos no se pudieron subir';

  @override
  String loadDocumentsFailed(String error) {
    return 'Error al cargar documentos: $error';
  }

  @override
  String get enterQuestionForRetrieval =>
      'Introduzca una pregunta para la prueba…';

  @override
  String get test => 'Prueba';

  @override
  String get retrieving => 'Recuperando…';

  @override
  String get enterQuestionForRetrievalTest =>
      'Introduzca una pregunta para la prueba de recuperación';

  @override
  String retrievalResults(int count) {
    return 'Resultados (total $count)';
  }

  @override
  String similarity(String percent) {
    return 'Similitud: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return 'Error en la prueba: $error';
  }

  @override
  String get basicInfo => 'Información básica';

  @override
  String get knowledgeBaseNameRequired =>
      'Introduzca el nombre de la base de conocimiento';

  @override
  String get knowledgeBaseImage => 'Imagen de la base de conocimiento';

  @override
  String get uploadImage => 'Subir imagen';

  @override
  String get imageSelected => 'Imagen seleccionada';

  @override
  String get fileNotExists => 'El archivo no existe';

  @override
  String get selectImageSource => 'Seleccionar origen de la imagen';

  @override
  String get selectFromGallery => 'Desde la galería';

  @override
  String get takePhoto => 'Tomar foto';

  @override
  String get imageTooLarge => 'La imagen no puede superar 4 MB';

  @override
  String selectImageFailed(String error) {
    return 'Error al seleccionar imagen: $error';
  }

  @override
  String get permission => 'Permiso';

  @override
  String get permissionOnlyMe => 'Solo yo';

  @override
  String get permissionTeam => 'Equipo';

  @override
  String get documentLanguage => 'Idioma del documento';

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
  String get saveConfig => 'Guardar configuración';

  @override
  String get saveSuccess => 'Guardado';

  @override
  String get fileManagement => 'Gestión de archivos';

  @override
  String get rootDirectory => 'Directorio raíz';

  @override
  String get currentFolder => 'Carpeta actual';

  @override
  String get searchFiles => 'Buscar archivos…';

  @override
  String get folder => 'Carpeta';

  @override
  String get preview => 'Vista previa';

  @override
  String cannotOpenPreview(String url) {
    return 'No se puede abrir la vista previa: $url';
  }

  @override
  String previewFailed(String error) {
    return 'Error en la vista previa: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String totalFiles(int count) {
    return 'Total $count archivos';
  }

  @override
  String get unnamed => 'Sin nombre';

  @override
  String loadFailed(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String totalAgents(int count) {
    return 'Total $count agentes';
  }

  @override
  String get searchAgents => 'Buscar agentes…';

  @override
  String get noDescription => 'Sin descripción';

  @override
  String get createNewDialog => 'Nuevo diálogo';

  @override
  String get dialogName => 'Nombre del diálogo';

  @override
  String get descriptionOptional => 'Descripción (opcional)';

  @override
  String get noDialogs => 'Sin diálogos';

  @override
  String get selectKnowledgeBase => 'Seleccionar base de conocimiento:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase =>
      'Seleccione al menos una base de conocimiento';

  @override
  String get enterQuestion => 'Escriba una pregunta…';

  @override
  String get ask => 'Preguntar';

  @override
  String get answer => 'Respuesta:';

  @override
  String get relatedFiles => 'Archivos relacionados:';

  @override
  String get relatedQuestions => 'Preguntas relacionadas:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'Seleccione una base e introduzca una pregunta';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'Error al cargar la base: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return 'Error al formular la pregunta: $error';
  }

  @override
  String get exampleProduction => 'ej.: Producción';

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
