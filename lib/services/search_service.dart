import 'api_client.dart';

class SearchService {
  static const String searchListEndpoint = '/v1/search/list';
  static const String createSearchEndpoint = '/v1/search/create';
  static const String deleteSearchEndpoint = '/v1/search/rm';
  static const String searchDetailEndpoint = '/v1/search/detail';
  static const String updateSearchEndpoint = '/v1/search/update';

  static Future<List<Map<String, dynamic>>> getSearchList() async {
    final response = await ApiClient.get(searchListEndpoint);
    if (response.success && response.data != null) {
      final data = response.data!['data'] as List<dynamic>?;
      if (data != null) {
        return data.cast<Map<String, dynamic>>();
      }
    }
    return [];
  }

  static Future<bool> createSearch({
    required String name,
    required List<String> kbIds,
  }) async {
    final response = await ApiClient.post(
      createSearchEndpoint,
      body: {
        'name': name,
        'kb_ids': kbIds,
      },
    );
    return response.success;
  }

  static Future<bool> deleteSearch(String id) async {
    final response = await ApiClient.post(
      deleteSearchEndpoint,
      body: {'id': id},
    );
    return response.success;
  }
}
