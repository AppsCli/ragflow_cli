// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'RAGFlowCli';

  @override
  String get login => 'Anmelden';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get serverSettings => 'Servereinstellungen';

  @override
  String get addServer => 'Server hinzufügen';

  @override
  String get serverName => 'Servername (optional)';

  @override
  String get serverAddress => 'Serveradresse';

  @override
  String get exampleServerAddress => 'z. B. http://192.168.1.100:9380';

  @override
  String get activate => 'Aktivieren';

  @override
  String get delete => 'Löschen';

  @override
  String get active => 'Aktiv';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String deleteServerConfirm(String serverName) {
    return 'Server \"$serverName\" wirklich löschen?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'Nach dem Wechsel zu \"$serverName\" müssen Sie sich erneut anmelden. Fortfahren?';
  }

  @override
  String currentServer(String serverAddress) {
    return 'Aktueller Server: $serverAddress';
  }

  @override
  String get serverAdded => 'Server wurde hinzugefügt';

  @override
  String get serverDeleted => 'Server wurde gelöscht';

  @override
  String get switchFailed => 'Wechsel fehlgeschlagen';

  @override
  String get addFailed => 'Hinzufügen fehlgeschlagen. Adressformat prüfen';

  @override
  String get saveFailed => 'Speichern fehlgeschlagen';

  @override
  String get serverAddressRequired => 'Serveradresse eingeben';

  @override
  String get serverAddressFormatError =>
      'Adresse muss mit http:// oder https:// beginnen';

  @override
  String get serverList => 'Serverliste';

  @override
  String get noServerConfig => 'Keine Serverkonfiguration';

  @override
  String get addServerHint => 'Klicken Sie unten, um einen Server hinzuzufügen';

  @override
  String get systemVersion => 'RAGFlow-Version';

  @override
  String get systemStatus => 'Systemstatus';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get cannotGetSystemStatus =>
      'Systemstatus konnte nicht geladen werden';

  @override
  String get serverAddressHint =>
      'Die Serveradresse muss eine vollständige URL sein, z. B.:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com';

  @override
  String get documentEngine => 'Dokumenten-Engine';

  @override
  String get storage => 'Speicher';

  @override
  String get database => 'Datenbank';

  @override
  String get redis => 'Redis';

  @override
  String get normal => 'Normal';

  @override
  String get abnormal => 'Abweichend';

  @override
  String get unknown => 'Unbekannt';

  @override
  String responseTime(String elapsed) {
    return 'Antwortzeit: ${elapsed}ms';
  }

  @override
  String type(String type) {
    return 'Typ';
  }

  @override
  String storageInfo(String storage) {
    return 'Speicher: $storage';
  }

  @override
  String databaseInfo(String database) {
    return 'Datenbank: $database';
  }

  @override
  String error(String error) {
    return 'Fehler: $error';
  }

  @override
  String get language => 'Sprache';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get followSystem => 'Systemsprache';

  @override
  String get theme => 'Design';

  @override
  String get themeSettings => 'Design-Einstellungen';

  @override
  String get colorSchemeBlue => 'Blau';

  @override
  String get colorSchemeGreen => 'Grün';

  @override
  String get colorSchemePurple => 'Lila';

  @override
  String get colorSchemeOrange => 'Orange';

  @override
  String get colorSchemeRed => 'Rot';

  @override
  String get colorSchemeTeal => 'Türkis';

  @override
  String get colorSchemePink => 'Rosa';

  @override
  String get colorSchemeIndigo => 'Indigo';

  @override
  String get colorSchemeBrown => 'Braun';

  @override
  String get colorSchemeCyan => 'Cyan';

  @override
  String get chinese => 'Chinesisch';

  @override
  String get english => 'Englisch';

  @override
  String get traditionalChinese => 'Traditionelles Chinesisch';

  @override
  String get japanese => 'Japanisch';

  @override
  String get korean => 'Koreanisch';

  @override
  String get german => 'Deutsch';

  @override
  String get spanish => 'Spanisch';

  @override
  String get french => 'Französisch';

  @override
  String get italian => 'Italienisch';

  @override
  String get russian => 'Russisch';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get account => 'Konto';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get logout => 'Abmelden';

  @override
  String get confirmLogout => 'Wirklich abmelden?';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get passwordChanged => 'Passwort wurde geändert';

  @override
  String get passwordChangeFailed =>
      'Passwortänderung fehlgeschlagen. Aktuelles Passwort prüfen';

  @override
  String get passwordRequired => 'Passwort eingeben';

  @override
  String get newPasswordRequired => 'Neues Passwort eingeben';

  @override
  String get confirmPasswordRequired => 'Neues Passwort bestätigen';

  @override
  String get passwordTooShort => 'Passwort muss mindestens 8 Zeichen haben';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get emailRequired => 'E-Mail eingeben';

  @override
  String get invalidEmail => 'Gültige E-Mail-Adresse eingeben';

  @override
  String get loginFailed =>
      'Anmeldung fehlgeschlagen. E-Mail und Passwort prüfen';

  @override
  String get configureServerAddress => 'Serveradresse konfigurieren';

  @override
  String get pleaseConfigureServer =>
      'Bitte zuerst Serveradresse konfigurieren';

  @override
  String get goToSettings => 'Zu Einstellungen';

  @override
  String get setServerAddress => 'Serveradresse setzen';

  @override
  String get knowledgeBase => 'Wissensbasis';

  @override
  String get chat => 'Chat';

  @override
  String get search => 'Suchen';

  @override
  String get agent => 'Agent';

  @override
  String get file => 'Datei';

  @override
  String get noData => 'Keine Daten';

  @override
  String get loading => 'Laden…';

  @override
  String get retry => 'Erneut';

  @override
  String get create => 'Erstellen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get name => 'Name';

  @override
  String get description => 'Beschreibung';

  @override
  String get status => 'Status';

  @override
  String get actions => 'Aktionen';

  @override
  String get details => 'Details';

  @override
  String get back => 'Zurück';

  @override
  String get submit => 'Absenden';

  @override
  String get close => 'Schließen';

  @override
  String get searchPlaceholder => 'Suchen…';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get upload => 'Hochladen';

  @override
  String get download => 'Herunterladen';

  @override
  String get view => 'Anzeigen';

  @override
  String get createdAt => 'Erstellt am';

  @override
  String get updatedAt => 'Aktualisiert am';

  @override
  String get size => 'Größe';

  @override
  String get operation => 'Aktion';

  @override
  String get success => 'Erfolg';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get pleaseWait => 'Bitte warten…';

  @override
  String get areYouSure => 'Sind Sie sicher?';

  @override
  String get deleteConfirm => 'Dieses Element wirklich löschen?';

  @override
  String get operationSuccess => 'Aktion erfolgreich';

  @override
  String get operationFailed => 'Aktion fehlgeschlagen';

  @override
  String get networkError => 'Netzwerkfehler. Verbindung prüfen';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get createKnowledgeBase => 'Wissensbasis erstellen';

  @override
  String get knowledgeBaseName => 'Name der Wissensbasis';

  @override
  String get enterKnowledgeBaseName => 'Name der Wissensbasis eingeben';

  @override
  String get loadingFailed => 'Laden fehlgeschlagen';

  @override
  String get creating => 'Erstellen…';

  @override
  String get createSuccess => 'Erstellt';

  @override
  String get createFailed => 'Erstellen fehlgeschlagen. Bitte erneut versuchen';

  @override
  String get noKnowledgeBase => 'Keine Wissensbasis';

  @override
  String get documents => 'Dokumente';

  @override
  String get chunks => 'Chunks';

  @override
  String get updated => 'Aktualisiert';

  @override
  String get send => 'Senden';

  @override
  String get enterMessage => 'Nachricht eingeben…';

  @override
  String get noChatHistory => 'Kein Chatverlauf';

  @override
  String get newChat => 'Neuer Chat';

  @override
  String get clear => 'Löschen';

  @override
  String get noAgents => 'Keine Agenten';

  @override
  String get createAgent => 'Agent erstellen';

  @override
  String get noFiles => 'Keine Dateien';

  @override
  String get uploadFile => 'Datei hochladen';

  @override
  String get fileName => 'Dateiname';

  @override
  String get fileSize => 'Dateigröße';

  @override
  String get uploadTime => 'Hochladezeit';

  @override
  String get resetAgent => 'Agent zurücksetzen';

  @override
  String get resetAgentConfirm =>
      'Agent zurücksetzen? Der aktuelle Chatverlauf wird gelöscht.';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get resetSuccess => 'Zurückgesetzt';

  @override
  String get resetFailed => 'Zurücksetzen fehlgeschlagen';

  @override
  String get thinking => 'Denken…';

  @override
  String get you => 'Sie';

  @override
  String sendFailed(String message) {
    return 'Senden fehlgeschlagen: $message';
  }

  @override
  String get requestFailed => 'Anfrage fehlgeschlagen';

  @override
  String get stop => 'Stopp';

  @override
  String get createNewConversation => 'Neue Unterhaltung';

  @override
  String get conversationName => 'Unterhaltungsname';

  @override
  String get noConversations => 'Keine Unterhaltungen';

  @override
  String get hideList => 'Liste ausblenden';

  @override
  String get showList => 'Liste einblenden';

  @override
  String get refreshConversationList => 'Unterhaltungsliste aktualisieren';

  @override
  String get selectConversation => 'Unterhaltung auswählen';

  @override
  String loadConversationListFailed(String error) {
    return 'Unterhaltungsliste konnte nicht geladen werden: $error';
  }

  @override
  String get getConversationInfoFailed =>
      'Unterhaltungsinformationen konnten nicht geladen werden';

  @override
  String get knowledgeBaseDetail => 'Wissensbasis-Details';

  @override
  String get dataset => 'Datensatz';

  @override
  String get retrievalTest => 'Abruf-Test';

  @override
  String get config => 'Konfiguration';

  @override
  String get searchDocuments => 'Dokumente suchen…';

  @override
  String get noDocuments => 'Keine Dokumente';

  @override
  String get tokens => 'Tokens';

  @override
  String get update => 'Aktualisieren';

  @override
  String get detail => 'Detail';

  @override
  String get parse => 'Parsen';

  @override
  String get cancelParse => 'Parsen abbrechen';

  @override
  String get deleteDocument => 'Dokument löschen';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get confirmDeleteDocument => 'Dieses Dokument wirklich löschen?';

  @override
  String get deleteSuccess => 'Gelöscht';

  @override
  String get deleteFailed => 'Löschen fehlgeschlagen';

  @override
  String totalDocuments(int count) {
    return 'Gesamt $count Dokumente';
  }

  @override
  String get previousPage => 'Vorherige Seite';

  @override
  String get nextPage => 'Nächste Seite';

  @override
  String get id => 'ID';

  @override
  String get suffix => 'Erweiterung';

  @override
  String get chunkCount => 'Chunk-Anzahl';

  @override
  String get tokenCount => 'Token-Anzahl';

  @override
  String get createTime => 'Erstellt am';

  @override
  String get updateTime => 'Aktualisiert am';

  @override
  String get notStarted => 'Nicht gestartet';

  @override
  String get parsing => 'Parsen…';

  @override
  String get cancelled => 'Abgebrochen';

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get downloading => 'Herunterladen…';

  @override
  String downloadSuccess(String path) {
    return 'Heruntergeladen: $path';
  }

  @override
  String get downloadFailed => 'Download fehlgeschlagen';

  @override
  String get startingParse => 'Parsen wird gestartet…';

  @override
  String get parseStarted => 'Parsen gestartet';

  @override
  String get startParseFailed => 'Parsen konnte nicht gestartet werden';

  @override
  String get confirmCancel => 'Abbrechen bestätigen';

  @override
  String confirmCancelParse(String name) {
    return 'Parsen von \"$name\" wirklich abbrechen?';
  }

  @override
  String get cancellingParse => 'Parsen wird abgebrochen…';

  @override
  String get parseCancelled => 'Parsen abgebrochen';

  @override
  String get cancelParseFailed => 'Parsen konnte nicht abgebrochen werden';

  @override
  String get uploading => 'Hochladen…';

  @override
  String get uploadSuccess => 'Hochgeladen. Parsen wird gestartet…';

  @override
  String get uploadFailed => 'Hochladen fehlgeschlagen';

  @override
  String get partialUploadFailed =>
      'Einige Dateien konnten nicht hochgeladen werden';

  @override
  String loadDocumentsFailed(String error) {
    return 'Dokumente konnten nicht geladen werden: $error';
  }

  @override
  String get enterQuestionForRetrieval => 'Frage für Abruf-Test eingeben…';

  @override
  String get test => 'Test';

  @override
  String get retrieving => 'Abrufen…';

  @override
  String get enterQuestionForRetrievalTest => 'Frage für Abruf-Test eingeben';

  @override
  String retrievalResults(int count) {
    return 'Abrufergebnisse (Gesamt $count)';
  }

  @override
  String similarity(String percent) {
    return 'Ähnlichkeit: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return 'Abruf-Test fehlgeschlagen: $error';
  }

  @override
  String get basicInfo => 'Grundlegende Informationen';

  @override
  String get knowledgeBaseNameRequired => 'Name der Wissensbasis eingeben';

  @override
  String get knowledgeBaseImage => 'Wissensbasis-Bild';

  @override
  String get uploadImage => 'Bild hochladen';

  @override
  String get imageSelected => 'Bild ausgewählt';

  @override
  String get fileNotExists => 'Datei existiert nicht';

  @override
  String get selectImageSource => 'Bildquelle wählen';

  @override
  String get selectFromGallery => 'Aus Galerie';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get imageTooLarge => 'Bild darf maximal 4 MB groß sein';

  @override
  String selectImageFailed(String error) {
    return 'Bild konnte nicht ausgewählt werden: $error';
  }

  @override
  String get permission => 'Berechtigung';

  @override
  String get permissionOnlyMe => 'Nur ich';

  @override
  String get permissionTeam => 'Team';

  @override
  String get documentLanguage => 'Dokumentsprache';

  @override
  String get languageChinese => 'Chinesisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get parserNaive => 'Allgemein';

  @override
  String get parserQa => 'Frage & Antwort';

  @override
  String get parserResume => 'Lebenslauf';

  @override
  String get parserManual => 'Manuell';

  @override
  String get parserTable => 'Tabelle';

  @override
  String get parserPaper => 'Papier';

  @override
  String get parserBook => 'Buch';

  @override
  String get parserLaws => 'Recht';

  @override
  String get parserPresentation => 'Präsentation';

  @override
  String get parserPicture => 'Bild';

  @override
  String get parserOne => 'Eine Seite';

  @override
  String get parserAudio => 'Audio';

  @override
  String get parserEmail => 'E-Mail';

  @override
  String get parserTag => 'Tag';

  @override
  String get parserKnowledgeGraph => 'Wissensgraph';

  @override
  String get parseConfig => 'Parse-Konfiguration';

  @override
  String get sliceMethod => 'Slice-Methode (Parser)';

  @override
  String get sliceMethodHelper => 'Methode für Parsen und Slicen wählen';

  @override
  String get embeddingModel => 'Embedding-Modell';

  @override
  String get embeddingModelHelper => 'Modell für Embedding-Vektoren wählen';

  @override
  String get embeddingModelWarning =>
      'Hinweis: Bei bestehenden Chunks muss beim Wechsel des Embedding-Modells alles gelöscht werden';

  @override
  String get noModelsAvailable => 'Keine Modelle verfügbar';

  @override
  String get suggestedChunkSize => 'Empfohlene Chunk-Größe (Tokens)';

  @override
  String get chunkSizeHelper => 'Token-Schwellwert für Chunks setzen';

  @override
  String get textDelimiter => 'Texttrenner';

  @override
  String get delimiterHelper => 'Trennzeichen für Text, z. B. \\n';

  @override
  String get layoutRecognition => 'Layout-Erkennung';

  @override
  String get layoutRecognitionHelper => 'Layout-Erkennung wählen';

  @override
  String get plainText => 'Klartext';

  @override
  String get pageRank => 'Page Rank';

  @override
  String get pageRankHelper => 'Page-Rank-Wert für Sortierung';

  @override
  String get advancedOptions => 'Erweiterte Optionen';

  @override
  String get autoKeywordsCount =>
      'Anzahl automatisch extrahierter Schlüsselwörter';

  @override
  String get autoKeywordsHelper => '0 = keine Extraktion';

  @override
  String get autoQuestionsCount => 'Anzahl automatisch extrahierter Fragen';

  @override
  String get autoQuestionsHelper => '0 = keine Extraktion';

  @override
  String get tableToHtml => 'Tabelle zu HTML';

  @override
  String get tableToHtmlSubtitle => 'Excel-Tabellen als HTML';

  @override
  String get useRaptor => 'RAPTOR-Strategie für besseren Abruf';

  @override
  String get useRaptorSubtitle => 'RAPTOR-Strategie aktivieren';

  @override
  String get extractKnowledgeGraph => 'Wissensgraph extrahieren';

  @override
  String get extractKnowledgeGraphSubtitle =>
      'Wissensgraph-Extraktion aktivieren';

  @override
  String get saveConfig => 'Konfiguration speichern';

  @override
  String get saveSuccess => 'Gespeichert';

  @override
  String get fileManagement => 'Dateiverwaltung';

  @override
  String get rootDirectory => 'Stammverzeichnis';

  @override
  String get currentFolder => 'Aktueller Ordner';

  @override
  String get searchFiles => 'Dateien suchen…';

  @override
  String get folder => 'Ordner';

  @override
  String get preview => 'Vorschau';

  @override
  String cannotOpenPreview(String url) {
    return 'Vorschau nicht möglich: $url';
  }

  @override
  String previewFailed(String error) {
    return 'Vorschau fehlgeschlagen: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return '\"$name\" wirklich löschen?';
  }

  @override
  String totalFiles(int count) {
    return 'Gesamt $count Dateien';
  }

  @override
  String get unnamed => 'Unbenannt';

  @override
  String loadFailed(String error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String totalAgents(int count) {
    return 'Gesamt $count Agenten';
  }

  @override
  String get searchAgents => 'Agenten suchen…';

  @override
  String get noDescription => 'Keine Beschreibung';

  @override
  String get createNewDialog => 'Neuen Dialog erstellen';

  @override
  String get dialogName => 'Dialogname';

  @override
  String get descriptionOptional => 'Beschreibung (optional)';

  @override
  String get noDialogs => 'Keine Dialoge';

  @override
  String get selectKnowledgeBase => 'Wissensbasis wählen:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase =>
      'Mindestens eine Wissensbasis wählen';

  @override
  String get enterQuestion => 'Frage eingeben…';

  @override
  String get ask => 'Fragen';

  @override
  String get answer => 'Antwort:';

  @override
  String get relatedFiles => 'Verwandte Dateien:';

  @override
  String get relatedQuestions => 'Verwandte Fragen:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'Wissensbasis wählen und Frage eingeben';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'Wissensbasis konnte nicht geladen werden: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return 'Frage konnte nicht gestellt werden: $error';
  }

  @override
  String get exampleProduction => 'z. B. Produktion';

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
