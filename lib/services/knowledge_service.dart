import '../models/knowledge_base.dart';
import 'api_client.dart';

class KnowledgeService {
  static const String kbListEndpoint = '/v1/kb/list';
  static const String createKbEndpoint = '/v1/kb/create';
  static const String updateKbEndpoint = '/v1/kb/update';
  static const String deleteKbEndpoint = '/v1/kb/rm';
  static const String kbDetailEndpoint = '/v1/kb/detail';

  static Future<List<KnowledgeBase>> getKnowledgeBaseList({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await ApiClient.post(
      kbListEndpoint,
      body: {
        'page': page,
        'page_size': pageSize,
      },
    );
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        final items = data['kbs'] as List<dynamic>?;
        if (items != null) {
          return items
              .map((e) => KnowledgeBase.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    }
    return [];
  }

  static Future<String?> createKnowledgeBase({
    required String name,
    String? description,
    String language = 'Chinese',
    String embeddingModel = '',
  }) async {
    final response = await ApiClient.post(
      createKbEndpoint,
      body: {
        'name': name,
        if (description != null) 'description': description,
        'language': language,
        if (embeddingModel.isNotEmpty) 'embedding_model': embeddingModel,
      },
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null && data.containsKey('kb_id')) {
        return data['kb_id'] as String;
      }
    }
    return null;
  }

  static Future<bool> updateKnowledgeBase({
    required String id,
    String? name,
    String? description,
    String? parserId,
    String? permission,
    String? embdId,
    String? language,
    String? avatar,
    Map<String, dynamic>? parserConfig,
    int? pagerank,
    List<String>? tagKbIds,
  }) async {
    final body = <String, dynamic>{
      'kb_id': id, // API 要求使用 kb_id 而不是 id
      'name': name ?? '',
      'description': description ?? '',
      'parser_id': parserId ?? 'naive', // parser_id 是必填的
    };

    if (permission != null) {
      body['permission'] = permission;
    }
    if (embdId != null) {
      body['embd_id'] = embdId;
    }
    if (language != null) {
      body['language'] = language;
    }
    if (avatar != null) {
      body['avatar'] = avatar;
    }
    if (parserConfig != null) {
      body['parser_config'] = parserConfig;
    }
    if (pagerank != null) {
      body['pagerank'] = pagerank;
    }
    if (tagKbIds != null) {
      body['tag_kb_ids'] = tagKbIds;
    }

    final response = await ApiClient.post(
      updateKbEndpoint,
      body: body,
    );
    return response.success;
  }

  static Future<bool> deleteKnowledgeBase(String id) async {
    final response = await ApiClient.post(
      deleteKbEndpoint,
      body: {'id': id},
    );
    return response.success;
  }

  static Future<KnowledgeBase?> getKnowledgeBaseDetail(String id) async {
    final response = await ApiClient.get('$kbDetailEndpoint?kb_id=$id');
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return KnowledgeBase.fromJson(data);
      }
    }
    return null;
  }
}
