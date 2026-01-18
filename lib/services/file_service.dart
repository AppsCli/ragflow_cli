import 'api_client.dart';

class FileService {
  static const String fileListEndpoint = '/v1/file/list';
  static const String uploadFileEndpoint = '/v1/file/upload';
  static const String deleteFileEndpoint = '/v1/file/rm';
  static const String renameFileEndpoint = '/v1/file/rename';
  static const String createFolderEndpoint = '/v1/file/create';
  static const String moveFileEndpoint = '/v1/file/mv';

  static Future<List<Map<String, dynamic>>> getFileList({
    String? parentId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await ApiClient.get(
      '$fileListEndpoint?page=$page&page_size=$pageSize${parentId != null ? '&parent_id=$parentId' : ''}',
    );

    if (response.success && response.data != null) {
      final data = response.data!['data'] as Map<String, dynamic>?;
      print(data);
      if (data != null) {
        final items = data['files'] as List<dynamic>?;
        if (items != null) {
          return items.cast<Map<String, dynamic>>();
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
