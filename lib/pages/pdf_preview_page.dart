import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../l10n/app_localizations.dart';

/// 通过下载链接或已下载的字节数据内嵌预览 PDF
class PdfPreviewPage extends StatelessWidget {
  /// 文件下载 URL（需带认证的 GET 链接）。与 [data] 二选一。
  final String? downloadUrl;

  /// 请求头，需包含 Authorization 等。仅在使用 [downloadUrl] 时有效。
  final Map<String, String>? headers;

  /// 已下载的 PDF 字节数据。若提供则直接预览，不再请求 [downloadUrl]。
  final Uint8List? data;

  /// 本地 PDF 文件路径。若提供则直接预览该文件。
  final String? filePath;

  /// 显示标题（如文件名）
  final String title;

  /// 通过下载链接预览（按需从网络加载）
  const PdfPreviewPage({
    super.key,
    required String this.downloadUrl,
    this.headers,
    this.title = 'PDF',
  })  : data = null,
        filePath = null;

  /// 通过已下载的字节数据预览（先下载再打开时使用）
  const PdfPreviewPage.fromData({
    super.key,
    required Uint8List this.data,
    this.title = 'PDF',
  })  : downloadUrl = null,
        headers = null,
        filePath = null;

  /// 通过本地文件路径预览（先下载到临时文件再打开时使用）
  const PdfPreviewPage.fromPath({
    super.key,
    required String this.filePath,
    this.title = 'PDF',
  })  : downloadUrl = null,
        headers = null,
        data = null;

  static PdfViewerParams _defaultParams(BuildContext context) {
    return PdfViewerParams(
      loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.downloading,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
      errorBannerBuilder: (context, error, stackTrace, documentRef) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.previewFailed(error.toString()),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildViewer(context),
    );
  }

  Widget _buildViewer(BuildContext context) {
    final params = _defaultParams(context);
    final path = filePath;
    if (path != null && path.isNotEmpty) {
      return PdfViewer.file(
        path,
        params: params,
      );
    }
    if (data != null && data!.isNotEmpty) {
      return PdfViewer.data(
        data!,
        sourceName: title,
        params: params,
      );
    }
    final url = downloadUrl;
    if (url == null || url.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.previewFailed('No source')),
      );
    }
    return PdfViewer.uri(
      Uri.parse(url),
      headers: headers,
      params: params,
    );
  }
}
