import '../models/dialog.dart';
import 'api_client.dart';

class ChatService {
  static const String dialogListEndpoint = '/v1/dialog/list';
  static const String createDialogEndpoint = '/v1/dialog/set';
  static const String deleteDialogEndpoint = '/v1/dialog/rm';
  static const String conversationListEndpoint = '/v1/conversation/list';
  static const String conversationEndpoint = '/v1/conversation/getsse';
  static const String askEndpoint = '/v1/conversation/ask';

  static Future<List<Dialog>> getDialogList() async {
    final response = await ApiClient.get(dialogListEndpoint);
    print(response.data);
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
  }) async {
    final response = await ApiClient.post(
      createDialogEndpoint,
      body: {
        'name': name,
        if (kbIds != null) 'kb_ids': kbIds,
        if (llmId != null) 'llm_id': llmId,
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
