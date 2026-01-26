// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'RAGFlow';

  @override
  String get login => 'Connexion';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get serverSettings => 'Paramètres du serveur';

  @override
  String get addServer => 'Ajouter un serveur';

  @override
  String get serverName => 'Nom du serveur (optionnel)';

  @override
  String get serverAddress => 'Adresse du serveur';

  @override
  String get exampleServerAddress => 'ex. http://192.168.1.100:9380';

  @override
  String get activate => 'Activer';

  @override
  String get delete => 'Supprimer';

  @override
  String get active => 'Actif';

  @override
  String get confirm => 'Confirmer';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String deleteServerConfirm(String serverName) {
    return 'Supprimer le serveur \"$serverName\" ?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'En passant à \"$serverName\", vous devrez vous reconnecter. Continuer ?';
  }

  @override
  String currentServer(String serverAddress) {
    return 'Serveur actuel : $serverAddress';
  }

  @override
  String get serverAdded => 'Serveur ajouté';

  @override
  String get serverDeleted => 'Serveur supprimé';

  @override
  String get switchFailed => 'Échec du changement';

  @override
  String get addFailed => 'Échec de l\'ajout. Vérifiez le format de l\'adresse';

  @override
  String get saveFailed => 'Échec de l\'enregistrement';

  @override
  String get serverAddressRequired => 'Saisissez l\'adresse du serveur';

  @override
  String get serverAddressFormatError =>
      'L\'adresse doit commencer par http:// ou https://';

  @override
  String get serverList => 'Liste des serveurs';

  @override
  String get noServerConfig => 'Aucune configuration de serveur';

  @override
  String get addServerHint => 'Cliquez ci-dessous pour ajouter un serveur';

  @override
  String get systemVersion => 'Version RAGFlow';

  @override
  String get systemStatus => 'État du système';

  @override
  String get refresh => 'Actualiser';

  @override
  String get cannotGetSystemStatus =>
      'Impossible d\'obtenir l\'état du système';

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
  String get language => 'Langue';

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get followSystem => 'Suivre le système';

  @override
  String get theme => 'Thème';

  @override
  String get themeSettings => 'Paramètres du thème';

  @override
  String get colorSchemeBlue => 'Bleu';

  @override
  String get colorSchemeGreen => 'Vert';

  @override
  String get colorSchemePurple => 'Violet';

  @override
  String get colorSchemeOrange => 'Orange';

  @override
  String get colorSchemeRed => 'Rouge';

  @override
  String get colorSchemeTeal => 'Sarcelle';

  @override
  String get colorSchemePink => 'Rose';

  @override
  String get colorSchemeIndigo => 'Indigo';

  @override
  String get colorSchemeBrown => 'Marron';

  @override
  String get colorSchemeCyan => 'Cyan';

  @override
  String get chinese => 'Chinois';

  @override
  String get english => 'Anglais';

  @override
  String get traditionalChinese => 'Chinois traditionnel';

  @override
  String get japanese => 'Japonais';

  @override
  String get korean => 'Coréen';

  @override
  String get german => 'Allemand';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get italian => 'Italien';

  @override
  String get russian => 'Russe';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get account => 'Compte';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get logout => 'Déconnexion';

  @override
  String get confirmLogout => 'Déconnexion ?';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get passwordChangeFailed =>
      'Échec du changement. Vérifiez le mot de passe actuel';

  @override
  String get passwordRequired => 'Saisissez le mot de passe';

  @override
  String get newPasswordRequired => 'Saisissez le nouveau mot de passe';

  @override
  String get confirmPasswordRequired => 'Confirmez le nouveau mot de passe';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get emailRequired => 'Saisissez l\'e-mail';

  @override
  String get invalidEmail => 'Saisissez une adresse e-mail valide';

  @override
  String get loginFailed =>
      'Échec de la connexion. Vérifiez l\'e-mail et le mot de passe';

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
  String get knowledgeBase => 'Base de connaissances';

  @override
  String get chat => 'Discussion';

  @override
  String get search => 'Recherche';

  @override
  String get agent => 'Agente';

  @override
  String get file => 'Archivo';

  @override
  String get noData => 'Sin datos';

  @override
  String get loading => 'Chargement…';

  @override
  String get retry => 'Reintentar';

  @override
  String get create => 'Créer';

  @override
  String get edit => 'Modifier';

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
  String get failed => 'Échec';

  @override
  String get pleaseWait => 'Espere…';

  @override
  String get areYouSure => '¿Está seguro?';

  @override
  String get deleteConfirm => 'Supprimer cet élément ?';

  @override
  String get operationSuccess => 'Operación correcta';

  @override
  String get operationFailed => 'Operación fallida';

  @override
  String get networkError => 'Erreur réseau. Vérifiez votre connexion';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get createKnowledgeBase => 'Créer une base de connaissances';

  @override
  String get knowledgeBaseName => 'Nombre de la base de conocimiento';

  @override
  String get enterKnowledgeBaseName =>
      'Saisissez le nom de la base de connaissances';

  @override
  String get loadingFailed => 'Error al cargar';

  @override
  String get creating => 'Creando…';

  @override
  String get createSuccess => 'Creado';

  @override
  String get createFailed => 'Error al crear. Inténtelo de nuevo';

  @override
  String get noKnowledgeBase => 'Aucune base de connaissances';

  @override
  String get documents => 'Documents';

  @override
  String get chunks => 'Fragmentos';

  @override
  String get updated => 'Actualizado';

  @override
  String get send => 'Envoyer';

  @override
  String get enterMessage => 'Escriba un mensaje…';

  @override
  String get noChatHistory => 'Sin historial de chat';

  @override
  String get newChat => 'Nouvelle discussion';

  @override
  String get clear => 'Borrar';

  @override
  String get noAgents => 'Sin agentes';

  @override
  String get createAgent => 'Crear agente';

  @override
  String get noFiles => 'Aucun fichier';

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
  String get createNewConversation => 'Nouvelle conversation';

  @override
  String get conversationName => 'Nombre de la conversación';

  @override
  String get noConversations => 'Aucune conversation';

  @override
  String get hideList => 'Ocultar lista';

  @override
  String get showList => 'Mostrar lista';

  @override
  String get refreshConversationList => 'Actualizar lista de conversaciones';

  @override
  String get selectConversation => 'Choisissez une conversation';

  @override
  String loadConversationListFailed(String error) {
    return 'Error al cargar la lista: $error';
  }

  @override
  String get getConversationInfoFailed =>
      'Error al obtener la información de la conversación';

  @override
  String get knowledgeBaseDetail => 'Détails de la base de connaissances';

  @override
  String get dataset => 'Conjunto de datos';

  @override
  String get retrievalTest => 'Test de recherche';

  @override
  String get config => 'Configuration';

  @override
  String get searchDocuments => 'Buscar documentos…';

  @override
  String get noDocuments => 'Aucun document';

  @override
  String get tokens => 'Tokens';

  @override
  String get update => 'Mettre à jour';

  @override
  String get detail => 'Détail';

  @override
  String get parse => 'Analyser';

  @override
  String get cancelParse => 'Annuler l\'analyse';

  @override
  String get deleteDocument => 'Supprimer le document';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get confirmDeleteDocument => 'Supprimer ce document ?';

  @override
  String get deleteSuccess => 'Supprimé';

  @override
  String get deleteFailed => 'Échec de la suppression';

  @override
  String totalDocuments(int count) {
    return 'Total $count documentos';
  }

  @override
  String get previousPage => 'Page précédente';

  @override
  String get nextPage => 'Page suivante';

  @override
  String get id => 'ID';

  @override
  String get suffix => 'Sufijo';

  @override
  String get chunkCount => 'N.º de fragmentos';

  @override
  String get tokenCount => 'N.º de tokens';

  @override
  String get createTime => 'Date de création';

  @override
  String get updateTime => 'Date de mise à jour';

  @override
  String get notStarted => 'Non démarré';

  @override
  String get parsing => 'Analyse en cours…';

  @override
  String get cancelled => 'Annulé';

  @override
  String get completed => 'Terminé';

  @override
  String get downloading => 'Téléchargement…';

  @override
  String downloadSuccess(String path) {
    return 'Téléchargé : $path';
  }

  @override
  String get downloadFailed => 'Échec du téléchargement';

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
  String get uploading => 'Envoi…';

  @override
  String get uploadSuccess => 'Envoyé. Analyse en cours…';

  @override
  String get uploadFailed => 'Échec de l\'envoi';

  @override
  String get partialUploadFailed => 'Algunos archivos no se pudieron subir';

  @override
  String loadDocumentsFailed(String error) {
    return 'Échec du chargement des documents : $error';
  }

  @override
  String get enterQuestionForRetrieval =>
      'Saisissez une question pour le test…';

  @override
  String get test => 'Test';

  @override
  String get retrieving => 'Recherche…';

  @override
  String get enterQuestionForRetrievalTest =>
      'Saisissez une question pour le test de recherche';

  @override
  String retrievalResults(int count) {
    return 'Résultats (total $count)';
  }

  @override
  String similarity(String percent) {
    return 'Similarité : $percent %';
  }

  @override
  String retrievalTestFailed(String error) {
    return 'Échec du test : $error';
  }

  @override
  String get basicInfo => 'Informations de base';

  @override
  String get knowledgeBaseNameRequired =>
      'Saisissez le nom de la base de connaissances';

  @override
  String get knowledgeBaseImage => 'Imagen de la base de conocimiento';

  @override
  String get uploadImage => 'Téléverser une image';

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
  String get permission => 'Permission';

  @override
  String get permissionOnlyMe => 'Moi uniquement';

  @override
  String get permissionTeam => 'Équipe';

  @override
  String get documentLanguage => 'Langue du document';

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
  String get parserEmail => 'E-mail';

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
      'Choisissez la méthode d\'analyse et de découpage';

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
  String get saveConfig => 'Enregistrer la configuration';

  @override
  String get saveSuccess => 'Enregistré';

  @override
  String get fileManagement => 'Gestion des fichiers';

  @override
  String get rootDirectory => 'Répertoire racine';

  @override
  String get currentFolder => 'Dossier actuel';

  @override
  String get searchFiles => 'Rechercher des fichiers…';

  @override
  String get folder => 'Dossier';

  @override
  String get preview => 'Aperçu';

  @override
  String cannotOpenPreview(String url) {
    return 'Impossible d\'ouvrir l\'aperçu : $url';
  }

  @override
  String previewFailed(String error) {
    return 'Échec de l\'aperçu : $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String totalFiles(int count) {
    return 'Total $count fichier(s)';
  }

  @override
  String get unnamed => 'Sans nom';

  @override
  String loadFailed(String error) {
    return 'Échec du chargement : $error';
  }

  @override
  String totalAgents(int count) {
    return 'Total $count agent(s)';
  }

  @override
  String get searchAgents => 'Rechercher des agents…';

  @override
  String get noDescription => 'Aucune description';

  @override
  String get createNewDialog => 'Nouveau dialogue';

  @override
  String get dialogName => 'Nom du dialogue';

  @override
  String get descriptionOptional => 'Description (optionnelle)';

  @override
  String get noDialogs => 'Aucun dialogue';

  @override
  String get selectKnowledgeBase => 'Sélectionner une base de connaissances :';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase =>
      'Sélectionnez au moins une base de connaissances';

  @override
  String get enterQuestion => 'Saisir une question…';

  @override
  String get ask => 'Demander';

  @override
  String get answer => 'Réponse :';

  @override
  String get relatedFiles => 'Fichiers associés :';

  @override
  String get relatedQuestions => 'Questions associées :';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'Sélectionnez une base et saisissez une question';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'Échec du chargement de la base : $error';
  }

  @override
  String askQuestionFailed(String error) {
    return 'Échec de la question : $error';
  }

  @override
  String get exampleProduction => 'ex. Production';

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
