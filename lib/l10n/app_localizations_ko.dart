// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'RAGFlow';

  @override
  String get login => '로그인';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get serverSettings => '서버 설정';

  @override
  String get addServer => '서버 추가';

  @override
  String get serverName => '서버 이름 (선택사항)';

  @override
  String get serverAddress => '서버 주소';

  @override
  String get exampleServerAddress => '예: http://192.168.1.100:9380';

  @override
  String get activate => '활성화';

  @override
  String get delete => '삭제';

  @override
  String get active => '활성';

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String deleteServerConfirm(String serverName) {
    return '서버 \"$serverName\"을(를) 삭제하시겠습니까?';
  }

  @override
  String switchServerConfirm(String serverName) {
    return '서버 \"$serverName\"(으)로 전환하면 다시 로그인해야 합니다. 계속하시겠습니까?';
  }

  @override
  String currentServer(String serverAddress) {
    return '현재 서버: $serverAddress';
  }

  @override
  String get serverAdded => '서버가 추가되었습니다';

  @override
  String get serverDeleted => '서버가 삭제되었습니다';

  @override
  String get switchFailed => '전환 실패';

  @override
  String get addFailed => '추가 실패, 주소 형식을 확인하세요';

  @override
  String get saveFailed => '저장 실패';

  @override
  String get serverAddressRequired => '서버 주소를 입력하세요';

  @override
  String get serverAddressFormatError => '주소는 http:// 또는 https://로 시작해야 합니다';

  @override
  String get serverList => '서버 목록';

  @override
  String get noServerConfig => '서버 설정 없음';

  @override
  String get addServerHint => '아래 버튼을 눌러 서버를 추가하세요';

  @override
  String get systemVersion => 'RAGFlow 버전';

  @override
  String get systemStatus => '시스템 상태';

  @override
  String get refresh => '새로고침';

  @override
  String get cannotGetSystemStatus => '시스템 상태를 가져올 수 없습니다';

  @override
  String get serverAddressHint =>
      '서버 주소는 전체 URL이어야 합니다. 예:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com';

  @override
  String get documentEngine => '문서 엔진';

  @override
  String get storage => '스토리지';

  @override
  String get database => '데이터베이스';

  @override
  String get redis => 'Redis';

  @override
  String get normal => '정상';

  @override
  String get abnormal => '이상';

  @override
  String get unknown => '알 수 없음';

  @override
  String responseTime(String elapsed) {
    return '응답 시간: ${elapsed}ms';
  }

  @override
  String type(String type) {
    return '유형';
  }

  @override
  String storageInfo(String storage) {
    return '스토리지: $storage';
  }

  @override
  String databaseInfo(String database) {
    return '데이터베이스: $database';
  }

  @override
  String error(String error) {
    return '오류: $error';
  }

  @override
  String get language => '언어';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get followSystem => '시스템 따라가기';

  @override
  String get theme => '테마';

  @override
  String get themeSettings => '테마 설정';

  @override
  String get colorSchemeBlue => '파란색';

  @override
  String get colorSchemeGreen => '초록색';

  @override
  String get colorSchemePurple => '보라색';

  @override
  String get colorSchemeOrange => '주황색';

  @override
  String get colorSchemeRed => '빨간색';

  @override
  String get colorSchemeTeal => '청록색';

  @override
  String get colorSchemePink => '분홍색';

  @override
  String get colorSchemeIndigo => '남색';

  @override
  String get colorSchemeBrown => '갈색';

  @override
  String get colorSchemeCyan => '시안';

  @override
  String get chinese => '중국어';

  @override
  String get english => '영어';

  @override
  String get traditionalChinese => '번체 중국어';

  @override
  String get japanese => '일본어';

  @override
  String get korean => '한국어';

  @override
  String get german => '독일어';

  @override
  String get spanish => '스페인어';

  @override
  String get french => '프랑스어';

  @override
  String get italian => '이탈리아어';

  @override
  String get russian => '러시아어';

  @override
  String get arabic => '아랍어';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get account => '계정';

  @override
  String get changePassword => '비밀번호 변경';

  @override
  String get logout => '로그아웃';

  @override
  String get confirmLogout => '로그아웃하시겠습니까?';

  @override
  String get currentPassword => '현재 비밀번호';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get confirmNewPassword => '새 비밀번호 확인';

  @override
  String get passwordChanged => '비밀번호가 변경되었습니다';

  @override
  String get passwordChangeFailed => '비밀번호 변경 실패, 현재 비밀번호를 확인하세요';

  @override
  String get passwordRequired => '비밀번호를 입력하세요';

  @override
  String get newPasswordRequired => '새 비밀번호를 입력하세요';

  @override
  String get confirmPasswordRequired => '새 비밀번호를 확인하세요';

  @override
  String get passwordTooShort => '비밀번호는 8자 이상이어야 합니다';

  @override
  String get passwordsDoNotMatch => '두 비밀번호가 일치하지 않습니다';

  @override
  String get emailRequired => '이메일을 입력하세요';

  @override
  String get invalidEmail => '유효한 이메일 주소를 입력하세요';

  @override
  String get loginFailed => '로그인 실패, 이메일과 비밀번호를 확인하세요';

  @override
  String get configureServerAddress => '서버 주소 설정';

  @override
  String get pleaseConfigureServer => '로그인 전에 서버 주소를 설정하세요';

  @override
  String get goToSettings => '설정으로 이동';

  @override
  String get setServerAddress => '서버 주소 설정';

  @override
  String get knowledgeBase => '지식 베이스';

  @override
  String get chat => '채팅';

  @override
  String get search => '검색';

  @override
  String get agent => '에이전트';

  @override
  String get file => '파일';

  @override
  String get noData => '데이터 없음';

  @override
  String get loading => '로딩 중...';

  @override
  String get retry => '재시도';

  @override
  String get create => '만들기';

  @override
  String get edit => '편집';

  @override
  String get name => '이름';

  @override
  String get description => '설명';

  @override
  String get status => '상태';

  @override
  String get actions => '작업';

  @override
  String get details => '세부정보';

  @override
  String get back => '뒤로';

  @override
  String get submit => '제출';

  @override
  String get close => '닫기';

  @override
  String get searchPlaceholder => '검색...';

  @override
  String get noResults => '결과 없음';

  @override
  String get upload => '업로드';

  @override
  String get download => '다운로드';

  @override
  String get view => '보기';

  @override
  String get createdAt => '생성일';

  @override
  String get updatedAt => '수정일';

  @override
  String get size => '크기';

  @override
  String get operation => '작업';

  @override
  String get success => '성공';

  @override
  String get failed => '실패';

  @override
  String get pleaseWait => '잠시만 기다려 주세요...';

  @override
  String get areYouSure => '확인하시겠습니까?';

  @override
  String get deleteConfirm => '이 항목을 삭제하시겠습니까?';

  @override
  String get operationSuccess => '작업이 완료되었습니다';

  @override
  String get operationFailed => '작업 실패';

  @override
  String get networkError => '네트워크 오류, 연결을 확인하세요';

  @override
  String get unknownError => '알 수 없는 오류가 발생했습니다';

  @override
  String get createKnowledgeBase => '지식 베이스 만들기';

  @override
  String get knowledgeBaseName => '지식 베이스 이름';

  @override
  String get enterKnowledgeBaseName => '지식 베이스 이름을 입력하세요';

  @override
  String get loadingFailed => '로딩 실패';

  @override
  String get creating => '만드는 중...';

  @override
  String get createSuccess => '생성되었습니다';

  @override
  String get createFailed => '생성 실패, 다시 시도하세요';

  @override
  String get noKnowledgeBase => '지식 베이스 없음';

  @override
  String get documents => '문서';

  @override
  String get chunks => '청크';

  @override
  String get updated => '업데이트됨';

  @override
  String get send => '보내기';

  @override
  String get enterMessage => '메시지 입력...';

  @override
  String get noChatHistory => '대화 기록 없음';

  @override
  String get newChat => '새 채팅';

  @override
  String get clear => '지우기';

  @override
  String get noAgents => '에이전트 없음';

  @override
  String get createAgent => '에이전트 만들기';

  @override
  String get noFiles => '파일 없음';

  @override
  String get uploadFile => '파일 업로드';

  @override
  String get fileName => '파일 이름';

  @override
  String get fileSize => '파일 크기';

  @override
  String get uploadTime => '업로드 시간';

  @override
  String get resetAgent => '에이전트 초기화';

  @override
  String get resetAgentConfirm => '에이전트를 초기화하시겠습니까? 현재 대화 기록이 삭제됩니다.';

  @override
  String get reset => '초기화';

  @override
  String get resetSuccess => '초기화되었습니다';

  @override
  String get resetFailed => '초기화 실패';

  @override
  String get thinking => '생각 중...';

  @override
  String get you => '사용자';

  @override
  String sendFailed(String message) {
    return '전송 실패: $message';
  }

  @override
  String get requestFailed => '요청 실패';

  @override
  String get stop => '중지';

  @override
  String get createNewConversation => '새 대화 만들기';

  @override
  String get conversationName => '대화 이름';

  @override
  String get noConversations => '대화 없음';

  @override
  String get hideList => '목록 숨기기';

  @override
  String get showList => '목록 표시';

  @override
  String get refreshConversationList => '대화 목록 새로고침';

  @override
  String get selectConversation => '대화를 선택하세요';

  @override
  String loadConversationListFailed(String error) {
    return '대화 목록 로드 실패: $error';
  }

  @override
  String get getConversationInfoFailed => '대화 정보를 가져오지 못했습니다';

  @override
  String get knowledgeBaseDetail => '지식 베이스 세부정보';

  @override
  String get dataset => '데이터셋';

  @override
  String get retrievalTest => '검색 테스트';

  @override
  String get config => '설정';

  @override
  String get searchDocuments => '문서 검색...';

  @override
  String get noDocuments => '문서 없음';

  @override
  String get tokens => '토큰';

  @override
  String get update => '업데이트';

  @override
  String get detail => '세부정보';

  @override
  String get parse => '파싱';

  @override
  String get cancelParse => '파싱 취소';

  @override
  String get deleteDocument => '문서 삭제';

  @override
  String get confirmDelete => '삭제 확인';

  @override
  String get confirmDeleteDocument => '이 문서를 삭제하시겠습니까?';

  @override
  String get deleteSuccess => '삭제되었습니다';

  @override
  String get deleteFailed => '삭제 실패';

  @override
  String totalDocuments(int count) {
    return '총 $count개 문서';
  }

  @override
  String get previousPage => '이전 페이지';

  @override
  String get nextPage => '다음 페이지';

  @override
  String get id => 'ID';

  @override
  String get suffix => '접미사';

  @override
  String get chunkCount => '청크 수';

  @override
  String get tokenCount => '토큰 수';

  @override
  String get createTime => '생성 시간';

  @override
  String get updateTime => '수정 시간';

  @override
  String get notStarted => '시작 안 함';

  @override
  String get parsing => '파싱 중';

  @override
  String get cancelled => '취소됨';

  @override
  String get completed => '완료';

  @override
  String get downloading => '다운로드 중...';

  @override
  String downloadSuccess(String path) {
    return '다운로드 완료: $path';
  }

  @override
  String get downloadFailed => '다운로드 실패';

  @override
  String get startingParse => '파싱 시작 중...';

  @override
  String get parseStarted => '파싱이 시작되었습니다';

  @override
  String get startParseFailed => '파싱 시작 실패';

  @override
  String get confirmCancel => '취소 확인';

  @override
  String confirmCancelParse(String name) {
    return '문서 \"$name\" 파싱을 취소하시겠습니까?';
  }

  @override
  String get cancellingParse => '파싱 취소 중...';

  @override
  String get parseCancelled => '파싱이 취소되었습니다';

  @override
  String get cancelParseFailed => '파싱 취소 실패';

  @override
  String get uploading => '업로드 중...';

  @override
  String get uploadSuccess => '업로드 완료, 파싱 시작 중...';

  @override
  String get uploadFailed => '업로드 실패';

  @override
  String get partialUploadFailed => '일부 파일 업로드 실패';

  @override
  String loadDocumentsFailed(String error) {
    return '문서 로드 실패: $error';
  }

  @override
  String get enterQuestionForRetrieval => '검색 테스트용 질문 입력...';

  @override
  String get test => '테스트';

  @override
  String get retrieving => '검색 중...';

  @override
  String get enterQuestionForRetrievalTest => '검색 테스트용 질문을 입력하세요';

  @override
  String retrievalResults(int count) {
    return '검색 결과 (총 $count건)';
  }

  @override
  String similarity(String percent) {
    return '유사도: $percent%';
  }

  @override
  String retrievalTestFailed(String error) {
    return '검색 테스트 실패: $error';
  }

  @override
  String get basicInfo => '기본 정보';

  @override
  String get knowledgeBaseNameRequired => '지식 베이스 이름을 입력하세요';

  @override
  String get knowledgeBaseImage => '지식 베이스 이미지';

  @override
  String get uploadImage => '이미지 업로드';

  @override
  String get imageSelected => '이미지 선택됨';

  @override
  String get fileNotExists => '파일이 없습니다';

  @override
  String get selectImageSource => '이미지 소스 선택';

  @override
  String get selectFromGallery => '갤러리에서 선택';

  @override
  String get takePhoto => '사진 촬영';

  @override
  String get imageTooLarge => '이미지 크기는 4MB를 초과할 수 없습니다';

  @override
  String selectImageFailed(String error) {
    return '이미지 선택 실패: $error';
  }

  @override
  String get permission => '권한';

  @override
  String get permissionOnlyMe => '나만';

  @override
  String get permissionTeam => '팀';

  @override
  String get documentLanguage => '문서 언어';

  @override
  String get languageChinese => '중국어';

  @override
  String get languageEnglish => '영어';

  @override
  String get parserNaive => '일반';

  @override
  String get parserQa => 'Q&A';

  @override
  String get parserResume => '이력서';

  @override
  String get parserManual => '수동';

  @override
  String get parserTable => '표';

  @override
  String get parserPaper => '논문';

  @override
  String get parserBook => '책';

  @override
  String get parserLaws => '법률';

  @override
  String get parserPresentation => '프레젠테이션';

  @override
  String get parserPicture => '이미지';

  @override
  String get parserOne => '한 페이지';

  @override
  String get parserAudio => '오디오';

  @override
  String get parserEmail => '이메일';

  @override
  String get parserTag => '태그';

  @override
  String get parserKnowledgeGraph => '지식 그래프';

  @override
  String get parseConfig => '파싱 설정';

  @override
  String get sliceMethod => '슬라이스 방법(파서)';

  @override
  String get sliceMethodHelper => '문서 파싱 및 슬라이싱 방법 선택';

  @override
  String get embeddingModel => '임베딩 모델';

  @override
  String get embeddingModelHelper => '임베딩 벡터 생성용 모델 선택';

  @override
  String get embeddingModelWarning =>
      '참고: 청크가 있을 때 임베딩 모델 변경 시 모든 청크를 삭제해야 합니다';

  @override
  String get noModelsAvailable => '사용 가능한 모델 없음';

  @override
  String get suggestedChunkSize => '권장 청크 크기(토큰 수)';

  @override
  String get chunkSizeHelper => '청크 생성용 토큰 임계값 설정';

  @override
  String get textDelimiter => '텍스트 구분자';

  @override
  String get delimiterHelper => '텍스트 분할용 구분자, 예: \\n';

  @override
  String get layoutRecognition => '레이아웃 인식';

  @override
  String get layoutRecognitionHelper => '레이아웃 인식 방법 선택';

  @override
  String get plainText => '일반 텍스트';

  @override
  String get pageRank => '페이지 순위';

  @override
  String get pageRankHelper => '검색 결과 정렬용 페이지 순위 값';

  @override
  String get advancedOptions => '고급 옵션';

  @override
  String get autoKeywordsCount => '자동 키워드 추출 수';

  @override
  String get autoKeywordsHelper => '0은 추출 안 함';

  @override
  String get autoQuestionsCount => '자동 질문 추출 수';

  @override
  String get autoQuestionsHelper => '0은 추출 안 함';

  @override
  String get tableToHtml => '표를 HTML로';

  @override
  String get tableToHtmlSubtitle => 'Excel 표를 HTML 형식으로 변환';

  @override
  String get useRaptor => 'RAPTOR 전략으로 검색 향상';

  @override
  String get useRaptorSubtitle => 'RAPTOR 전략 사용으로 검색 효과 향상';

  @override
  String get extractKnowledgeGraph => '지식 그래프 추출';

  @override
  String get extractKnowledgeGraphSubtitle => '지식 그래프 추출 사용';

  @override
  String get saveConfig => '설정 저장';

  @override
  String get saveSuccess => '저장되었습니다';

  @override
  String get fileManagement => '파일 관리';

  @override
  String get rootDirectory => '루트 디렉토리';

  @override
  String get currentFolder => '현재 폴더';

  @override
  String get searchFiles => '파일 검색...';

  @override
  String get folder => '폴더';

  @override
  String get preview => '미리보기';

  @override
  String cannotOpenPreview(String url) {
    return '미리보기를 열 수 없습니다: $url';
  }

  @override
  String previewFailed(String error) {
    return '미리보기 실패: $error';
  }

  @override
  String confirmDeleteFile(String name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String totalFiles(int count) {
    return '총 $count개 파일';
  }

  @override
  String get unnamed => '이름 없음';

  @override
  String loadFailed(String error) {
    return '로드 실패: $error';
  }

  @override
  String totalAgents(int count) {
    return '총 $count개 에이전트';
  }

  @override
  String get searchAgents => '에이전트 검색...';

  @override
  String get noDescription => '설명 없음';

  @override
  String get createNewDialog => '새 대화 만들기';

  @override
  String get dialogName => '대화 이름';

  @override
  String get descriptionOptional => '설명 (선택사항)';

  @override
  String get noDialogs => '대화 없음';

  @override
  String get selectKnowledgeBase => '지식 베이스 선택:';

  @override
  String get pleaseSelectAtLeastOneKnowledgeBase => '최소 하나의 지식 베이스를 선택하세요';

  @override
  String get enterQuestion => '질문 입력...';

  @override
  String get ask => '질문';

  @override
  String get answer => '답변:';

  @override
  String get relatedFiles => '관련 파일:';

  @override
  String get relatedQuestions => '관련 질문:';

  @override
  String get pleaseSelectKnowledgeBaseAndEnterQuestion =>
      '지식 베이스를 선택하고 검색할 질문을 입력하세요';

  @override
  String loadKnowledgeBaseFailed(String error) {
    return '지식 베이스 로드 실패: $error';
  }

  @override
  String askQuestionFailed(String error) {
    return '질문 실패: $error';
  }

  @override
  String get exampleProduction => '예: 프로덕션';

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
