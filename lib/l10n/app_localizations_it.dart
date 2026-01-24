// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'RAGFlow';

  @override
  String get login => 'Accedi';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get serverSettings => 'Impostazioni server';

  @override
  String get addServer => 'Aggiungi server';

  @override
  String get serverName => 'Nome server (opzionale)';

  @override
  String get serverAddress => 'Indirizzo server';

  @override
  String get exampleServerAddress => 'es. http://192.168.1.100:9380';

  @override
  String get activate => 'Attiva';

  @override
  String get delete => 'Elimina';

  @override
  String get active => 'Attivo';

  @override
  String get confirm => 'Conferma';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String deleteServerConfirm(String serverName) {
    return 'Eliminare il server \"$serverName\"?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'Passando a \"$serverName\" dovrai effettuare di nuovo l\'accesso. Continuare?';
  }

  @override
  String currentServer(String serverAddress) {
    return 'Server attuale: $serverAddress';
  }

  @override
  String get serverAdded => 'Server aggiunto';

  @override
  String get serverDeleted => 'Server eliminato';

  @override
  String get switchFailed => 'Cambio fallito';

  @override
  String get addFailed =>
      'Aggiunta fallita. Controlla il formato dell\'indirizzo';

  @override
  String get saveFailed => 'Salvataggio fallito';

  @override
  String get serverAddressRequired => 'Inserisci l\'indirizzo del server';

  @override
  String get serverAddressFormatError =>
      'L\'indirizzo deve iniziare con http:// o https://';

  @override
  String get serverList => 'Elenco server';

  @override
  String get noServerConfig => 'Nessuna configurazione server';

  @override
  String get addServerHint => 'Clicca sotto per aggiungere un server';

  @override
  String get systemVersion => 'Versione RAGFlow';

  @override
  String get systemStatus => 'Stato del sistema';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get cannotGetSystemStatus =>
      'Impossibile ottenere lo stato del sistema';

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
  String get language => 'Lingua';

  @override
  String get languageSettings => 'Impostazioni lingua';

  @override
  String get followSystem => 'Segui sistema';

  @override
  String get chinese => 'Cinese';

  @override
  String get english => 'Inglese';

  @override
  String get traditionalChinese => 'Cinese tradizionale';

  @override
  String get japanese => 'Giapponese';

  @override
  String get korean => 'Coreano';

  @override
  String get german => 'Tedesco';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get french => 'Francese';

  @override
  String get italian => 'Italiano';

  @override
  String get russian => 'Russo';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get logout => 'Esci';

  @override
  String get confirmLogout => 'Esci?';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get confirmNewPassword => 'Conferma nuova password';

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get passwordChangeFailed =>
      'Errore nel cambio. Verifica la password attuale';

  @override
  String get passwordRequired => 'Inserisci la password';

  @override
  String get newPasswordRequired => 'Inserisci la nuova password';

  @override
  String get confirmPasswordRequired => 'Conferma la nuova password';

  @override
  String get passwordTooShort =>
      'La password deve essere di almeno 8 caratteri';

  @override
  String get passwordsDoNotMatch => 'Le password non coincidono';

  @override
  String get emailRequired => 'Inserisci l\'email';

  @override
  String get invalidEmail => 'Inserisci un indirizzo email valido';

  @override
  String get loginFailed => 'Accesso fallito. Verifica email e password';

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
  String get knowledgeBase => 'Base di conoscenza';

  @override
  String get chat => 'Chat';

  @override
  String get search => 'Cerca';

  @override
  String get agent => 'Agente';

  @override
  String get file => 'Archivo';

  @override
  String get noData => 'Sin datos';

  @override
  String get loading => 'Caricamento…';

  @override
  String get retry => 'Reintentar';

  @override
  String get create => 'Crea';

  @override
  String get edit => 'Modifica';

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
  String get failed => 'Fallito';

  @override
  String get pleaseWait => 'Espere…';

  @override
  String get areYouSure => '¿Está seguro?';

  @override
  String get deleteConfirm => 'Eliminare questo elemento?';

  @override
  String get operationSuccess => 'Operación correcta';

  @override
  String get operationFailed => 'Operación fallida';

  @override
  String get networkError => 'Errore di rete. Verifica la connessione';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get createKnowledgeBase => 'Crea base di conoscenza';

  @override
  String get knowledgeBaseName => 'Nombre de la base de conocimiento';

  @override
  String get enterKnowledgeBaseName =>
      'Inserisci il nome della base di conoscenza';

  @override
  String get loadingFailed => 'Error al cargar';

  @override
  String get creating => 'Creando…';

  @override
  String get createSuccess => 'Creado';

  @override
  String get createFailed => 'Error al crear. Inténtelo de nuevo';

  @override
  String get noKnowledgeBase => 'Nessuna base di conoscenza';

  @override
  String get documents => 'Documenti';

  @override
  String get chunks => 'Fragmentos';

  @override
  String get updated => 'Actualizado';

  @override
  String get send => 'Invia';

  @override
  String get enterMessage => 'Escriba un mensaje…';

  @override
  String get noChatHistory => 'Sin historial de chat';

  @override
  String get newChat => 'Nuova chat';

  @override
  String get clear => 'Borrar';

  @override
  String get noAgents => 'Sin agentes';

  @override
  String get createAgent => 'Crear agente';

  @override
  String get noFiles => 'Nessun file';

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
  String get createNewConversation => 'Nuova conversazione';

  @override
  String get conversationName => 'Nombre de la conversación';

  @override
  String get noConversations => 'Nessuna conversazione';

  @override
  String get hideList => 'Ocultar lista';

  @override
  String get showList => 'Mostrar lista';

  @override
  String get refreshConversationList => 'Actualizar lista de conversaciones';

  @override
  String get selectConversation => 'Seleziona una conversazione';

  @override
  String loadConversationListFailed(String error) {
    return 'Error al cargar la lista: $error';
  }

  @override
  String get getConversationInfoFailed =>
      'Error al obtener la información de la conversación';

  @override
  String get knowledgeBaseDetail => 'Dettagli base di conoscenza';

  @override
  String get dataset => 'Conjunto de datos';

  @override
  String get retrievalTest => 'Test di recupero';

  @override
  String get config => 'Configurazione';

  @override
  String get searchDocuments => 'Buscar documentos…';

  @override
  String get noDocuments => 'Nessun documento';

  @override
  String get tokens => 'Tokens';

  @override
  String get update => 'Aggiorna';

  @override
  String get detail => 'Dettaglio';

  @override
  String get parse => 'Analizza';

  @override
  String get cancelParse => 'Annulla analisi';

  @override
  String get deleteDocument => 'Elimina documento';

  @override
  String get confirmDelete => 'Conferma eliminazione';

  @override
  String get confirmDeleteDocument => 'Eliminare questo documento?';

  @override
  String get deleteSuccess => 'Eliminato';

  @override
  String get deleteFailed => 'Eliminazione fallita';

  @override
  String totalDocuments(int count) {
    return 'Total $count documentos';
  }

  @override
  String get previousPage => 'Pagina precedente';

  @override
  String get nextPage => 'Pagina successiva';

  @override
  String get id => 'ID';

  @override
  String get suffix => 'Sufijo';

  @override
  String get chunkCount => 'N.º de fragmentos';

  @override
  String get tokenCount => 'N.º de tokens';

  @override
  String get createTime => 'Data creazione';

  @override
  String get updateTime => 'Data aggiornamento';

  @override
  String get notStarted => 'Non avviato';

  @override
  String get parsing => 'Analisi in corso…';

  @override
  String get cancelled => 'Annullato';

  @override
  String get completed => 'Completato';

  @override
  String get downloading => 'Download…';

  @override
  String downloadSuccess(String path) {
    return 'Scaricato: $path';
  }

  @override
  String get downloadFailed => 'Download fallito';

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
  String get uploading => 'Caricamento…';

  @override
  String get uploadSuccess => 'Caricato. Analisi avviata…';

  @override
  String get uploadFailed => 'Caricamento fallito';

  @override
  String get partialUploadFailed => 'Algunos archivos no se pudieron subir';

  @override
  String loadDocumentsFailed(String error) {
    return 'Caricamento documenti fallito: $error';
  }

  @override
  String get enterQuestionForRetrieval => 'Inserisci una domanda per il test…';

  @override
  String get test => 'Test';

  @override
  String get retrieving => 'Recupero…';

  @override
  String get enterQuestionForRetrievalTest =>
      'Inserisci una domanda per il test di recupero';

  @override
  String retrievalResults(int count) {
    return 'Risultati (totale $count)';
  }

  @override
  String similarity(String percent) {
    return 'Similarità: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return 'Test fallito: $error';
  }

  @override
  String get basicInfo => 'Informazioni di base';

  @override
  String get knowledgeBaseNameRequired =>
      'Inserisci il nome della base di conoscenza';

  @override
  String get knowledgeBaseImage => 'Imagen de la base de conocimiento';

  @override
  String get uploadImage => 'Carica immagine';

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
  String get permission => 'Permesso';

  @override
  String get permissionOnlyMe => 'Solo io';

  @override
  String get permissionTeam => 'Team';

  @override
  String get documentLanguage => 'Lingua del documento';

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
  String get parserEmail => 'Email';

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
      'Seleziona il metodo di analisi e frammentazione';

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
  String get saveConfig => 'Salva configurazione';

  @override
  String get saveSuccess => 'Salvato';

  @override
  String get fileManagement => 'Gestione file';

  @override
  String get rootDirectory => 'Directory radice';

  @override
  String get currentFolder => 'Cartella corrente';

  @override
  String get searchFiles => 'Cerca file…';

  @override
  String get folder => 'Cartella';

  @override
  String get preview => 'Anteprima';

  @override
  String cannotOpenPreview(String url) {
    return 'Impossibile aprire l\'anteprima: $url';
  }

  @override
  String previewFailed(String error) {
    return 'Anteprima fallita: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String totalFiles(int count) {
    return 'Totale $count file';
  }

  @override
  String get unnamed => 'Senza nome';

  @override
  String loadFailed(String error) {
    return 'Caricamento fallito: $error';
  }

  @override
  String totalAgents(int count) {
    return 'Totale $count agenti';
  }

  @override
  String get searchAgents => 'Cerca agenti…';

  @override
  String get noDescription => 'Nessuna descrizione';

  @override
  String get createNewDialog => 'Nuovo dialogo';

  @override
  String get dialogName => 'Nome dialogo';

  @override
  String get descriptionOptional => 'Descrizione (opzionale)';

  @override
  String get noDialogs => 'Nessun dialogo';

  @override
  String get selectKnowledgeBase => 'Seleziona base di conoscenza:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase =>
      'Seleziona almeno una base di conoscenza';

  @override
  String get enterQuestion => 'Inserisci domanda…';

  @override
  String get ask => 'Chiedi';

  @override
  String get answer => 'Risposta:';

  @override
  String get relatedFiles => 'File correlati:';

  @override
  String get relatedQuestions => 'Domande correlate:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'Seleziona una base e inserisci una domanda';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'Caricamento base fallito: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return 'Domanda fallita: $error';
  }

  @override
  String get exampleProduction => 'es. Produzione';
}
