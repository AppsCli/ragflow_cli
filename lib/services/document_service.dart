import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/document.dart';
import 'api_client.dart';

class DocumentService {
  static const String documentListEndpoint = '/v1/document/list';
  static const String documentDetailEndpoint = '/v1/document/get';
  static const String documentDeleteEndpoint = '/v1/document/rm';
  static const String documentDownloadEndpoint = '/v1/document/download';
  static const String documentUploadEndpoint = '/v1/document/upload';
  static const String documentRunEndpoint = '/v1/document/run';

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

  /// 上传文档到知识库
  /// [kbId] - 知识库ID
  /// [file] - 要上传的文件
  static Future<List<Document>?> uploadDocument(String kbId, File file) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}$documentUploadEndpoint');
      
      // 构建请求头
      final headers = <String, String>{};
      final token = ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
      
      // 创建 multipart 请求
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      
      // 添加文件
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );
      
      // 添加 kb_id
      request.fields['kb_id'] = kbId;
      
      // 发送请求
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // 解析响应
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['code'] == 0 && data['data'] != null) {
          final docs = data['data'] as List<dynamic>;
          return docs.map((e) => Document.fromJson(e as Map<String, dynamic>)).toList();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 下载文档
  /// [documentId] - 文档ID
  /// 返回文件的字节数据
  static Future<Uint8List?> downloadDocument(String documentId) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}$documentDownloadEndpoint/$documentId');
      
      // 构建请求头
      final headers = <String, String>{};
      final token = ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 解析文档（触发文档解析）
  /// [docIds] - 文档ID列表
  /// [run] - 运行状态：1 表示开始解析，0 表示停止
  /// [shouldDelete] - 是否删除旧的分块数据
  static Future<bool> runDocument({
    required List<String> docIds,
    int run = 1,
    bool shouldDelete = false,
  }) async {
    final response = await ApiClient.post(
      documentRunEndpoint,
      body: {
        'doc_ids': docIds,
        'run': run.toString(),
        if (shouldDelete) 'delete': true,
      },
    );
    return response.success;
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
