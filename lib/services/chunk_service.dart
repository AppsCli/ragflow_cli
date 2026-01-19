import '../models/search_result.dart';
import 'api_client.dart';

class ChunkService {
  static const String retrievalTestEndpoint = '/v1/chunk/retrieval_test';

  /// 检索测试 - 获取相关文件
  static Future<RetrievalTestResult> retrievalTest({
    required List<String> kbIds,
    required String question,
    int page = 1,
    int size = 30,
    List<String>? docIds,
    bool highlight = false,
    String? searchId,
  }) async {
    final response = await ApiClient.post(
      retrievalTestEndpoint,
      body: {
        'kb_id': kbIds.length == 1 ? kbIds[0] : kbIds,
        'question': question,
        'page': page,
        'size': size,
        if (docIds != null && docIds.isNotEmpty) 'doc_ids': docIds,
        if (highlight) 'highlight': highlight,
        if (searchId != null) 'search_id': searchId,
      },
    );
    print("${response.code}, ${response.success},${response.data}");
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return RetrievalTestResult.fromJson(data);
      }
    }
    return RetrievalTestResult(chunks: [], documents: [], total: 0);
  }
}
