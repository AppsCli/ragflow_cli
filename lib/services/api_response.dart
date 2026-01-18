/// API响应封装，包含响应数据和原始响应对象
class ApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? error;
  final int? code;
  final Map<String, String>? headers;

  ApiResponse.success(this.data, {this.headers})
      : success = true,
        error = null,
        code = 0;

  ApiResponse.error(this.error, {this.code, this.headers})
      : success = false,
        data = null;
}
