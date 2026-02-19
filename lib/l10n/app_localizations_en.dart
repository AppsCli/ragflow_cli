// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RAGFlowCli';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get serverSettings => 'Server Settings';

  @override
  String get addServer => 'Add Server';

  @override
  String get serverName => 'Server Name (Optional)';

  @override
  String get serverAddress => 'Server Address';

  @override
  String get exampleServerAddress => 'e.g., http://192.168.1.100:9380';

  @override
  String get activate => 'Activate';

  @override
  String get delete => 'Delete';

  @override
  String get active => 'Active';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String deleteServerConfirm(String serverName) {
    return 'Are you sure you want to delete server \"$serverName\"?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'After switching to server \"$serverName\", you need to log in again. Do you want to continue?';
  }

  @override
  String currentServer(String serverAddress) {
    return 'Current Server: $serverAddress';
  }

  @override
  String get serverAdded => 'Server added successfully';

  @override
  String get serverDeleted => 'Server deleted';

  @override
  String get switchFailed => 'Switch failed';

  @override
  String get addFailed => 'Add failed, please check the address format';

  @override
  String get saveFailed => 'Save failed';

  @override
  String get serverAddressRequired => 'Please enter server address';

  @override
  String get serverAddressFormatError =>
      'Address must start with http:// or https://';

  @override
  String get serverList => 'Server List';

  @override
  String get noServerConfig => 'No server configuration';

  @override
  String get addServerHint => 'Click the button below to add a server';

  @override
  String get systemVersion => 'RAGFlow Version';

  @override
  String get systemStatus => 'System Status';

  @override
  String get refresh => 'Refresh';

  @override
  String get cannotGetSystemStatus => 'Cannot get system status';

  @override
  String get serverAddressHint =>
      'The server address should be a complete URL, for example:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com';

  @override
  String get documentEngine => 'Document Engine';

  @override
  String get storage => 'Storage';

  @override
  String get database => 'Database';

  @override
  String get redis => 'Redis';

  @override
  String get normal => 'Normal';

  @override
  String get abnormal => 'Abnormal';

  @override
  String get unknown => 'Unknown';

  @override
  String responseTime(String elapsed) {
    return 'Response Time: ${elapsed}ms';
  }

  @override
  String type(String type) {
    return 'Type';
  }

  @override
  String storageInfo(String storage) {
    return 'Storage: $storage';
  }

  @override
  String databaseInfo(String database) {
    return 'Database: $database';
  }

  @override
  String error(String error) {
    return 'Error';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get followSystem => 'Follow System';

  @override
  String get theme => 'Theme';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get colorSchemeBlue => 'Blue';

  @override
  String get colorSchemeGreen => 'Green';

  @override
  String get colorSchemePurple => 'Purple';

  @override
  String get colorSchemeOrange => 'Orange';

  @override
  String get colorSchemeRed => 'Red';

  @override
  String get colorSchemeTeal => 'Teal';

  @override
  String get colorSchemePink => 'Pink';

  @override
  String get colorSchemeIndigo => 'Indigo';

  @override
  String get colorSchemeBrown => 'Brown';

  @override
  String get colorSchemeCyan => 'Cyan';

  @override
  String get chinese => 'Chinese';

  @override
  String get english => 'English';

  @override
  String get traditionalChinese => 'Traditional Chinese';

  @override
  String get japanese => 'Japanese';

  @override
  String get korean => 'Korean';

  @override
  String get german => 'German';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';

  @override
  String get italian => 'Italian';

  @override
  String get russian => 'Russian';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logout => 'Logout';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get passwordChangeFailed =>
      'Password change failed, please check if the current password is correct';

  @override
  String get passwordRequired => 'Please enter password';

  @override
  String get newPasswordRequired => 'Please enter new password';

  @override
  String get confirmPasswordRequired => 'Please confirm new password';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'The two passwords do not match';

  @override
  String get emailRequired => 'Please enter email';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get loginFailed => 'Login failed, please check email and password';

  @override
  String get configureServerAddress => 'Configure Server Address';

  @override
  String get pleaseConfigureServer =>
      'Please configure server address before logging in';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get setServerAddress => 'Set Server Address';

  @override
  String get knowledgeBase => 'Knowledge Base';

  @override
  String get chat => 'Chat';

  @override
  String get search => 'Search';

  @override
  String get agent => 'Agent';

  @override
  String get file => 'File';

  @override
  String get noData => 'No Data';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get create => 'Create';

  @override
  String get edit => 'Edit';

  @override
  String get name => 'Name';

  @override
  String get description => 'Description';

  @override
  String get status => 'Status';

  @override
  String get actions => 'Actions';

  @override
  String get details => 'Details';

  @override
  String get back => 'Back';

  @override
  String get submit => 'Submit';

  @override
  String get close => 'Close';

  @override
  String get searchPlaceholder => 'Search...';

  @override
  String get noResults => 'No results found';

  @override
  String get upload => 'Upload';

  @override
  String get download => 'Download';

  @override
  String get view => 'View';

  @override
  String get createdAt => 'Created At';

  @override
  String get updatedAt => 'Updated At';

  @override
  String get size => 'Size';

  @override
  String get operation => 'Operation';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get deleteConfirm => 'Are you sure you want to delete this item?';

  @override
  String get operationSuccess => 'Operation successful';

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get networkError => 'Network error, please check your connection';

  @override
  String get unknownError => 'Unknown error occurred';

  @override
  String get createKnowledgeBase => 'Create Knowledge Base';

  @override
  String get knowledgeBaseName => 'Knowledge Base Name';

  @override
  String get enterKnowledgeBaseName => 'Please enter knowledge base name';

  @override
  String get loadingFailed => 'Loading failed';

  @override
  String get creating => 'Creating...';

  @override
  String get createSuccess => 'Create successful';

  @override
  String get createFailed => 'Create failed';

  @override
  String get noKnowledgeBase => 'No knowledge base';

  @override
  String get documents => 'Documents';

  @override
  String get chunks => 'Chunks';

  @override
  String get updated => 'Updated';

  @override
  String get send => 'Send';

  @override
  String get enterMessage => 'Enter message...';

  @override
  String get noChatHistory => 'No chat history';

  @override
  String get newChat => 'New Chat';

  @override
  String get clear => 'Clear';

  @override
  String get noAgents => 'No agents';

  @override
  String get createAgent => 'Create Agent';

  @override
  String get noFiles => 'No files';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get fileName => 'File Name';

  @override
  String get fileSize => 'File Size';

  @override
  String get uploadTime => 'Upload Time';

  @override
  String get resetAgent => 'Reset Agent';

  @override
  String get resetAgentConfirm =>
      'Are you sure you want to reset Agent? This will clear the current conversation history.';

  @override
  String get reset => 'Reset';

  @override
  String get resetSuccess => 'Reset successful';

  @override
  String get resetFailed => 'Reset failed';

  @override
  String get thinking => 'Thinking...';

  @override
  String get you => 'You';

  @override
  String sendFailed(String message) {
    return 'Send failed: $message';
  }

  @override
  String get requestFailed => 'Request failed';

  @override
  String get stop => 'Stop';

  @override
  String get createNewConversation => 'Create New Conversation';

  @override
  String get conversationName => 'Conversation Name';

  @override
  String get noConversations => 'No conversations';

  @override
  String get hideList => 'Hide List';

  @override
  String get showList => 'Show List';

  @override
  String get refreshConversationList => 'Refresh conversation list';

  @override
  String get selectConversation => 'Please select a conversation';

  @override
  String loadConversationListFailed(String error) {
    return 'Failed to load conversation list: $error';
  }

  @override
  String get getConversationInfoFailed =>
      'Failed to get conversation information';

  @override
  String get knowledgeBaseDetail => 'Knowledge Base Detail';

  @override
  String get dataset => 'Dataset';

  @override
  String get retrievalTest => 'Retrieval Test';

  @override
  String get config => 'Config';

  @override
  String get searchDocuments => 'Search documents...';

  @override
  String get noDocuments => 'No documents';

  @override
  String get tokens => 'Tokens';

  @override
  String get update => 'Update';

  @override
  String get detail => 'Detail';

  @override
  String get parse => 'Parse';

  @override
  String get cancelParse => 'Cancel Parse';

  @override
  String get deleteDocument => 'Delete Document';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteDocument =>
      'Are you sure you want to delete this document?';

  @override
  String get deleteSuccess => 'Delete successful';

  @override
  String get deleteFailed => 'Delete failed';

  @override
  String totalDocuments(int count) {
    return 'Total $count documents';
  }

  @override
  String get previousPage => 'Previous Page';

  @override
  String get nextPage => 'Next Page';

  @override
  String get id => 'ID';

  @override
  String get suffix => 'Suffix';

  @override
  String get chunkCount => 'Chunk Count';

  @override
  String get tokenCount => 'Token Count';

  @override
  String get createTime => 'Create Time';

  @override
  String get updateTime => 'Update Time';

  @override
  String get notStarted => 'Not Started';

  @override
  String get parsing => 'Parsing';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get completed => 'Completed';

  @override
  String get downloading => 'Downloading...';

  @override
  String downloadSuccess(String path) {
    return 'Download successful: $path';
  }

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get startingParse => 'Starting parse...';

  @override
  String get parseStarted => 'Parse started';

  @override
  String get startParseFailed => 'Failed to start parse';

  @override
  String get confirmCancel => 'Confirm Cancel';

  @override
  String confirmCancelParse(String name) {
    return 'Are you sure you want to cancel parsing document \"$name\"?';
  }

  @override
  String get cancellingParse => 'Cancelling parse...';

  @override
  String get parseCancelled => 'Parse cancelled';

  @override
  String get cancelParseFailed => 'Failed to cancel parse';

  @override
  String get uploading => 'Uploading...';

  @override
  String get uploadSuccess => 'Upload successful, starting parse...';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get partialUploadFailed => 'Some files failed to upload';

  @override
  String loadDocumentsFailed(String error) {
    return 'Failed to load documents: $error';
  }

  @override
  String get enterQuestionForRetrieval =>
      'Enter question for retrieval test...';

  @override
  String get test => 'Test';

  @override
  String get retrieving => 'Retrieving...';

  @override
  String get enterQuestionForRetrievalTest =>
      'Please enter question for retrieval test';

  @override
  String retrievalResults(int count) {
    return 'Retrieval Results (Total $count)';
  }

  @override
  String similarity(String percent) {
    return 'Similarity: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return 'Retrieval test failed: $error';
  }

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get knowledgeBaseNameRequired => 'Please enter knowledge base name';

  @override
  String get knowledgeBaseImage => 'Knowledge Base Image';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get imageSelected => 'Image selected';

  @override
  String get fileNotExists => 'File does not exist';

  @override
  String get selectImageSource => 'Select Image Source';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get imageTooLarge => 'Image size cannot exceed 4MB';

  @override
  String selectImageFailed(String error) {
    return 'Failed to select image: $error';
  }

  @override
  String get permission => 'Permission';

  @override
  String get permissionOnlyMe => 'Only me';

  @override
  String get permissionTeam => 'Team';

  @override
  String get documentLanguage => 'Document Language';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageEnglish => 'English';

  @override
  String get parserNaive => 'General';

  @override
  String get parserQa => 'Q&A';

  @override
  String get parserResume => 'Resume';

  @override
  String get parserManual => 'Manual';

  @override
  String get parserTable => 'Table';

  @override
  String get parserPaper => 'Paper';

  @override
  String get parserBook => 'Book';

  @override
  String get parserLaws => 'Laws';

  @override
  String get parserPresentation => 'Presentation';

  @override
  String get parserPicture => 'Picture';

  @override
  String get parserOne => 'One Page';

  @override
  String get parserAudio => 'Audio';

  @override
  String get parserEmail => 'Email';

  @override
  String get parserTag => 'Tag';

  @override
  String get parserKnowledgeGraph => 'Knowledge Graph';

  @override
  String get parseConfig => 'Parse Config';

  @override
  String get sliceMethod => 'Slice Method (Parser)';

  @override
  String get sliceMethodHelper => 'Select document parsing and slicing method';

  @override
  String get embeddingModel => 'Embedding Model';

  @override
  String get embeddingModelHelper =>
      'Select model for generating embedding vectors';

  @override
  String get embeddingModelWarning =>
      'Note: Changing embedding model when chunks exist requires deleting all chunks';

  @override
  String get noModelsAvailable => 'No models available';

  @override
  String get suggestedChunkSize => 'Suggested Chunk Size (Token Count)';

  @override
  String get chunkSizeHelper => 'Set Token threshold for creating chunks';

  @override
  String get textDelimiter => 'Text Delimiter';

  @override
  String get delimiterHelper => 'Delimiter for splitting text, e.g. \\n';

  @override
  String get layoutRecognition => 'Layout Recognition';

  @override
  String get layoutRecognitionHelper => 'Select layout recognition method';

  @override
  String get plainText => 'Plain Text';

  @override
  String get pageRank => 'Page Rank';

  @override
  String get pageRankHelper => 'Page rank value for search result sorting';

  @override
  String get advancedOptions => 'Advanced Options';

  @override
  String get autoKeywordsCount => 'Auto Keywords Extraction Count';

  @override
  String get autoKeywordsHelper => '0 means no extraction';

  @override
  String get autoQuestionsCount => 'Auto Questions Extraction Count';

  @override
  String get autoQuestionsHelper => '0 means no extraction';

  @override
  String get tableToHtml => 'Table to HTML';

  @override
  String get tableToHtmlSubtitle => 'Convert Excel tables to HTML format';

  @override
  String get useRaptor => 'Use RAPTOR Strategy for Enhanced Recall';

  @override
  String get useRaptorSubtitle =>
      'Enable RAPTOR strategy to enhance recall effect';

  @override
  String get extractKnowledgeGraph => 'Extract Knowledge Graph';

  @override
  String get extractKnowledgeGraphSubtitle =>
      'Enable knowledge graph extraction';

  @override
  String get saveConfig => 'Save Config';

  @override
  String get saveSuccess => 'Save successful';

  @override
  String get fileManagement => 'File Management';

  @override
  String get rootDirectory => 'Root Directory';

  @override
  String get currentFolder => 'Current Folder';

  @override
  String get searchFiles => 'Search files...';

  @override
  String get folder => 'Folder';

  @override
  String get preview => 'Preview';

  @override
  String cannotOpenPreview(String url) {
    return 'Cannot open preview: $url';
  }

  @override
  String previewFailed(String error) {
    return 'Preview failed: $error';
  }

  @override
  String get previewPdfOnly => 'Only PDF files can be previewed';

  @override
  String confirmDeleteFile(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String totalFiles(int count) {
    return 'Total $count files';
  }

  @override
  String get unnamed => 'Unnamed';

  @override
  String loadFailed(String error) {
    return 'Load failed: $error';
  }

  @override
  String totalAgents(int count) {
    return 'Total $count agents';
  }

  @override
  String get searchAgents => 'Search Agents...';

  @override
  String get noDescription => 'No description';

  @override
  String get createNewDialog => 'Create New Dialog';

  @override
  String get dialogName => 'Dialog Name';

  @override
  String get descriptionOptional => 'Description (Optional)';

  @override
  String get noDialogs => 'No dialogs';

  @override
  String get selectKnowledgeBase => 'Select Knowledge Base:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase =>
      'Please select at least one knowledge base';

  @override
  String get enterQuestion => 'Enter question...';

  @override
  String get ask => 'Ask';

  @override
  String get answer => 'Answer:';

  @override
  String get relatedFiles => 'Related Files:';

  @override
  String get relatedQuestions => 'Related Questions:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'Please select knowledge base and enter question for search';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'Failed to load knowledge base: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return 'Failed to ask question: $error';
  }

  @override
  String get exampleProduction => 'e.g., Production';

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
