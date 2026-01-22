import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../models/agent_list_result.dart';

class AgentService {
  static const String agentListEndpoint = '/v1/canvas/listteam';
  static const String createAgentEndpoint = '/v1/canvas/set';
  static const String deleteAgentEndpoint = '/v1/canvas/rm';
  static const String agentDetailEndpoint = '/v1/canvas/get';
  static const String resetAgentEndpoint = '/v1/canvas/reset';
  static const String agentCompletionEndpoint = '/v1/canvas/completion';

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
      // print(data);
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

  /// 获取 Agent 详情
  static Future<Map<String, dynamic>?> getAgentDetail(String id) async {
    final response = await ApiClient.get('$agentDetailEndpoint/$id');
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      return data;
    }
    return null;
  }

  /// 重置 Agent
  static Future<bool> resetAgent(String id) async {
    final response = await ApiClient.post(
      resetAgentEndpoint,
      body: {'id': id},
    );
    return response.success;
  }

  /// Agent 对话完成（SSE 流式响应）
  static Stream<Map<String, dynamic>> agentCompletion({
    required String agentId,
    required String query,
    String? sessionId,
    Map<String, dynamic>? inputs,
    List<dynamic>? files,
  }) async* {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}$agentCompletionEndpoint');
      
      // 构建请求头（与 ApiClient 保持一致）
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      final token = ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
      
      final body = jsonEncode({
        'id': agentId,
        'query': query,
        if (sessionId != null) 'session_id': sessionId,
        if (inputs != null) 'inputs': inputs,
        if (files != null && files.isNotEmpty) 'files': files,
      });

      final request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = body;

      final streamedResponse = await http.Client().send(request);

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        String buffer = '';
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          buffer += chunk;
          
          // 处理完整的 SSE 事件（以 \n\n 分隔），与聊天功能 ChatService.completion 一致
          while (buffer.contains('\n\n')) {
            final index = buffer.indexOf('\n\n');
            final event = buffer.substring(0, index);
            buffer = buffer.substring(index + 2);
            
            if (event.trim().isEmpty) continue;

            // SSE 格式: data:{"code": 0, "message": "", "data": {"answer": "...", "reference": []}}
            // 或 data: {"code": 0, "message": "", "data": true} 表示流结束
            final lines = event.split('\n');
            for (final line in lines) {
              final trimmedLine = line.trim();
              if (trimmedLine.isEmpty) continue;
              
              if (trimmedLine.startsWith('data:')) {
                final dataStr = trimmedLine.substring(5).trim();
                if (dataStr.isEmpty) continue;
                try {
                  final data = jsonDecode(dataStr) as Map<String, dynamic>;
                  
                  // 检查是否完成（data: {"code": 0, "message": "", "data": true}）
                  final dataField = data['data'];
                  if (dataField == true && dataField is bool) {
                    yield data;
                    return;
                  }

                  if (data['code'] != null && data['code'] != 0) {
                    yield {
                      'error': true,
                      'message': data['message'] ?? '请求失败',
                      'code': data['code'],
                    };
                    return;
                  }

                  yield data;
                } catch (e) {
                  continue;
                }
              }
            }
          }
        }
        
        if (buffer.trim().isNotEmpty) {
          final lines = buffer.split('\n');
          for (final line in lines) {
            final trimmedLine = line.trim();
            if (trimmedLine.isEmpty) continue;
            if (trimmedLine.startsWith('data:')) {
              final dataStr = trimmedLine.substring(5).trim();
              if (dataStr.isEmpty) continue;
              try {
                final data = jsonDecode(dataStr) as Map<String, dynamic>;
                final dataField = data['data'];
                if (dataField == true && dataField is bool) continue;
                if (data['code'] != null && data['code'] != 0) {
                  yield {
                    'error': true,
                    'message': data['message'] ?? '请求失败',
                    'code': data['code'],
                  };
                } else {
                  yield data;
                }
              } catch (e) {
                continue;
              }
            }
          }
        }
      } else {
        yield {
          'error': true,
          'message': '请求失败，状态码: ${streamedResponse.statusCode}',
        };
      }
    } catch (e) {
      yield {
        'error': true,
        'message': e.toString(),
      };
    }
  }
}
