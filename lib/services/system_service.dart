import 'api_client.dart';

class SystemService {
  static const String systemStatusEndpoint = '/v1/system/status';
  static const String systemVersionEndpoint = '/v1/system/version';

  /// 获取系统状态
  static Future<SystemStatus?> getSystemStatus() async {
    final response = await ApiClient.get(systemStatusEndpoint);

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        return SystemStatus.fromJson(data);
      }
    }
    return null;
  }

  /// 获取系统版本
  static Future<String?> getSystemVersion() async {
    final response = await ApiClient.get(systemVersionEndpoint);

    if (response.success && response.data != null) {
      // 服务端返回的 data 直接是版本字符串，不是对象
      // 格式: { "code": 0, "data": "v0.15.0-50-g6daae7f2" }
      final data = response.data!['data'];
      if (data != null) {
        // data 可能是字符串类型，直接返回
        if (data is String) {
          return data;
        }
        // 如果不是字符串，转换为字符串
        return data.toString();
      }
    }
    return null;
  }
}

/// 系统状态数据模型
class SystemStatus {
  final ComponentStatus? docEngine;
  final ComponentStatus? storage;
  final ComponentStatus? database;
  final ComponentStatus? redis;
  final Map<String, dynamic>? taskExecutorHeartbeats;

  SystemStatus({
    this.docEngine,
    this.storage,
    this.database,
    this.redis,
    this.taskExecutorHeartbeats,
  });

  factory SystemStatus.fromJson(Map<String, dynamic> json) {
    return SystemStatus(
      docEngine: json['doc_engine'] != null
          ? ComponentStatus.fromJson(json['doc_engine'] as Map<String, dynamic>)
          : null,
      storage: json['storage'] != null
          ? ComponentStatus.fromJson(json['storage'] as Map<String, dynamic>)
          : null,
      database: json['database'] != null
          ? ComponentStatus.fromJson(json['database'] as Map<String, dynamic>)
          : null,
      redis: json['redis'] != null
          ? ComponentStatus.fromJson(json['redis'] as Map<String, dynamic>)
          : null,
      taskExecutorHeartbeats: json['task_executor_heartbeats'] as Map<String, dynamic>?,
    );
  }
}

/// 组件状态数据模型
class ComponentStatus {
  final String? type;
  final String? status;
  final String? elapsed;
  final String? error;
  final String? storage;
  final String? database;

  ComponentStatus({
    this.type,
    this.status,
    this.elapsed,
    this.error,
    this.storage,
    this.database,
  });

  factory ComponentStatus.fromJson(Map<String, dynamic> json) {
    return ComponentStatus(
      type: json['type'] as String?,
      status: json['status'] as String?,
      elapsed: json['elapsed'] as String?,
      error: json['error'] as String?,
      storage: json['storage'] as String?,
      database: json['database'] as String?,
    );
  }

  bool get isHealthy => status == 'green';
}