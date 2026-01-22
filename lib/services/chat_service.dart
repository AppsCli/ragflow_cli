import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/dialog.dart';
import 'api_client.dart';

/// 生成 conversation ID（UUID 格式，去掉横线）
String _generateConversationId() {
  final random = Random();
  // 生成类似 UUID v4 格式的字符串：xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
  // 然后去掉横线
  final bytes = List<int>.generate(32, (i) => random.nextInt(16));
  final hex = bytes.map((b) => b.toRadixString(16)).join();
  return hex;
}

class ChatService {
  static const String dialogListEndpoint = '/v1/dialog/list';
  static const String createDialogEndpoint = '/v1/dialog/set';
  static const String deleteDialogEndpoint = '/v1/dialog/rm';
  static const String conversationListEndpoint = '/v1/conversation/list';
  static const String conversationEndpoint = '/v1/conversation/getsse';
  static const String askEndpoint = '/v1/conversation/ask';

  static Future<List<Dialog>> getDialogList() async {
    final response = await ApiClient.get(dialogListEndpoint);
    if (response.success && response.data != null) {
      final dialogs = response.data!['data'] as List<dynamic>?;
      if (dialogs != null) {
          return dialogs
              .map((e) => Dialog.fromJson(e as Map<String, dynamic>))
              .toList();
      }
    }
    return [];
  }

  static Future<Dialog?> createDialog({
    required String name,
    List<String>? kbIds,
    String? llmId,
    String? description,
    Map<String, dynamic>? promptConfig,
  }) async {
    // prompt_config 是必填的，提供默认值
    final defaultPromptConfig = {
      'system': '',
      'prologue': "Hi! I'm your assistant. What can I do for you?",
      'parameters': [],
      'empty_response': "Sorry! No relevant content was found in the knowledge base!",
    };
    
    final response = await ApiClient.post(
      createDialogEndpoint,
      body: {
        'name': name,
        'description': description ?? 'A helpful dialog',
        if (kbIds != null && kbIds.isNotEmpty) 'kb_ids': kbIds,
        if (llmId != null) 'llm_id': llmId,
        'prompt_config': promptConfig ?? defaultPromptConfig,
      },
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return Dialog.fromJson(data);
      }
    }
    return null;
  }

  static Future<bool> deleteDialog(String id) async {
    final response = await ApiClient.post(
      deleteDialogEndpoint,
      body: {'id': id},
    );
    return response.success;
  }

  static Future<List<Conversation>> getConversationList(String dialogId) async {
    final response = await ApiClient.get('$conversationListEndpoint?dialog_id=$dialogId');
    if (response.success && response.data != null) {
      final data = response.data!['data'] as List<dynamic>?;
      if (data != null) {
        return data
            .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  /// 获取 conversation 详细信息
  static Future<Conversation?> getConversation(String conversationId) async {
    final response = await ApiClient.get('/v1/conversation/get?conversation_id=$conversationId');
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return Conversation.fromJson(data);
      }
    }
    return null;
  }

  /// 创建新的 conversation
  static Future<Conversation?> createConversation({
    required String dialogId,
    String? name,
  }) async {
    // 生成 conversation_id（参考 web 前端的 generateConversationId）
    final conversationId = _generateConversationId();
    
    final response = await ApiClient.post(
      '/v1/conversation/set',
      body: {
        'dialog_id': dialogId,
        'conversation_id': conversationId,
        'name': name ?? 'New conversation',
        'is_new': true,
      },
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return Conversation.fromJson(data);
      }
    }
    return null;
  }

  /// 发送消息并通过 SSE 获取流式响应
  static Stream<Map<String, dynamic>> completion({
    required String conversationId,
    required List<Map<String, dynamic>> messages,
  }) async* {
    print("completion:$conversationId $messages");
    try {
      final url = Uri.parse('${ApiClient.baseUrl}/v1/conversation/completion');
      
      // 构建请求头（与 ApiClient 保持一致）
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      final token = ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
      
      final body = jsonEncode({
        'conversation_id': conversationId,
        'messages': messages,
        // 不传递 stream 参数，让服务端使用默认值（默认为 True）
        // 服务端在调用 async_chat 时已经显式传递了 stream=True，如果这里也传递会导致冲突
      });

      final request = http.Request('POST', url);
      request.headers.addAll(headers);
      request.body = body;

      final streamedResponse = await http.Client().send(request);
      print("streamedResponse: $streamedResponse");
      print("streamedResponse.statusCode: : ${streamedResponse.statusCode}");
      if (streamedResponse.statusCode >= 200 &&
          streamedResponse.statusCode < 300) {
        String buffer = '';
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
          buffer += chunk;
          print('Received chunk: ${chunk.length} bytes');
          
          // 处理完整的 SSE 事件（以 \n\n 分隔）
          while (buffer.contains('\n\n')) {
            final index = buffer.indexOf('\n\n');
            final event = buffer.substring(0, index);
            buffer = buffer.substring(index + 2); // 跳过 \n\n
            
            if (event.trim().isEmpty) continue;

            print('Processing SSE event: $event');

            // SSE 格式: "data: {...}"
            // 可能有多行，需要找到所有 "data: " 开头的行
            final lines = event.split('\n');
            for (final line in lines) {
              final trimmedLine = line.trim();
              if (trimmedLine.isEmpty) continue;
              
              if (trimmedLine.startsWith('data: ')) {
                final dataStr = trimmedLine.substring(6); // 跳过 "data: "
                print('Parsing data string: $dataStr');
                try {
                  final data = jsonDecode(dataStr) as Map<String, dynamic>;
                  print('Parsed data: $data');
                  
                  // 检查是否完成（data: {"code": 0, "message": "", "data": true}）
                  final dataField = data['data'];
                  if (dataField == true && dataField is bool) {
                    // 流式传输完成，返回完成标记
                    print('Stream completed');
                    yield data;
                    return;
                  }

                  // 检查是否有错误
                  if (data['code'] != null && data['code'] != 0) {
                    print('Error in response: ${data['message']}');
                    yield {
                      'error': true,
                      'message': data['message'] ?? '请求失败',
                      'code': data['code'],
                    };
                    return;
                  }

                  // 返回数据（包括正常数据）
                  print('Yielding data: $data');
                  yield data;
                } catch (e) {
                  // 忽略解析错误，继续处理下一行
                  print('Failed to parse SSE data: $dataStr, error: $e');
                  continue;
                }
              }
            }
          }
        }
        
        // 处理剩余的 buffer（如果有完整的数据行）
        if (buffer.trim().isNotEmpty) {
          print('Processing remaining buffer: $buffer');
          final lines = buffer.split('\n');
          for (final line in lines) {
            final trimmedLine = line.trim();
            if (trimmedLine.isEmpty) continue;
            if (trimmedLine.startsWith('data: ')) {
              final dataStr = trimmedLine.substring(6);
              try {
                final data = jsonDecode(dataStr) as Map<String, dynamic>;
                final dataField = data['data'];
                // 如果不是完成标记，则返回数据
                if (dataField != true) {
                  print('Yielding remaining data: $data');
                  yield data;
                }
              } catch (e) {
                print('Failed to parse remaining SSE data: $dataStr, error: $e');
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

  static Future<bool> sendMessage({
    required String dialogId,
    required String question,
    String? conversationId,
  }) async {
    final response = await ApiClient.post(
      askEndpoint,
      body: {
        'dialog_id': dialogId,
        'question': question,
        if (conversationId != null) 'conversation_id': conversationId,
      },
    );
    return response.success;
  }
}
