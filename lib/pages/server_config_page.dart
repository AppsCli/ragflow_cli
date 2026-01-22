import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/system_service.dart';
import '../models/server_config.dart';

class ServerConfigPage extends StatefulWidget {
  const ServerConfigPage({super.key});

  @override
  State<ServerConfigPage> createState() => _ServerConfigPageState();
}

class _ServerConfigPageState extends State<ServerConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingStatus = false;
  bool _isLoadingVersion = false;
  SystemStatus? _systemStatus;
  String? _systemVersion;

  @override
  void initState() {
    super.initState();
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
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showAddServerDialog() async {
    _urlController.clear();
    _nameController.clear();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加服务器'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '服务器名称（可选）',
                  hintText: '例如: 生产环境',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16),
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );

    if (result == true) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.addServer(
        _urlController.text.trim(),
        name: _nameController.text.trim().isNotEmpty 
            ? _nameController.text.trim() 
            : null,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('服务器添加成功')),
          );
          // 如果这是第一个服务器，可能需要重新加载系统信息
          _loadSystemInfo();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('添加失败，请检查地址格式')),
          );
        }
      }
    }
  }

  Future<void> _handleActivate(ServerConfig config) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // 如果已经是激活的服务器，不需要操作
    if (config.isActive) {
      return;
    }

    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认切换'),
        content: Text(
          '切换到服务器 "${config.name.isNotEmpty ? config.name : config.baseUrl}" 后需要重新登录，确定要继续吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    final success = await authProvider.activateServer(config.baseUrl);

    if (mounted) {
      if (success) {
        // 清除用户信息（登出）
        await authProvider.logout();
        
        // 跳转到登录界面
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false, // 清除所有路由栈
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('切换失败')),
        );
      }
    }
  }

  Future<void> _handleDelete(ServerConfig config) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text(
          '确定要删除服务器 "${config.name.isNotEmpty ? config.name : config.baseUrl}" 吗？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wasActive = config.isActive;
    final success = await authProvider.deleteServer(config.baseUrl);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('服务器已删除')),
        );
        
        // 如果删除的是激活的服务器，需要重新加载系统信息
        if (wasActive) {
          _loadSystemInfo();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('删除失败')),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 服务器列表
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final servers = authProvider.serverConfigs;
                    
                    if (servers.isEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.cloud_off,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '暂无服务器配置',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '点击下方按钮添加服务器',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '服务器列表',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...servers.map((server) => _buildServerCard(server)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                // 添加服务器按钮
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _showAddServerDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('添加服务器'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
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
    );
  }

  Widget _buildServerCard(ServerConfig server) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: server.isActive ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: server.isActive ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (server.name.isNotEmpty) ...[
                        Text(
                          server.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        server.baseUrl,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                if (server.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          '已激活',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!server.isActive)
                  TextButton.icon(
                    onPressed: () => _handleActivate(server),
                    icon: const Icon(Icons.power_settings_new, size: 18),
                    label: const Text('激活'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _handleDelete(server),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: '删除',
                ),
              ],
            ),
          ],
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
