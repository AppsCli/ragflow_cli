import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class FileService {
  static const String fileListEndpoint = '/v1/file/list';
  static const String uploadFileEndpoint = '/v1/file/upload';
  static const String deleteFileEndpoint = '/v1/file/rm';
  static const String renameFileEndpoint = '/v1/file/rename';
  static const String createFolderEndpoint = '/v1/file/create';
  static const String moveFileEndpoint = '/v1/file/mv';
  static const String getAllParentFolderEndpoint = '/v1/file/all_parent_folder';
  static const String getFileEndpoint = '/v1/file/get';

  /// 获取文件列表
  /// [parentId] - 父文件夹ID，如果为null则获取根目录
  /// [keywords] - 搜索关键词
  /// [page] - 页码
  /// [pageSize] - 每页数量
  static Future<FileListResult> getFileList({
    String? parentId,
    String keywords = '',
    int page = 1,
    int pageSize = 10,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'page_size': pageSize.toString(),
      if (keywords.isNotEmpty) 'keywords': keywords,
      if (parentId != null) 'parent_id': parentId,
    };
    
    final queryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    final url = '$fileListEndpoint?$queryString';
    
    final response = await ApiClient.get(url);

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        final files = data['files'] as List<dynamic>?;
        final total = data['total'] as int? ?? 0;
        final parentFolder = data['parent_folder'] as Map<String, dynamic>?;
        
        return FileListResult(
          files: files?.cast<Map<String, dynamic>>() ?? [],
          total: total,
          parentFolder: parentFolder,
        );
      }
    }
    return FileListResult(files: [], total: 0);
  }

  /// 获取所有上级文件夹
  /// [fileId] - 文件ID
  static Future<List<Map<String, dynamic>>> getAllParentFolder(String fileId) async {
    final response = await ApiClient.get('$getAllParentFolderEndpoint?file_id=$fileId');
    
    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      if (data != null) {
        final parentFolders = data['parent_folders'] as List<dynamic>?;
        if (parentFolders != null) {
          return parentFolders.cast<Map<String, dynamic>>();
        }
      }
    }
    return [];
  }

  /// 上传文件（multipart/form-data）
  /// [file] - 要上传的文件
  /// [parentId] - 父文件夹ID
  static Future<bool> uploadFile(File file, {String? parentId}) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}$uploadFileEndpoint');
      
      // 构建请求头
      final headers = <String, String>{};
      final token = ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
      
      // 创建 multipart 请求
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      
      // 添加文件
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );
      
      // 添加 parent_id（如果提供）
      if (parentId != null) {
        request.fields['parent_id'] = parentId;
      }
      
      // 发送请求
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // 解析响应
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 删除文件
  /// [fileIds] - 文件ID列表
  static Future<bool> deleteFile(List<String> fileIds) async {
    final response = await ApiClient.post(
      deleteFileEndpoint,
      body: {'file_ids': fileIds},
    );
    return response.success;
  }

  /// 下载文件
  /// [fileId] - 文件ID
  /// 返回文件的字节数据
  static Future<Uint8List?> downloadFile(String fileId) async {
    try {
      final url = Uri.parse('${ApiClient.baseUrl}$getFileEndpoint/$fileId');
      
      // 构建请求头
      final headers = <String, String>{};
      final token = ApiClient.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = token;
      }
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 获取文件预览URL
  /// [fileId] - 文件ID（也是 document ID）
  /// [fileName] - 文件名（用于提取扩展名）
  static String getFilePreviewUrl(String fileId, String fileName) {
    // 提取文件扩展名
    final extension = fileName.contains('.') 
        ? fileName.split('.').last.toLowerCase()
        : 'pdf'; // 默认扩展名
    // 预览URL格式: /document/<doc_id>?ext=<extension>&prefix=file
    // web 前端使用相对路径 /document/...，但实际API路径是 /document/...
    return '${ApiClient.baseUrl}/document/$fileId?ext=$extension&prefix=file';
  }

  static Future<bool> renameFile(String id, String newName) async {
    final response = await ApiClient.post(
      renameFileEndpoint,
      body: {'id': id, 'name': newName},
    );
    return response.success;
  }

  static Future<bool> createFolder(String name, {String? parentId}) async {
    final response = await ApiClient.post(
      createFolderEndpoint,
      body: {
        'name': name,
        if (parentId != null) 'parent_id': parentId,
      },
    );
    return response.success;
  }
}

/// 文件列表结果
class FileListResult {
  final List<Map<String, dynamic>> files;
  final int total;
  final Map<String, dynamic>? parentFolder;

  FileListResult({
    required this.files,
    required this.total,
    this.parentFolder,
  });
}
