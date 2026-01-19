import 'api_client.dart';

class FileService {
  static const String fileListEndpoint = '/v1/file/list';
  static const String uploadFileEndpoint = '/v1/file/upload';
  static const String deleteFileEndpoint = '/v1/file/rm';
  static const String renameFileEndpoint = '/v1/file/rename';
  static const String createFolderEndpoint = '/v1/file/create';
  static const String moveFileEndpoint = '/v1/file/mv';
  static const String getAllParentFolderEndpoint = '/v1/file/all_parent_folder';

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

  static Future<bool> uploadFile(String filePath, {String? parentId}) async {
    // Note: File upload requires multipart/form-data
    // This is a simplified version - in production, use http.MultipartRequest
    final response = await ApiClient.post(
      uploadFileEndpoint,
      body: {
        'file_path': filePath,
        if (parentId != null) 'parent_id': parentId,
      },
    );
    return response.success;
  }

  static Future<bool> deleteFile(String id) async {
    final response = await ApiClient.post(
      deleteFileEndpoint,
      body: {'id': id},
    );
    return response.success;
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
