import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';
import 'api_response.dart';

class ApiClient {
  static String? _baseUrl;
  static String? _token;

  static Future<void> initialize() async {
    final config = await Storage.getServerConfig();
    _baseUrl = config?.baseUrl;
    
    // 优先使用 ServerConfig 中的 token（应该是从响应headers中获取的完整Authorization值）
    // 如果没有，从 Storage 获取 token
    _token = config?.token ?? await Storage.getToken();
    
    // 如果token存在但没有Bearer前缀，添加前缀（兼容旧数据或access_token）
    if (_token != null && _token!.isNotEmpty && !_token!.startsWith('Bearer ')) {
      _token = 'Bearer $_token';
    }
  }

  static void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static void setToken(String? token) {
    _token = token;
  }
  
  static String? getToken() {
    return _token;
  }

  static String get baseUrl => _baseUrl ?? '';

  static Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    // 添加 Authorization header（与web前端保持一致）
    // web前端使用: getAuthorization() 返回的值直接作为 Authorization header
    // 这个值是从响应headers中获取的，应该已经是正确的格式
    if (_token != null && _token!.isNotEmpty) {
      // 直接使用保存的token（应该已经是服务器返回的完整格式）
      headers['Authorization'] = _token!;
    }
    
    return headers;
  }

  static Future<ApiResponse> get(String endpoint) async {
    try {
      final url = Uri.parse('${_baseUrl ?? ''}$endpoint');
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  static Future<ApiResponse> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final url = Uri.parse('${_baseUrl ?? ''}$endpoint');
      final response = await http.post(
        url,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
  
  /// 获取当前响应中的headers（用于提取Authorization等）
  static Map<String, String>? _lastResponseHeaders;
  
  static Map<String, String>? getLastResponseHeaders() => _lastResponseHeaders;

  static Future<ApiResponse> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final url = Uri.parse('${_baseUrl ?? ''}$endpoint');
      final response = await http.put(
        url,
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  static Future<ApiResponse> delete(String endpoint) async {
    try {
      final url = Uri.parse('${_baseUrl ?? ''}$endpoint');
      final response = await http.delete(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  static ApiResponse _handleResponse(http.Response response) {
    try {
      Map<String, dynamic>? data;
      
      // 尝试解析响应体
      try {
        if (response.body.isNotEmpty) {
          data = jsonDecode(response.body) as Map<String, dynamic>;
        }
      } catch (e) {
        // 如果响应体无法解析，返回错误
        _lastResponseHeaders = response.headers;
      return ApiResponse.error(
          'Failed to parse response body: ${response.body}',
          code: response.statusCode,
          headers: response.headers,
        );
      }

      _lastResponseHeaders = response.headers;
      
      // 检查 HTTP 状态码
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return ApiResponse.error(
          data?['message'] ?? 'Request failed with status ${response.statusCode}',
          code: data?['code'] ?? response.statusCode,
          headers: response.headers,
        );
      }

      // RAGFlow API 使用响应体中的 code 字段来判断成功/失败
      // code === 0 表示成功，其他值表示失败
      final responseCode = data?['code'] as int?;
      if (responseCode != null && responseCode != 0) {
        return ApiResponse.error(
          data?['message'] ?? 'Request failed with code $responseCode',
          code: responseCode,
          headers: response.headers,
        );
      }

      // 保存响应headers（用于后续提取）
      _lastResponseHeaders = response.headers;
      
      // 从响应headers中提取Authorization并更新token（与web前端保持一致）
      // web前端使用: response.headers.get(Authorization)
      final authHeader = response.headers['authorization'] ?? 
                        response.headers['Authorization'];
      if (authHeader != null && authHeader.isNotEmpty) {
        // 直接使用从响应headers中获取的Authorization值
        // 这个值应该已经是服务器返回的完整格式
        _token = authHeader;
      }

      return ApiResponse.success(data ?? {}, headers: response.headers);
    } catch (e) {
      return ApiResponse.error('Failed to handle response: $e', headers: response.headers);
    }
  }
}

