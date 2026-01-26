import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.addServer),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.serverName,
                    hintText: AppLocalizations.of(context)!.exampleProduction,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.label),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: l10n.serverAddress,
                    hintText: l10n.exampleServerAddress,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.cloud),
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.serverAddressRequired;
                    }
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return l10n.serverAddressFormatError;
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
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(l10n.addServer),
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
            SnackBar(content: Text(l10n.serverAdded)),
          );
          // 如果这是第一个服务器，可能需要重新加载系统信息
          _loadSystemInfo();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.addFailed)),
          );
        }
      }
    }
  }

  Future<void> _handleActivate(ServerConfig config) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    // 如果已经是激活的服务器，不需要操作
    if (config.isActive) {
      return;
    }

    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final serverName = config.name.isNotEmpty ? config.name : config.baseUrl;
        return AlertDialog(
          title: Text(l10n.confirm),
          content: Text(l10n.switchServerConfirm(serverName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.confirm),
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
          SnackBar(content: Text(l10n.switchFailed)),
        );
      }
    }
  }

  Future<void> _handleDelete(ServerConfig config) async {
    final l10n = AppLocalizations.of(context)!;
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final serverName = config.name.isNotEmpty ? config.name : config.baseUrl;
        return AlertDialog(
          title: Text(l10n.confirm),
          content: Text(l10n.deleteServerConfirm(serverName)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
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
          SnackBar(content: Text(l10n.serverDeleted)),
        );
        
        // 如果删除的是激活的服务器，需要重新加载系统信息
        if (wasActive) {
          _loadSystemInfo();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.deleteFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.serverSettings),
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
                    final l10n = AppLocalizations.of(context)!;
                    
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
                                l10n.noServerConfig,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.addServerHint,
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
                          l10n.serverList,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...servers.map((server) => _buildServerCard(server, l10n)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                // 添加服务器按钮
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _showAddServerDialog,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addServer),
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
                              l10n.systemVersion,
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
                                label: Text(l10n.refresh),
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
                              AppLocalizations.of(context)!.systemStatus,
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
                                label: Text(AppLocalizations.of(context)!.refresh),
                              ),
                          ],
                        ),
                        if (_systemStatus != null) ...[
                          const SizedBox(height: 16),
                          _buildStatusItem(l10n.documentEngine, _systemStatus!.docEngine, l10n),
                          const SizedBox(height: 12),
                          _buildStatusItem(l10n.storage, _systemStatus!.storage, l10n),
                          const SizedBox(height: 12),
                          _buildStatusItem(l10n.database, _systemStatus!.database, l10n),
                          const SizedBox(height: 12),
                          _buildStatusItem(l10n.redis, _systemStatus!.redis, l10n),
                        ] else if (!_isLoadingStatus) ...[
                          const SizedBox(height: 8),
                          Text(
                            l10n.cannotGetSystemStatus,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.serverAddressHint,
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
                              l10n.rsaPublicKeySettings,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.rsaPublicKeyHint,
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
                                    l10n.currentRsaPublicKey,
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
                                    l10n.defaultRsaPublicKey,
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
                                  label: Text(l10n.resetToDefault),
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
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetToDefault),
        content: Text(l10n.resetToDefaultConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Storage.removeRsaPublicKey();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.resetToDefaultSuccess)),
          );
          // 刷新界面
          setState(() {});
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.resetToDefaultFailed}: $e')),
          );
        }
      }
    }
  }

  Widget _buildServerCard(ServerConfig server, AppLocalizations l10n) {
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
                          l10n.active,
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
                    label: Text(l10n.activate),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _handleDelete(server),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: l10n.delete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, ComponentStatus? status, AppLocalizations l10n) {
    if (status == null) {
      return Row(
        children: [
          Expanded(child: Text(label)),
          Text(l10n.unknown, style: const TextStyle(color: Colors.grey)),
        ],
      );
    }

    final isHealthy = status.isHealthy;
    final statusColor = isHealthy ? Colors.green : Colors.red;
    final statusText = isHealthy ? l10n.normal : l10n.abnormal;

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
            l10n.responseTime(status.elapsed!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.type != null) ...[
          const SizedBox(height: 2),
          Text(
            l10n.type(status.type!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.storage != null) ...[
          const SizedBox(height: 2),
          Text(
            l10n.storageInfo(status.storage!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.database != null) ...[
          const SizedBox(height: 2),
          Text(
            l10n.databaseInfo(status.database!),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
        if (status.error != null) ...[
          const SizedBox(height: 4),
          Text(
            l10n.error(status.error!),
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
