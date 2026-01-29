import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../providers/auth_provider.dart';
import '../services/system_service.dart';
import '../models/server_config.dart';
import '../utils/storage.dart';
import '../utils/rsa_encrypt.dart';

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
      builder: (context) {
        return AlertDialog(
          title: Text(Strings.addServer),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: Strings.serverName,
                    hintText: Strings.exampleProduction,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: Strings.serverAddress,
                    hintText: Strings.exampleServerAddress,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.cloud),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return Strings.serverAddressRequired;
                    }
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return Strings.serverAddressFormatError;
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
              child: Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(Strings.addServer),
            ),
          ],
        );
      },
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
            SnackBar(content: Text(Strings.serverAdded)),
          );
          // 如果这是第一个服务器，可能需要重新加载系统信息
          _loadSystemInfo();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.addFailed)),
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
      builder: (context) {
        final serverName = config.name.isNotEmpty ? config.name : config.baseUrl;
        return AlertDialog(
          title: Text(Strings.confirm),
          content: Text(Strings.switchServerConfirm(serverName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(Strings.confirm),
            ),
          ],
        );
      },
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
          SnackBar(content: Text(Strings.switchFailed)),
        );
      }
    }
  }

  Future<void> _handleDelete(ServerConfig config) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final serverName = config.name.isNotEmpty ? config.name : config.baseUrl;
        return AlertDialog(
          title: Text(Strings.confirm),
          content: Text(Strings.deleteServerConfirm(serverName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(Strings.delete),
            ),
          ],
        );
      },
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
          SnackBar(content: Text(Strings.serverDeleted)),
        );
        
        // 如果删除的是激活的服务器，需要重新加载系统信息
        if (wasActive) {
          _loadSystemInfo();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.deleteFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.serverSettings),
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
                                Strings.noServerConfig,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                Strings.addServerHint,
                                style: const TextStyle(
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
                        Text(
                          Strings.serverList,
                          style: const TextStyle(
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
                  label: Text(Strings.addServer),
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
                            Text(
                              Strings.systemVersion,
                              style: const TextStyle(
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
                                label: Text(Strings.refresh),
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
                            Text(
                              Strings.systemStatus,
                              style: const TextStyle(
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
                                label: Text(Strings.refresh),
                              ),
                          ],
                        ),
                        if (_systemStatus != null) ...[
                          const SizedBox(height: 16),
                          _buildStatusItem(Strings.documentEngine, _systemStatus!.docEngine),
                          const SizedBox(height: 12),
                          _buildStatusItem(Strings.storage, _systemStatus!.storage),
                          const SizedBox(height: 12),
                          _buildStatusItem(Strings.database, _systemStatus!.database),
                          const SizedBox(height: 12),
                          _buildStatusItem(Strings.redis, _systemStatus!.redis),
                        ] else if (!_isLoadingStatus) ...[
                          const SizedBox(height: 8),
                          Text(
                            Strings.cannotGetSystemStatus,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Strings.serverAddressHint,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                // RSA 公钥设置
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.vpn_key),
                            const SizedBox(width: 8),
                            Text(
                              Strings.rsaPublicKeySettings,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          Strings.rsaPublicKeyHint,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        FutureBuilder<String?>(
                          future: Storage.getRsaPublicKey(),
                          builder: (context, snapshot) {
                            final hasCustomKey = snapshot.hasData && snapshot.data != null;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (hasCustomKey) ...[
                                  Text(
                                    Strings.currentRsaPublicKey,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ] else ...[
                                  Text(
                                    Strings.defaultRsaPublicKey,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Text(
                                      getDefaultRsaPublicKey(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                                ElevatedButton.icon(
                                  onPressed: () => _handleResetRsaPublicKey(context),
                                  icon: const Icon(Icons.restore),
                                  label: Text(Strings.resetToDefault),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleResetRsaPublicKey(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.resetToDefault),
        content: Text(Strings.resetToDefaultConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(Strings.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Storage.removeRsaPublicKey();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.resetToDefaultSuccess)),
          );
          // 刷新界面
          setState(() {});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${Strings.resetToDefaultFailed}: $e')),
          );
        }
      }
    }
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          Strings.active,
                          style: const TextStyle(
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
                    label: Text(Strings.activate),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _handleDelete(server),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: Strings.delete,
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
          Text(Strings.unknown, style: const TextStyle(color: Colors.grey)),
        ],
      );
    }

    final isHealthy = status.isHealthy;
    final statusColor = isHealthy ? Colors.green : Colors.red;
    final statusText = isHealthy ? Strings.normal : Strings.abnormal;

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
            Strings.responseTime(status.elapsed!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.type != null) ...[
          const SizedBox(height: 2),
          Text(
            Strings.type(status.type!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.storage != null) ...[
          const SizedBox(height: 2),
          Text(
            Strings.storageInfo(status.storage!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.database != null) ...[
          const SizedBox(height: 2),
          Text(
            Strings.databaseInfo(status.database!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.error != null) ...[
          const SizedBox(height: 4),
          Text(
            Strings.error(status.error!),
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
