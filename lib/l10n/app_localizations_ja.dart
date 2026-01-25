// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'RAGFlow';

  @override
  String get login => 'ログイン';

  @override
  String get email => 'メール';

  @override
  String get password => 'パスワード';

  @override
  String get serverSettings => 'サーバー設定';

  @override
  String get addServer => 'サーバーを追加';

  @override
  String get serverName => 'サーバー名（任意）';

  @override
  String get serverAddress => 'サーバーアドレス';

  @override
  String get exampleServerAddress => '例: http://192.168.1.100:9380';

  @override
  String get activate => '有効化';

  @override
  String get delete => '削除';

  @override
  String get active => '有効';

  @override
  String get confirm => '確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String deleteServerConfirm(String serverName) {
    return 'サーバー「$serverName」を削除してもよろしいですか？';
  }

  @override
  String switchServerConfirm(String serverName) {
    return 'サーバー「$serverName」に切り替えると再ログインが必要です。続行しますか？';
  }

  @override
  String currentServer(String serverAddress) {
    return '現在のサーバー: $serverAddress';
  }

  @override
  String get serverAdded => 'サーバーを追加しました';

  @override
  String get serverDeleted => 'サーバーを削除しました';

  @override
  String get switchFailed => '切り替えに失敗しました';

  @override
  String get addFailed => '追加に失敗しました。アドレス形式を確認してください';

  @override
  String get saveFailed => '保存に失敗しました';

  @override
  String get serverAddressRequired => 'サーバーアドレスを入力してください';

  @override
  String get serverAddressFormatError =>
      'アドレスは http:// または https:// で始める必要があります';

  @override
  String get serverList => 'サーバー一覧';

  @override
  String get noServerConfig => 'サーバー設定がありません';

  @override
  String get addServerHint => '下のボタンをクリックしてサーバーを追加';

  @override
  String get systemVersion => 'RAGFlow バージョン';

  @override
  String get systemStatus => 'システム状態';

  @override
  String get refresh => '更新';

  @override
  String get cannotGetSystemStatus => 'システム状態を取得できません';

  @override
  String get serverAddressHint =>
      'サーバーアドレスは完全なURLにしてください。例:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com';

  @override
  String get documentEngine => 'ドキュメントエンジン';

  @override
  String get storage => 'ストレージ';

  @override
  String get database => 'データベース';

  @override
  String get redis => 'Redis';

  @override
  String get normal => '正常';

  @override
  String get abnormal => '異常';

  @override
  String get unknown => '不明';

  @override
  String responseTime(String elapsed) {
    return '応答時間: ${elapsed}ms';
  }

  @override
  String type(String type) {
    return 'タイプ';
  }

  @override
  String storageInfo(String storage) {
    return 'ストレージ: $storage';
  }

  @override
  String databaseInfo(String database) {
    return 'データベース: $database';
  }

  @override
  String error(String error) {
    return 'エラー: $error';
  }

  @override
  String get language => '言語';

  @override
  String get languageSettings => '言語設定';

  @override
  String get followSystem => 'システムに合わせる';

  @override
  String get theme => 'テーマ';

  @override
  String get themeSettings => 'テーマ設定';

  @override
  String get colorSchemeBlue => '青';

  @override
  String get colorSchemeGreen => '緑';

  @override
  String get colorSchemePurple => '紫';

  @override
  String get colorSchemeOrange => 'オレンジ';

  @override
  String get colorSchemeRed => '赤';

  @override
  String get colorSchemeTeal => 'ティール';

  @override
  String get colorSchemePink => 'ピンク';

  @override
  String get colorSchemeIndigo => 'インディゴ';

  @override
  String get colorSchemeBrown => '茶色';

  @override
  String get colorSchemeCyan => 'シアン';

  @override
  String get chinese => '中国語';

  @override
  String get english => '英語';

  @override
  String get traditionalChinese => '繁体字中国語';

  @override
  String get japanese => '日本語';

  @override
  String get korean => '韓国語';

  @override
  String get german => 'ドイツ語';

  @override
  String get spanish => 'スペイン語';

  @override
  String get french => 'フランス語';

  @override
  String get italian => 'イタリア語';

  @override
  String get russian => 'ロシア語';

  @override
  String get arabic => 'アラビア語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get account => 'アカウント';

  @override
  String get changePassword => 'パスワード変更';

  @override
  String get logout => 'ログアウト';

  @override
  String get confirmLogout => 'ログアウトしますか？';

  @override
  String get currentPassword => '現在のパスワード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get confirmNewPassword => '新しいパスワード（確認）';

  @override
  String get passwordChanged => 'パスワードを変更しました';

  @override
  String get passwordChangeFailed => 'パスワードの変更に失敗しました。現在のパスワードを確認してください';

  @override
  String get passwordRequired => 'パスワードを入力してください';

  @override
  String get newPasswordRequired => '新しいパスワードを入力してください';

  @override
  String get confirmPasswordRequired => '新しいパスワードを確認してください';

  @override
  String get passwordTooShort => 'パスワードは8文字以上にしてください';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get emailRequired => 'メールアドレスを入力してください';

  @override
  String get invalidEmail => '有効なメールアドレスを入力してください';

  @override
  String get loginFailed => 'ログインに失敗しました。メールとパスワードを確認してください';

  @override
  String get configureServerAddress => 'サーバーアドレスを設定';

  @override
  String get pleaseConfigureServer => 'ログインする前にサーバーアドレスを設定してください';

  @override
  String get goToSettings => '設定へ';

  @override
  String get setServerAddress => 'サーバーアドレスを設定';

  @override
  String get knowledgeBase => 'ナレッジベース';

  @override
  String get chat => 'チャット';

  @override
  String get search => '検索';

  @override
  String get agent => 'エージェント';

  @override
  String get file => 'ファイル';

  @override
  String get noData => 'データがありません';

  @override
  String get loading => '読み込み中...';

  @override
  String get retry => '再試行';

  @override
  String get create => '作成';

  @override
  String get edit => '編集';

  @override
  String get name => '名前';

  @override
  String get description => '説明';

  @override
  String get status => '状態';

  @override
  String get actions => '操作';

  @override
  String get details => '詳細';

  @override
  String get back => '戻る';

  @override
  String get submit => '送信';

  @override
  String get close => '閉じる';

  @override
  String get searchPlaceholder => '検索...';

  @override
  String get noResults => '結果がありません';

  @override
  String get upload => 'アップロード';

  @override
  String get download => 'ダウンロード';

  @override
  String get view => '表示';

  @override
  String get createdAt => '作成日時';

  @override
  String get updatedAt => '更新日時';

  @override
  String get size => 'サイズ';

  @override
  String get operation => '操作';

  @override
  String get success => '成功';

  @override
  String get failed => '失敗';

  @override
  String get pleaseWait => 'お待ちください...';

  @override
  String get areYouSure => 'よろしいですか？';

  @override
  String get deleteConfirm => 'この項目を削除しますか？';

  @override
  String get operationSuccess => '操作が完了しました';

  @override
  String get operationFailed => '操作に失敗しました';

  @override
  String get networkError => 'ネットワークエラー。接続を確認してください';

  @override
  String get unknownError => '不明なエラーが発生しました';

  @override
  String get createKnowledgeBase => 'ナレッジベースを作成';

  @override
  String get knowledgeBaseName => 'ナレッジベース名';

  @override
  String get enterKnowledgeBaseName => 'ナレッジベース名を入力してください';

  @override
  String get loadingFailed => '読み込みに失敗しました';

  @override
  String get creating => '作成中...';

  @override
  String get createSuccess => '作成しました';

  @override
  String get createFailed => '作成に失敗しました。もう一度お試しください';

  @override
  String get noKnowledgeBase => 'ナレッジベースがありません';

  @override
  String get documents => 'ドキュメント';

  @override
  String get chunks => 'チャンク';

  @override
  String get updated => '更新';

  @override
  String get send => '送信';

  @override
  String get enterMessage => 'メッセージを入力...';

  @override
  String get noChatHistory => 'チャット履歴がありません';

  @override
  String get newChat => '新しいチャット';

  @override
  String get clear => 'クリア';

  @override
  String get noAgents => 'エージェントがありません';

  @override
  String get createAgent => 'エージェントを作成';

  @override
  String get noFiles => 'ファイルがありません';

  @override
  String get uploadFile => 'ファイルをアップロード';

  @override
  String get fileName => 'ファイル名';

  @override
  String get fileSize => 'ファイルサイズ';

  @override
  String get uploadTime => 'アップロード日時';

  @override
  String get resetAgent => 'エージェントをリセット';

  @override
  String get resetAgentConfirm => 'エージェントをリセットしますか？現在の会話履歴が削除されます。';

  @override
  String get reset => 'リセット';

  @override
  String get resetSuccess => 'リセットしました';

  @override
  String get resetFailed => 'リセットに失敗しました';

  @override
  String get thinking => '考え中...';

  @override
  String get you => 'あなた';

  @override
  String sendFailed(String message) {
    return '送信に失敗しました: $message';
  }

  @override
  String get requestFailed => 'リクエストに失敗しました';

  @override
  String get stop => '停止';

  @override
  String get createNewConversation => '新しい会話を作成';

  @override
  String get conversationName => '会話名';

  @override
  String get noConversations => '会話がありません';

  @override
  String get hideList => 'リストを隠す';

  @override
  String get showList => 'リストを表示';

  @override
  String get refreshConversationList => '会話リストを更新';

  @override
  String get selectConversation => '会話を選択してください';

  @override
  String loadConversationListFailed(String error) {
    return '会話リストの読み込みに失敗しました: $error';
  }

  @override
  String get getConversationInfoFailed => '会話情報の取得に失敗しました';

  @override
  String get knowledgeBaseDetail => 'ナレッジベース詳細';

  @override
  String get dataset => 'データセット';

  @override
  String get retrievalTest => '検索テスト';

  @override
  String get config => '設定';

  @override
  String get searchDocuments => 'ドキュメントを検索...';

  @override
  String get noDocuments => 'ドキュメントがありません';

  @override
  String get tokens => 'トークン';

  @override
  String get update => '更新';

  @override
  String get detail => '詳細';

  @override
  String get parse => '解析';

  @override
  String get cancelParse => '解析をキャンセル';

  @override
  String get deleteDocument => 'ドキュメントを削除';

  @override
  String get confirmDelete => '削除の確認';

  @override
  String get confirmDeleteDocument => 'このドキュメントを削除しますか？';

  @override
  String get deleteSuccess => '削除しました';

  @override
  String get deleteFailed => '削除に失敗しました';

  @override
  String totalDocuments(int count) {
    return '合計 $count 件のドキュメント';
  }

  @override
  String get previousPage => '前のページ';

  @override
  String get nextPage => '次のページ';

  @override
  String get id => 'ID';

  @override
  String get suffix => '拡張子';

  @override
  String get chunkCount => 'チャンク数';

  @override
  String get tokenCount => 'トークン数';

  @override
  String get createTime => '作成日時';

  @override
  String get updateTime => '更新日時';

  @override
  String get notStarted => '未開始';

  @override
  String get parsing => '解析中';

  @override
  String get cancelled => 'キャンセル済み';

  @override
  String get completed => '完了';

  @override
  String get downloading => 'ダウンロード中...';

  @override
  String downloadSuccess(String path) {
    return 'ダウンロードしました: $path';
  }

  @override
  String get downloadFailed => 'ダウンロードに失敗しました';

  @override
  String get startingParse => '解析を開始しています...';

  @override
  String get parseStarted => '解析を開始しました';

  @override
  String get startParseFailed => '解析の開始に失敗しました';

  @override
  String get confirmCancel => 'キャンセルの確認';

  @override
  String confirmCancelParse(String name) {
    return 'ドキュメント「$name」の解析をキャンセルしますか？';
  }

  @override
  String get cancellingParse => '解析をキャンセルしています...';

  @override
  String get parseCancelled => '解析をキャンセルしました';

  @override
  String get cancelParseFailed => '解析のキャンセルに失敗しました';

  @override
  String get uploading => 'アップロード中...';

  @override
  String get uploadSuccess => 'アップロードしました。解析を開始しています...';

  @override
  String get uploadFailed => 'アップロードに失敗しました';

  @override
  String get partialUploadFailed => '一部のファイルのアップロードに失敗しました';

  @override
  String loadDocumentsFailed(String error) {
    return 'ドキュメントの読み込みに失敗しました: $error';
  }

  @override
  String get enterQuestionForRetrieval => '検索テスト用の質問を入力...';

  @override
  String get test => 'テスト';

  @override
  String get retrieving => '検索中...';

  @override
  String get enterQuestionForRetrievalTest => '検索テスト用の質問を入力してください';

  @override
  String retrievalResults(int count) {
    return '検索結果（合計 $count 件）';
  }

  @override
  String similarity(String percent) {
    return '類似度: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return '検索テストに失敗しました: $error';
  }

  @override
  String get basicInfo => '基本情報';

  @override
  String get knowledgeBaseNameRequired => 'ナレッジベース名を入力してください';

  @override
  String get knowledgeBaseImage => 'ナレッジベース画像';

  @override
  String get uploadImage => '画像をアップロード';

  @override
  String get imageSelected => '画像を選択しました';

  @override
  String get fileNotExists => 'ファイルが存在しません';

  @override
  String get selectImageSource => '画像の取得元を選択';

  @override
  String get selectFromGallery => 'ギャラリーから選択';

  @override
  String get takePhoto => '写真を撮る';

  @override
  String get imageTooLarge => '画像サイズは4MB以下にしてください';

  @override
  String selectImageFailed(String error) {
    return '画像の選択に失敗しました: $error';
  }

  @override
  String get permission => '権限';

  @override
  String get permissionOnlyMe => '自分のみ';

  @override
  String get permissionTeam => 'チーム';

  @override
  String get documentLanguage => 'ドキュメント言語';

  @override
  String get languageChinese => '中国語';

  @override
  String get languageEnglish => '英語';

  @override
  String get parserNaive => '汎用';

  @override
  String get parserQa => 'Q&A';

  @override
  String get parserResume => '履歴書';

  @override
  String get parserManual => '手動';

  @override
  String get parserTable => '表';

  @override
  String get parserPaper => '論文';

  @override
  String get parserBook => '書籍';

  @override
  String get parserLaws => '法令';

  @override
  String get parserPresentation => 'プレゼン';

  @override
  String get parserPicture => '画像';

  @override
  String get parserOne => '1ページ';

  @override
  String get parserAudio => '音声';

  @override
  String get parserEmail => 'メール';

  @override
  String get parserTag => 'タグ';

  @override
  String get parserKnowledgeGraph => '知識グラフ';

  @override
  String get parseConfig => '解析設定';

  @override
  String get sliceMethod => 'スライス方法（パーサー）';

  @override
  String get sliceMethodHelper => 'ドキュメントの解析・スライス方法を選択';

  @override
  String get embeddingModel => '埋め込みモデル';

  @override
  String get embeddingModelHelper => '埋め込みベクトル生成用モデルを選択';

  @override
  String get embeddingModelWarning =>
      '注意: チャンクがある状態で埋め込みモデルを変更するには、全チャンクの削除が必要です';

  @override
  String get noModelsAvailable => '利用可能なモデルがありません';

  @override
  String get suggestedChunkSize => '推奨チャンクサイズ（トークン数）';

  @override
  String get chunkSizeHelper => 'チャンク作成のトークン閾値を設定';

  @override
  String get textDelimiter => 'テキスト区切り';

  @override
  String get delimiterHelper => 'テキスト分割用の区切り文字（例: \\n）';

  @override
  String get layoutRecognition => 'レイアウト認識';

  @override
  String get layoutRecognitionHelper => 'レイアウト認識方法を選択';

  @override
  String get plainText => 'プレーンテキスト';

  @override
  String get pageRank => 'ページランク';

  @override
  String get pageRankHelper => '検索結果の並び替え用ページランク値';

  @override
  String get advancedOptions => '詳細オプション';

  @override
  String get autoKeywordsCount => '自動キーワード抽出数';

  @override
  String get autoKeywordsHelper => '0は抽出しない';

  @override
  String get autoQuestionsCount => '自動質問抽出数';

  @override
  String get autoQuestionsHelper => '0は抽出しない';

  @override
  String get tableToHtml => '表をHTMLに';

  @override
  String get tableToHtmlSubtitle => 'Excel表をHTML形式に変換';

  @override
  String get useRaptor => 'RAPTOR戦略で検索を強化';

  @override
  String get useRaptorSubtitle => 'RAPTOR戦略を有効にして検索効果を向上';

  @override
  String get extractKnowledgeGraph => '知識グラフを抽出';

  @override
  String get extractKnowledgeGraphSubtitle => '知識グラフ抽出を有効にする';

  @override
  String get saveConfig => '設定を保存';

  @override
  String get saveSuccess => '保存しました';

  @override
  String get fileManagement => 'ファイル管理';

  @override
  String get rootDirectory => 'ルートディレクトリ';

  @override
  String get currentFolder => '現在のフォルダ';

  @override
  String get searchFiles => 'ファイルを検索...';

  @override
  String get folder => 'フォルダ';

  @override
  String get preview => 'プレビュー';

  @override
  String cannotOpenPreview(String url) {
    return 'プレビューを開けません: $url';
  }

  @override
  String previewFailed(String error) {
    return 'プレビューに失敗しました: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String totalFiles(int count) {
    return '合計 $count 件のファイル';
  }

  @override
  String get unnamed => '名前なし';

  @override
  String loadFailed(String error) {
    return '読み込みに失敗しました: $error';
  }

  @override
  String totalAgents(int count) {
    return '合計 $count 件のエージェント';
  }

  @override
  String get searchAgents => 'エージェントを検索...';

  @override
  String get noDescription => '説明なし';

  @override
  String get createNewDialog => '新しいダイアログを作成';

  @override
  String get dialogName => 'ダイアログ名';

  @override
  String get descriptionOptional => '説明（任意）';

  @override
  String get noDialogs => 'ダイアログがありません';

  @override
  String get selectKnowledgeBase => 'ナレッジベースを選択:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase => '1つ以上のナレッジベースを選択してください';

  @override
  String get enterQuestion => '質問を入力...';

  @override
  String get ask => '質問';

  @override
  String get answer => '回答:';

  @override
  String get relatedFiles => '関連ファイル:';

  @override
  String get relatedQuestions => '関連質問:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      'ナレッジベースを選択し、検索する質問を入力してください';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return 'ナレッジベースの読み込みに失敗しました: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return '質問に失敗しました: $error';
  }

  @override
  String get exampleProduction => '例: 本番環境';
}
