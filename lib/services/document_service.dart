import '../models/document.dart';
import 'api_client.dart';

class DocumentService {
  static const String documentListEndpoint = '/v1/document/list';
  static const String documentDetailEndpoint = '/v1/document/get';
  static const String documentDeleteEndpoint = '/v1/document/rm';
  static const String documentDownloadEndpoint = '/v1/document/download';

  /// 获取文档列表
  static Future<DocumentListResult> getDocumentList({
    required String kbId,
    String keywords = '',
    int page = 1,
    int pageSize = 10,
  }) async {
    final queryParams = {
      'kb_id': kbId,
      if (keywords.isNotEmpty) 'keywords': keywords,
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };

    final response = await ApiClient.post(
      '$documentListEndpoint?${Uri(queryParameters: queryParams).query}',
      body: {},
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return DocumentListResult.fromJson(data);
      }
    }
    return DocumentListResult(documents: [], total: 0);
  }

  /// 删除文档
  static Future<bool> deleteDocument(String id) async {
    final response = await ApiClient.post(
      documentDeleteEndpoint,
      body: {'id': id},
    );
    return response.success;
  }

  /// 获取文档详情
  static Future<Document?> getDocumentDetail(String id) async {
    final response = await ApiClient.get('$documentDetailEndpoint?id=$id');
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return Document.fromJson(data);
      }
    }
    return null;
  }

  /// 获取文档下载 URL
  static String getDownloadUrl(String documentId) {
    return '${ApiClient.baseUrl}$documentDownloadEndpoint/$documentId';
  }
}

/// 文档列表结果
class DocumentListResult {
  final List<Document> documents;
  final int total;

  DocumentListResult({
    required this.documents,
    required this.total,
  });

  factory DocumentListResult.fromJson(Map<String, dynamic> json) {
    return DocumentListResult(
      documents: (json['docs'] as List<dynamic>?)
              ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}
