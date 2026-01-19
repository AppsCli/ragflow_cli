import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/system_service.dart';

class ServerConfigPage extends StatefulWidget {
  const ServerConfigPage({super.key});

  @override
  State<ServerConfigPage> createState() => _ServerConfigPageState();
}

class _ServerConfigPageState extends State<ServerConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingStatus = false;
  bool _isLoadingVersion = false;
  SystemStatus? _systemStatus;
  String? _systemVersion;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.serverConfig != null) {
      _urlController.text = authProvider.serverConfig!.baseUrl;
    }
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
    await Future.wait([
      _loadSystemStatus(),
      _loadSystemVersion(),
    ]);
  }

  Future<void> _loadSystemStatus() async {
    setState(() {
      _isLoadingStatus = true;
    });

    try {
      final status = await SystemService.getSystemStatus();
      if (mounted) {
        setState(() {
          _systemStatus = status;
          _isLoadingStatus = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStatus = false;
        });
      }
    }
  }

  Future<void> _loadSystemVersion() async {
    setState(() {
      _isLoadingVersion = true;
    });

    try {
      final version = await SystemService.getSystemVersion();
      if (mounted) {
        setState(() {
          _systemVersion = version;
          _isLoadingVersion = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingVersion = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.setServerConfig(_urlController.text.trim());

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('服务器地址保存成功')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存失败，请检查地址格式')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('服务器设置'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                TextFormField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                    labelText: '服务器地址',
                    hintText: '例如: http://192.168.1.100:9380',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cloud),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入服务器地址';
                    }
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return '地址必须以 http:// 或 https:// 开头';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('保存', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                // 系统版本
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline),
                            const SizedBox(width: 8),
                            const Text(
                              'RAGFlow 版本',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (_isLoadingVersion)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else if (_systemVersion == null)
                              TextButton.icon(
                                onPressed: _loadSystemVersion,
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text('刷新'),
                              ),
                          ],
                        ),
                        if (_systemVersion != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _systemVersion!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 系统状态
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.monitor_heart),
                            const SizedBox(width: 8),
                            const Text(
                              '系统状态',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (_isLoadingStatus)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
                              TextButton.icon(
                                onPressed: _loadSystemStatus,
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text('刷新'),
                              ),
                          ],
                        ),
                        if (_systemStatus != null) ...[
                          const SizedBox(height: 16),
                          _buildStatusItem('文档引擎', _systemStatus!.docEngine),
                          const SizedBox(height: 12),
                          _buildStatusItem('存储', _systemStatus!.storage),
                          const SizedBox(height: 12),
                          _buildStatusItem('数据库', _systemStatus!.database),
                          const SizedBox(height: 12),
                          _buildStatusItem('Redis', _systemStatus!.redis),
                        ] else if (!_isLoadingStatus) ...[
                          const SizedBox(height: 8),
                          const Text(
                            '无法获取系统状态',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '提示: 服务器地址应该是完整的URL，例如:\nhttp://192.168.1.100:9380\nhttps://ragflow.example.com',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, ComponentStatus? status) {
    if (status == null) {
      return Row(
        children: [
          Expanded(child: Text(label)),
          const Text('未知', style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    final isHealthy = status.isHealthy;
    final statusColor = isHealthy ? Colors.green : Colors.red;
    final statusText = isHealthy ? '正常' : '异常';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (status.elapsed != null) ...[
          const SizedBox(height: 4),
          Text(
            '响应时间: ${status.elapsed}ms',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.type != null) ...[
          const SizedBox(height: 2),
          Text(
            '类型: ${status.type}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.storage != null) ...[
          const SizedBox(height: 2),
          Text(
            '存储: ${status.storage}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.database != null) ...[
          const SizedBox(height: 2),
          Text(
            '数据库: ${status.database}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.error != null) ...[
          const SizedBox(height: 4),
          Text(
            '错误: ${status.error}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.red[700],
            ),
          ),
        ],
      ],
    );
  }
}
