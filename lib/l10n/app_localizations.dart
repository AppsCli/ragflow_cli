import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'RAGFlow'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// No description provided for @addServer.
  ///
  /// In en, this message translates to:
  /// **'Add Server'**
  String get addServer;

  /// No description provided for @serverName.
  ///
  /// In en, this message translates to:
  /// **'Server Name (Optional)'**
  String get serverName;

  /// No description provided for @serverAddress.
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// No description provided for @exampleServerAddress.
  ///
  /// In en, this message translates to:
  /// **'e.g., http://192.168.1.100:9380'**
  String get exampleServerAddress;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteServerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete server \"{serverName}\"?'**
  String deleteServerConfirm(String serverName);

  /// No description provided for @switchServerConfirm.
  ///
  /// In en, this message translates to:
  /// **'After switching to server \"{serverName}\", you need to log in again. Do you want to continue?'**
  String switchServerConfirm(String serverName);

  /// No description provided for @currentServer.
  ///
  /// In en, this message translates to:
  /// **'Current Server: {serverAddress}'**
  String currentServer(String serverAddress);

  /// No description provided for @serverAdded.
  ///
  /// In en, this message translates to:
  /// **'Server added successfully'**
  String get serverAdded;

  /// No description provided for @serverDeleted.
  ///
  /// In en, this message translates to:
  /// **'Server deleted'**
  String get serverDeleted;

  /// No description provided for @switchFailed.
  ///
  /// In en, this message translates to:
  /// **'Switch failed'**
  String get switchFailed;

  /// No description provided for @addFailed.
  ///
  /// In en, this message translates to:
  /// **'Add failed, please check the address format'**
  String get addFailed;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed'**
  String get saveFailed;

  /// No description provided for @serverAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter server address'**
  String get serverAddressRequired;

  /// No description provided for @serverAddressFormatError.
  ///
  /// In en, this message translates to:
  /// **'Address must start with http:// or https://'**
  String get serverAddressFormatError;

  /// No description provided for @serverList.
  ///
  /// In en, this message translates to:
  /// **'Server List'**
  String get serverList;

  /// No description provided for @noServerConfig.
  ///
  /// In en, this message translates to:
  /// **'No server configuration'**
  String get noServerConfig;

  /// No description provided for @addServerHint.
  ///
  /// In en, this message translates to:
  /// **'Click the button below to add a server'**
  String get addServerHint;

  /// No description provided for @systemVersion.
  ///
  /// In en, this message translates to:
  /// **'RAGFlow Version'**
  String get systemVersion;

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get systemStatus;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @cannotGetSystemStatus.
  ///
  /// In en, this message translates to:
  /// **'Cannot get system status'**
  String get cannotGetSystemStatus;

  /// No description provided for @serverAddressHint.
  ///
  /// In en, this message translates to:
  /// **'The server address should be a complete URL, for example:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com'**
  String get serverAddressHint;

  /// No description provided for @documentEngine.
  ///
  /// In en, this message translates to:
  /// **'Document Engine'**
  String get documentEngine;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get database;

  /// No description provided for @redis.
  ///
  /// In en, this message translates to:
  /// **'Redis'**
  String get redis;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @abnormal.
  ///
  /// In en, this message translates to:
  /// **'Abnormal'**
  String get abnormal;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @responseTime.
  ///
  /// In en, this message translates to:
  /// **'Response Time: {elapsed}ms'**
  String responseTime(String elapsed);

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String type(String type);

  /// No description provided for @storageInfo.
  ///
  /// In en, this message translates to:
  /// **'Storage: {storage}'**
  String storageInfo(String storage);

  /// No description provided for @databaseInfo.
  ///
  /// In en, this message translates to:
  /// **'Database: {database}'**
  String databaseInfo(String database);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String error(String error);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get followSystem;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @passwordChangeFailed.
  ///
  /// In en, this message translates to:
  /// **'Password change failed, please check if the current password is correct'**
  String get passwordChangeFailed;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get passwordRequired;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter new password'**
  String get newPasswordRequired;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm new password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The two passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please check email and password'**
  String get loginFailed;

  /// No description provided for @configureServerAddress.
  ///
  /// In en, this message translates to:
  /// **'Configure Server Address'**
  String get configureServerAddress;

  /// No description provided for @pleaseConfigureServer.
  ///
  /// In en, this message translates to:
  /// **'Please configure server address before logging in'**
  String get pleaseConfigureServer;

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// No description provided for @setServerAddress.
  ///
  /// In en, this message translates to:
  /// **'Set Server Address'**
  String get setServerAddress;

  /// No description provided for @knowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get knowledgeBase;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @agent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get agent;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchPlaceholder;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated At'**
  String get updatedAt;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @operation.
  ///
  /// In en, this message translates to:
  /// **'Operation'**
  String get operation;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirm;

  /// No description provided for @operationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Operation successful'**
  String get operationSuccess;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your connection'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownError;

  /// No description provided for @createKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Create Knowledge Base'**
  String get createKnowledgeBase;

  /// No description provided for @knowledgeBaseName.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base Name'**
  String get knowledgeBaseName;

  /// No description provided for @enterKnowledgeBaseName.
  ///
  /// In en, this message translates to:
  /// **'Please enter knowledge base name'**
  String get enterKnowledgeBaseName;

  /// No description provided for @loadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Loading failed'**
  String get loadingFailed;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @createSuccess.
  ///
  /// In en, this message translates to:
  /// **'Create successful'**
  String get createSuccess;

  /// No description provided for @createFailed.
  ///
  /// In en, this message translates to:
  /// **'Create failed'**
  String get createFailed;

  /// No description provided for @noKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'No knowledge base'**
  String get noKnowledgeBase;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @chunks.
  ///
  /// In en, this message translates to:
  /// **'Chunks'**
  String get chunks;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter message...'**
  String get enterMessage;

  /// No description provided for @noChatHistory.
  ///
  /// In en, this message translates to:
  /// **'No chat history'**
  String get noChatHistory;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noAgents.
  ///
  /// In en, this message translates to:
  /// **'No agents'**
  String get noAgents;

  /// No description provided for @createAgent.
  ///
  /// In en, this message translates to:
  /// **'Create Agent'**
  String get createAgent;

  /// No description provided for @noFiles.
  ///
  /// In en, this message translates to:
  /// **'No files'**
  String get noFiles;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get fileName;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get fileSize;

  /// No description provided for @uploadTime.
  ///
  /// In en, this message translates to:
  /// **'Upload Time'**
  String get uploadTime;

  /// No description provided for @resetAgent.
  ///
  /// In en, this message translates to:
  /// **'Reset Agent'**
  String get resetAgent;

  /// No description provided for @resetAgentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset Agent? This will clear the current conversation history.'**
  String get resetAgentConfirm;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reset successful'**
  String get resetSuccess;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset failed'**
  String get resetFailed;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Send failed: {message}'**
  String sendFailed(String message);

  /// No description provided for @requestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed'**
  String get requestFailed;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @createNewConversation.
  ///
  /// In en, this message translates to:
  /// **'Create New Conversation'**
  String get createNewConversation;

  /// No description provided for @conversationName.
  ///
  /// In en, this message translates to:
  /// **'Conversation Name'**
  String get conversationName;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No conversations'**
  String get noConversations;

  /// No description provided for @hideList.
  ///
  /// In en, this message translates to:
  /// **'Hide List'**
  String get hideList;

  /// No description provided for @showList.
  ///
  /// In en, this message translates to:
  /// **'Show List'**
  String get showList;

  /// No description provided for @refreshConversationList.
  ///
  /// In en, this message translates to:
  /// **'Refresh conversation list'**
  String get refreshConversationList;

  /// No description provided for @selectConversation.
  ///
  /// In en, this message translates to:
  /// **'Please select a conversation'**
  String get selectConversation;

  /// No description provided for @loadConversationListFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load conversation list: {error}'**
  String loadConversationListFailed(String error);

  /// No description provided for @getConversationInfoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to get conversation information'**
  String get getConversationInfoFailed;

  /// No description provided for @knowledgeBaseDetail.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base Detail'**
  String get knowledgeBaseDetail;

  /// No description provided for @dataset.
  ///
  /// In en, this message translates to:
  /// **'Dataset'**
  String get dataset;

  /// No description provided for @retrievalTest.
  ///
  /// In en, this message translates to:
  /// **'Retrieval Test'**
  String get retrievalTest;

  /// No description provided for @config.
  ///
  /// In en, this message translates to:
  /// **'Config'**
  String get config;

  /// No description provided for @searchDocuments.
  ///
  /// In en, this message translates to:
  /// **'Search documents...'**
  String get searchDocuments;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents'**
  String get noDocuments;

  /// No description provided for @tokens.
  ///
  /// In en, this message translates to:
  /// **'Tokens'**
  String get tokens;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @parse.
  ///
  /// In en, this message translates to:
  /// **'Parse'**
  String get parse;

  /// No description provided for @cancelParse.
  ///
  /// In en, this message translates to:
  /// **'Cancel Parse'**
  String get cancelParse;

  /// No description provided for @deleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocument;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteDocument.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this document?'**
  String get confirmDeleteDocument;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delete successful'**
  String get deleteSuccess;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed'**
  String get deleteFailed;

  /// No description provided for @totalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Total {count} documents'**
  String totalDocuments(int count);

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous Page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next Page'**
  String get nextPage;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @suffix.
  ///
  /// In en, this message translates to:
  /// **'Suffix'**
  String get suffix;

  /// No description provided for @chunkCount.
  ///
  /// In en, this message translates to:
  /// **'Chunk Count'**
  String get chunkCount;

  /// No description provided for @tokenCount.
  ///
  /// In en, this message translates to:
  /// **'Token Count'**
  String get tokenCount;

  /// No description provided for @createTime.
  ///
  /// In en, this message translates to:
  /// **'Create Time'**
  String get createTime;

  /// No description provided for @updateTime.
  ///
  /// In en, this message translates to:
  /// **'Update Time'**
  String get updateTime;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not Started'**
  String get notStarted;

  /// No description provided for @parsing.
  ///
  /// In en, this message translates to:
  /// **'Parsing'**
  String get parsing;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// No description provided for @downloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Download successful: {path}'**
  String downloadSuccess(String path);

  /// No description provided for @downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// No description provided for @startingParse.
  ///
  /// In en, this message translates to:
  /// **'Starting parse...'**
  String get startingParse;

  /// No description provided for @parseStarted.
  ///
  /// In en, this message translates to:
  /// **'Parse started'**
  String get parseStarted;

  /// No description provided for @startParseFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to start parse'**
  String get startParseFailed;

  /// No description provided for @confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancel'**
  String get confirmCancel;

  /// No description provided for @confirmCancelParse.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel parsing document \"{name}\"?'**
  String confirmCancelParse(String name);

  /// No description provided for @cancellingParse.
  ///
  /// In en, this message translates to:
  /// **'Cancelling parse...'**
  String get cancellingParse;

  /// No description provided for @parseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Parse cancelled'**
  String get parseCancelled;

  /// No description provided for @cancelParseFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel parse'**
  String get cancelParseFailed;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upload successful, starting parse...'**
  String get uploadSuccess;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @partialUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Some files failed to upload'**
  String get partialUploadFailed;

  /// No description provided for @loadDocumentsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load documents: {error}'**
  String loadDocumentsFailed(String error);

  /// No description provided for @enterQuestionForRetrieval.
  ///
  /// In en, this message translates to:
  /// **'Enter question for retrieval test...'**
  String get enterQuestionForRetrieval;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @retrieving.
  ///
  /// In en, this message translates to:
  /// **'Retrieving...'**
  String get retrieving;

  /// No description provided for @enterQuestionForRetrievalTest.
  ///
  /// In en, this message translates to:
  /// **'Please enter question for retrieval test'**
  String get enterQuestionForRetrievalTest;

  /// No description provided for @retrievalResults.
  ///
  /// In en, this message translates to:
  /// **'Retrieval Results (Total {count})'**
  String retrievalResults(int count);

  /// No description provided for @similarity.
  ///
  /// In en, this message translates to:
  /// **'Similarity: {percent}%'**
  String similarity(String percent);

  /// No description provided for @retrievalTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Retrieval test failed: {error}'**
  String retrievalTestFailed(String error);

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @knowledgeBaseNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter knowledge base name'**
  String get knowledgeBaseNameRequired;

  /// No description provided for @knowledgeBaseImage.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base Image'**
  String get knowledgeBaseImage;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @imageSelected.
  ///
  /// In en, this message translates to:
  /// **'Image selected'**
  String get imageSelected;

  /// No description provided for @fileNotExists.
  ///
  /// In en, this message translates to:
  /// **'File does not exist'**
  String get fileNotExists;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @imageTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Image size cannot exceed 4MB'**
  String get imageTooLarge;

  /// No description provided for @selectImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to select image: {error}'**
  String selectImageFailed(String error);

  /// No description provided for @permission.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get permission;

  /// No description provided for @permissionOnlyMe.
  ///
  /// In en, this message translates to:
  /// **'Only me'**
  String get permissionOnlyMe;

  /// No description provided for @permissionTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get permissionTeam;

  /// No description provided for @documentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Document Language'**
  String get documentLanguage;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @parserNaive.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get parserNaive;

  /// No description provided for @parserQa.
  ///
  /// In en, this message translates to:
  /// **'Q&A'**
  String get parserQa;

  /// No description provided for @parserResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get parserResume;

  /// No description provided for @parserManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get parserManual;

  /// No description provided for @parserTable.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get parserTable;

  /// No description provided for @parserPaper.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get parserPaper;

  /// No description provided for @parserBook.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get parserBook;

  /// No description provided for @parserLaws.
  ///
  /// In en, this message translates to:
  /// **'Laws'**
  String get parserLaws;

  /// No description provided for @parserPresentation.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get parserPresentation;

  /// No description provided for @parserPicture.
  ///
  /// In en, this message translates to:
  /// **'Picture'**
  String get parserPicture;

  /// No description provided for @parserOne.
  ///
  /// In en, this message translates to:
  /// **'One Page'**
  String get parserOne;

  /// No description provided for @parserAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get parserAudio;

  /// No description provided for @parserEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get parserEmail;

  /// No description provided for @parserTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get parserTag;

  /// No description provided for @parserKnowledgeGraph.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Graph'**
  String get parserKnowledgeGraph;

  /// No description provided for @parseConfig.
  ///
  /// In en, this message translates to:
  /// **'Parse Config'**
  String get parseConfig;

  /// No description provided for @sliceMethod.
  ///
  /// In en, this message translates to:
  /// **'Slice Method (Parser)'**
  String get sliceMethod;

  /// No description provided for @sliceMethodHelper.
  ///
  /// In en, this message translates to:
  /// **'Select document parsing and slicing method'**
  String get sliceMethodHelper;

  /// No description provided for @embeddingModel.
  ///
  /// In en, this message translates to:
  /// **'Embedding Model'**
  String get embeddingModel;

  /// No description provided for @embeddingModelHelper.
  ///
  /// In en, this message translates to:
  /// **'Select model for generating embedding vectors'**
  String get embeddingModelHelper;

  /// No description provided for @embeddingModelWarning.
  ///
  /// In en, this message translates to:
  /// **'Note: Changing embedding model when chunks exist requires deleting all chunks'**
  String get embeddingModelWarning;

  /// No description provided for @noModelsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No models available'**
  String get noModelsAvailable;

  /// No description provided for @suggestedChunkSize.
  ///
  /// In en, this message translates to:
  /// **'Suggested Chunk Size (Token Count)'**
  String get suggestedChunkSize;

  /// No description provided for @chunkSizeHelper.
  ///
  /// In en, this message translates to:
  /// **'Set Token threshold for creating chunks'**
  String get chunkSizeHelper;

  /// No description provided for @textDelimiter.
  ///
  /// In en, this message translates to:
  /// **'Text Delimiter'**
  String get textDelimiter;

  /// No description provided for @delimiterHelper.
  ///
  /// In en, this message translates to:
  /// **'Delimiter for splitting text, e.g. \\n'**
  String get delimiterHelper;

  /// No description provided for @layoutRecognition.
  ///
  /// In en, this message translates to:
  /// **'Layout Recognition'**
  String get layoutRecognition;

  /// No description provided for @layoutRecognitionHelper.
  ///
  /// In en, this message translates to:
  /// **'Select layout recognition method'**
  String get layoutRecognitionHelper;

  /// No description provided for @plainText.
  ///
  /// In en, this message translates to:
  /// **'Plain Text'**
  String get plainText;

  /// No description provided for @pageRank.
  ///
  /// In en, this message translates to:
  /// **'Page Rank'**
  String get pageRank;

  /// No description provided for @pageRankHelper.
  ///
  /// In en, this message translates to:
  /// **'Page rank value for search result sorting'**
  String get pageRankHelper;

  /// No description provided for @advancedOptions.
  ///
  /// In en, this message translates to:
  /// **'Advanced Options'**
  String get advancedOptions;

  /// No description provided for @autoKeywordsCount.
  ///
  /// In en, this message translates to:
  /// **'Auto Keywords Extraction Count'**
  String get autoKeywordsCount;

  /// No description provided for @autoKeywordsHelper.
  ///
  /// In en, this message translates to:
  /// **'0 means no extraction'**
  String get autoKeywordsHelper;

  /// No description provided for @autoQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'Auto Questions Extraction Count'**
  String get autoQuestionsCount;

  /// No description provided for @autoQuestionsHelper.
  ///
  /// In en, this message translates to:
  /// **'0 means no extraction'**
  String get autoQuestionsHelper;

  /// No description provided for @tableToHtml.
  ///
  /// In en, this message translates to:
  /// **'Table to HTML'**
  String get tableToHtml;

  /// No description provided for @tableToHtmlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Convert Excel tables to HTML format'**
  String get tableToHtmlSubtitle;

  /// No description provided for @useRaptor.
  ///
  /// In en, this message translates to:
  /// **'Use RAPTOR Strategy for Enhanced Recall'**
  String get useRaptor;

  /// No description provided for @useRaptorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable RAPTOR strategy to enhance recall effect'**
  String get useRaptorSubtitle;

  /// No description provided for @extractKnowledgeGraph.
  ///
  /// In en, this message translates to:
  /// **'Extract Knowledge Graph'**
  String get extractKnowledgeGraph;

  /// No description provided for @extractKnowledgeGraphSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable knowledge graph extraction'**
  String get extractKnowledgeGraphSubtitle;

  /// No description provided for @saveConfig.
  ///
  /// In en, this message translates to:
  /// **'Save Config'**
  String get saveConfig;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Save successful'**
  String get saveSuccess;

  /// No description provided for @fileManagement.
  ///
  /// In en, this message translates to:
  /// **'File Management'**
  String get fileManagement;

  /// No description provided for @rootDirectory.
  ///
  /// In en, this message translates to:
  /// **'Root Directory'**
  String get rootDirectory;

  /// No description provided for @currentFolder.
  ///
  /// In en, this message translates to:
  /// **'Current Folder'**
  String get currentFolder;

  /// No description provided for @searchFiles.
  ///
  /// In en, this message translates to:
  /// **'Search files...'**
  String get searchFiles;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @cannotOpenPreview.
  ///
  /// In en, this message translates to:
  /// **'Cannot open preview: {url}'**
  String cannotOpenPreview(String url);

  /// No description provided for @previewFailed.
  ///
  /// In en, this message translates to:
  /// **'Preview failed: {error}'**
  String previewFailed(String error);

  /// No description provided for @confirmDeleteFile.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String confirmDeleteFile(String name);

  /// No description provided for @totalFiles.
  ///
  /// In en, this message translates to:
  /// **'Total {count} files'**
  String totalFiles(int count);

  /// No description provided for @unnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get unnamed;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed: {error}'**
  String loadFailed(String error);

  /// No description provided for @totalAgents.
  ///
  /// In en, this message translates to:
  /// **'Total {count} agents'**
  String totalAgents(int count);

  /// No description provided for @searchAgents.
  ///
  /// In en, this message translates to:
  /// **'Search Agents...'**
  String get searchAgents;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @createNewDialog.
  ///
  /// In en, this message translates to:
  /// **'Create New Dialog'**
  String get createNewDialog;

  /// No description provided for @dialogName.
  ///
  /// In en, this message translates to:
  /// **'Dialog Name'**
  String get dialogName;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get descriptionOptional;

  /// No description provided for @noDialogs.
  ///
  /// In en, this message translates to:
  /// **'No dialogs'**
  String get noDialogs;

  /// No description provided for @selectKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Select Knowledge Base:'**
  String get selectKnowledgeBase;

  /// No description provided for @pleaseSelectAtLeastOneKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one knowledge base'**
  String get pleaseSelectAtLeastOneKnowledgeBase;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter question...'**
  String get enterQuestion;

  /// No description provided for @ask.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get ask;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer:'**
  String get answer;

  /// No description provided for @relatedFiles.
  ///
  /// In en, this message translates to:
  /// **'Related Files:'**
  String get relatedFiles;

  /// No description provided for @relatedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Related Questions:'**
  String get relatedQuestions;

  /// No description provided for @pleaseSelectKnowledgeBaseAndEnterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Please select knowledge base and enter question for search'**
  String get pleaseSelectKnowledgeBaseAndEnterQuestion;

  /// No description provided for @loadKnowledgeBaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load knowledge base: {error}'**
  String loadKnowledgeBaseFailed(String error);

  /// No description provided for @askQuestionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to ask question: {error}'**
  String askQuestionFailed(String error);

  /// No description provided for @exampleProduction.
  ///
  /// In en, this message translates to:
  /// **'e.g., Production'**
  String get exampleProduction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
