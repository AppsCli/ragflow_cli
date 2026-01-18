import 'api_client.dart';

class AgentService {
  static const String agentListEndpoint = '/v1/canvas/list';
  static const String createAgentEndpoint = '/v1/canvas/set';
  static const String deleteAgentEndpoint = '/v1/canvas/rm';
  static const String agentDetailEndpoint = '/v1/canvas/get';

  static Future<List<Map<String, dynamic>>> getAgentList() async {
    final response = await ApiClient.get(agentListEndpoint);
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        final items = data['items'] as List<dynamic>?;
        if (items != null) {
          return items.cast<Map<String, dynamic>>();
        }
      }
    }
    return [];
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
