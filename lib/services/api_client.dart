import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class ApiClient {
  static String? _baseUrl;
  static String? _token;

  static Future<void> initialize() async {
    final config = await Storage.getServerConfig();
    _baseUrl = config?.baseUrl;
    _token = config?.token ?? await Storage.getToken();
  }

  static void setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
  }

  static void setToken(String? token) {
    _token = token;
  }

  static String get baseUrl => _baseUrl ?? '';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': _token!,
      };

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
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Extract token from headers if present
        final authHeader = response.headers['authorization'];
        if (authHeader != null) {
          _token = authHeader;
        }
        return ApiResponse.success(data);
      } else {
        return ApiResponse.error(
          data['message'] ?? 'Request failed with status ${response.statusCode}',
          code: data['code'] ?? response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }
}

class ApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? error;
  final int? code;

  ApiResponse.success(this.data)
      : success = true,
        error = null,
        code = 0;

  ApiResponse.error(this.error, {this.code})
      : success = false,
        data = null;
}
