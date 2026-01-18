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
    print(response.data);
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

  static Future<KnowledgeBase?> createKnowledgeBase({
    required String name,
    String? description,
    String language = 'Chinese',
    String embeddingModel = '',
  }) async {
    final response = await ApiClient.post(
      createKbEndpoint,
      body: {
        'name': name,
        'description': description,
        'language': language,
        'embedding_model': embeddingModel,
      },
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return KnowledgeBase.fromJson(data);
      }
    }
    return null;
  }

  static Future<bool> updateKnowledgeBase({
    required String id,
    String? name,
    String? description,
  }) async {
    final response = await ApiClient.post(
      updateKbEndpoint,
      body: {
        'id': id,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      },
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
    final response = await ApiClient.get('$kbDetailEndpoint?id=$id');
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return KnowledgeBase.fromJson(data);
      }
    }
    return null;
  }
}
