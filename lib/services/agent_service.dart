import 'api_client.dart';
import '../models/agent_list_result.dart';

class AgentService {
  static const String agentListEndpoint = '/v1/canvas/listteam';
  static const String createAgentEndpoint = '/v1/canvas/set';
  static const String deleteAgentEndpoint = '/v1/canvas/rm';
  static const String agentDetailEndpoint = '/v1/canvas/get';

  /// 获取Agent列表（支持分页和搜索）
  /// [page] - 页码，从1开始
  /// [pageSize] - 每页数量
  /// [keywords] - 搜索关键词
  static Future<AgentListResult> getAgentList({
    int page = 1,
    int pageSize = 30,
    String keywords = '',
  }) async {
    // 构建查询参数
    final queryParams = <String, String>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
      'keywords': keywords,
    };
    
    // 构建URL，添加查询参数
    final queryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    final url = '$agentListEndpoint?$queryString';
    
    final response = await ApiClient.get(url);
    
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      print(data);
      if (data != null) {
        // 根据web前端，响应格式为: { canvas: [], total: number }
        final canvas = data['kbs'] as List<dynamic>?;
        final total = data['total'] as int? ?? 0;
        
        return AgentListResult(
          agents: canvas?.cast<Map<String, dynamic>>() ?? [],
          total: total,
        );
      }
    }
    
    return AgentListResult(agents: [], total: 0);
  }

  static Future<bool> createAgent({
    required String name,
    Map<String, dynamic>? config,
  }) async {
    final response = await ApiClient.post(
      createAgentEndpoint,
      body: {
        'name': name,
        if (config != null) ...config,
      },
    );
    return response.success;
  }

  static Future<bool> deleteAgent(String id) async {
    final response = await ApiClient.post(
      deleteAgentEndpoint,
      body: {'id': id},
    );
    return response.success;
  }
}
