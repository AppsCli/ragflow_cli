import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/user_service.dart';
import 'server_config_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('账号'),
      ),
      body: ListView(
        children: [
          if (user != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildAvatar(user.avatar, radius: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nickname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
          ],
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('服务器设置'),
            subtitle: authProvider.serverConfig != null
                ? Text(authProvider.serverConfig!.baseUrl)
                : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServerConfigPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('修改密码'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showChangePasswordDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('退出登录', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('确认退出'),
                  content: const Text('确定要退出登录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('退出'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool obscureOldPassword = true;
    bool obscureNewPassword = true;
    bool obscureConfirmPassword = true;
    bool isChanging = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('修改密码'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: oldPasswordController,
                    decoration: InputDecoration(
                      labelText: '当前密码',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureOldPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureOldPassword = !obscureOldPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: obscureOldPassword,
                    enabled: !isChanging,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入当前密码';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newPasswordController,
                    decoration: InputDecoration(
                      labelText: '新密码',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureNewPassword = !obscureNewPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: obscureNewPassword,
                    enabled: !isChanging,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入新密码';
                      }
                      if (value.length < 8) {
                        return '密码长度至少为8位';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: '确认新密码',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: obscureConfirmPassword,
                    enabled: !isChanging,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请确认新密码';
                      }
                      if (value != newPasswordController.text) {
                        return '两次输入的密码不一致';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isChanging
                  ? null
                  : () {
                      Navigator.pop(dialogContext);
                    },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: isChanging
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      setState(() {
                        isChanging = true;
                      });

                      try {
                        final success = await UserService.changePassword(
                          oldPasswordController.text,
                          newPasswordController.text,
                        );

                        if (context.mounted) {
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? '密码修改成功'
                                    : '密码修改失败，请检查当前密码是否正确',
                              ),
                              backgroundColor: success
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          setState(() {
                            isChanging = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('密码修改失败: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
              child: isChanging
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建头像 Widget
  /// 支持 URL 和 base64 格式
  Widget _buildAvatar(String? avatar, {double radius = 20}) {
    if (avatar == null || avatar.isEmpty) {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: radius),
      );
    }

    // 检查是否是有效的 URL（以 http:// 或 https:// 开头）
    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      try {
        return CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(avatar),
          onBackgroundImageError: (exception, stackTrace) {
            // 如果网络图片加载失败，显示默认图标
          },
          child: null,
        );
      } catch (e) {
        return CircleAvatar(
          radius: radius,
          child: Icon(Icons.person, size: radius),
        );
      }
    }

    // 尝试作为 base64 图片处理
    try {
      String base64String = avatar;
      
      // 如果是 data URL 格式（如 data:image/png;base64,xxx），提取 base64 部分
      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }

      // 解码 base64 字符串为 Uint8List
      final Uint8List imageBytes = base64Decode(base64String);

      // 使用 Image.memory 显示图片
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(imageBytes),
        onBackgroundImageError: (exception, stackTrace) {
          // 如果图片加载失败，显示默认图标
        },
        child: null,
      );
    } catch (e) {
      // base64 解码失败，显示默认图标
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: radius),
      );
    }
  }
}
