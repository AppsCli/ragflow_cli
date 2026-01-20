import 'api_client.dart';

class LLMService {
  static const String llmListEndpoint = '/v1/llm/list';

  /// 获取模型列表
  /// [modelType] - 模型类型，如 'embedding' 用于获取嵌入模型
  static Future<Map<String, List<LLMModel>>> getLLMList({String? modelType}) async {
    final queryParams = <String, String>{};
    if (modelType != null) {
      queryParams['model_type'] = modelType;
    }
    
    final queryString = queryParams.isEmpty
        ? ''
        : '?${Uri(queryParameters: queryParams).query}';
    
    final response = await ApiClient.get('$llmListEndpoint$queryString');

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        final result = <String, List<LLMModel>>{};
        data.forEach((factory, models) {
          if (models is List) {
            result[factory] = models
                .map((m) => LLMModel.fromJson(m as Map<String, dynamic>))
                .toList();
          }
        });
        return result;
      }
    }
    return {};
  }

  /// 获取嵌入模型列表（扁平化）
  static Future<List<LLMModel>> getEmbeddingModels() async {
    final modelsMap = await getLLMList(modelType: 'embedding');
    final models = <LLMModel>[];
    modelsMap.forEach((factory, factoryModels) {
      for (final model in factoryModels) {
        if (model.modelType.contains('embedding')) {
          models.add(model);
        }
      }
    });
    return models;
  }
}

/// LLM 模型数据模型
class LLMModel {
  final String llmName;
  final String modelType;
  final String fid; // factory id
  final bool available;
  final String? status;

  LLMModel({
    required this.llmName,
    required this.modelType,
    required this.fid,
    this.available = false,
    this.status,
  });

  factory LLMModel.fromJson(Map<String, dynamic> json) {
    return LLMModel(
      llmName: json['llm_name'] ?? '',
      modelType: json['model_type'] ?? '',
      fid: json['fid'] ?? '',
      available: json['available'] ?? false,
      status: json['status']?.toString(),
    );
  }

  /// 获取显示名称（包含工厂信息）
  String get displayName {
    if (fid == 'Builtin') {
      return llmName;
    }
    return '$llmName@$fid';
  }

  /// 获取模型ID（用于API调用）
  String get modelId => displayName;
}