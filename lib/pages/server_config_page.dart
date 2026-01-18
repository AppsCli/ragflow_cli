import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ServerConfigPage extends StatefulWidget {
  const ServerConfigPage({super.key});

  @override
  State<ServerConfigPage> createState() => _ServerConfigPageState();
}

class _ServerConfigPageState extends State<ServerConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.serverConfig != null) {
      _urlController.text = authProvider.serverConfig!.baseUrl;
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
}
