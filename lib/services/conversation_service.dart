import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_result.dart';
import '../services/api_client.dart';

class ConversationService {
  static const String askEndpoint = '/v1/conversation/ask';
  static const String relatedQuestionsEndpoint = '/v1/conversation/related_questions';

  /// 发送问题并获取答案（SSE流式）
  /// 使用流式接收答案，每次更新时调用 onUpdate 回调
  /// 参考 chat_service.dart 和 ragflow/web 的实现方式
  static Future<void> askQuestion({
    required String question,
    required List<String> kbIds,
    required Function(SearchAnswer) onUpdate,
    String? searchId,
  }) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}$askEndpoint');
      
      // 构建请求头（与 ApiClient 保持一致）
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      final token = ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
      final body = jsonEncode({
        'question': question,
        'kb_ids': kbIds,
        if (searchId != null) 'search_id': searchId,
      });

      final request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = body;

      final streamedResponse = await http.Client().send(request);

      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        // 使用 buffer 来处理可能不完整的 SSE 事件
        String buffer = '';
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          buffer += chunk;
          
          // 处理完整的 SSE 事件（以 \n\n 分隔）
          while (buffer.contains('\n\n')) {
            final index = buffer.indexOf('\n\n');
            final event = buffer.substring(0, index);
            buffer = buffer.substring(index + 2); // 跳过 \n\n
            
            if (event.trim().isEmpty) continue;

            // SSE 格式: "data: {...}" 或 "data:{...}"
            // 可能有多行，需要找到所有 "data:" 开头的行
            final lines = event.split('\n');
            for (final line in lines) {
              final trimmedLine = line.trim();
              if (trimmedLine.isEmpty) continue;
              
              if (trimmedLine.startsWith('data:')) {
                // 处理 "data: " 或 "data:" 两种情况
                final dataStr = trimmedLine.startsWith('data: ')
                    ? trimmedLine.substring(6) // 跳过 "data: "
                    : trimmedLine.substring(5); // 跳过 "data:"
                
                try {
                  final data = jsonDecode(dataStr) as Map<String, dynamic>;
                  
                  // 检查是否完成（data: {"code": 0, "message": "", "data": true}）
                  final dataField = data['data'];
                  if (dataField == true && dataField is bool) {
                    // 流式传输完成
                    return;
                  }

                  // 检查是否有错误
                  if (data['code'] != null && data['code'] != 0) {
                    throw Exception(data['message'] ?? '请求失败');
                  }

                  // 解析答案数据
                  final answerData = data['data'] as Map<String, dynamic>?;
                  if (answerData != null) {
                    final answer = SearchAnswer.fromJson(answerData);
                    onUpdate(answer);
                  }
                } catch (e) {
                  // 忽略解析错误，继续处理下一行
                  continue;
                }
              }
            }
          }
        }
        
        // 处理剩余的 buffer（如果有完整的数据行）
        if (buffer.trim().isNotEmpty) {
          final lines = buffer.split('\n');
          for (final line in lines) {
            final trimmedLine = line.trim();
            if (trimmedLine.isEmpty) continue;
            if (trimmedLine.startsWith('data:')) {
              final dataStr = trimmedLine.startsWith('data: ')
                  ? trimmedLine.substring(6)
                  : trimmedLine.substring(5);
              try {
                final data = jsonDecode(dataStr) as Map<String, dynamic>;
                final dataField = data['data'];
                // 如果不是完成标记，则处理数据
                if (dataField != true) {
                  final answerData = data['data'] as Map<String, dynamic>?;
                  if (answerData != null) {
                    final answer = SearchAnswer.fromJson(answerData);
                    onUpdate(answer);
                  }
                }
              } catch (e) {
                // 忽略解析错误
                continue;
              }
            }
          }
        }
      } else {
        throw Exception(
            '请求失败，状态码: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 获取相关问题
  static Future<List<String>> getRelatedQuestions({
    required String question,
    String? searchId,
  }) async {
    final response = await ApiClient.post(
      relatedQuestionsEndpoint,
      body: {
        'question': question,
        if (searchId != null) 'search_id': searchId,
      },
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as List<dynamic>?;
      if (data != null) {
        return data.cast<String>();
      }
    }
    return [];
  }
}
