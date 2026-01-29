import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../strings.dart';
import '../providers/auth_provider.dart';
import '../utils/storage.dart';
import '../utils/rsa_encrypt.dart';
import 'server_config_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rsaPublicKeyController = TextEditingController();
  bool _obscurePassword = true;
  bool _showRsaPublicKeySettings = false;
  bool _isLoadingRsaKey = false;

  @override
  void initState() {
    super.initState();
    _loadRsaPublicKey();
  }

  Future<void> _loadRsaPublicKey() async {
    final storedKey = await Storage.getRsaPublicKey();
    if (storedKey != null && mounted) {
      setState(() {
        _rsaPublicKeyController.text = storedKey;
      });
    } else {
      // 如果没有存储的公钥，显示默认公钥
      if (mounted) {
        setState(() {
          _rsaPublicKeyController.text = getDefaultRsaPublicKey();
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _rsaPublicKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveRsaPublicKey() async {
    final publicKey = _rsaPublicKeyController.text.trim();
    
    if (publicKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.rsaPublicKeyRequired)),
      );
      return;
    }

    // 验证公钥格式（简单检查是否包含 BEGIN PUBLIC KEY）
    if (!publicKey.contains('BEGIN PUBLIC KEY') || !publicKey.contains('END PUBLIC KEY')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(Strings.rsaPublicKeyInvalid)),
      );
      return;
    }

    setState(() {
      _isLoadingRsaKey = true;
    });

    try {
      await Storage.saveRsaPublicKey(publicKey);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.rsaPublicKeySaved)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.rsaPublicKeySaveFailed}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRsaKey = false;
        });
      }
    }
  }

  Future<void> _resetToDefaultRsaPublicKey() async {
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
      setState(() {
        _isLoadingRsaKey = true;
      });

      try {
        await Storage.removeRsaPublicKey();
        setState(() {
          _rsaPublicKeyController.text = getDefaultRsaPublicKey();
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.resetToDefaultSuccess)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${Strings.resetToDefaultFailed}: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingRsaKey = false;
          });
        }
      }
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Check if server config is set
    if (authProvider.serverConfig == null || authProvider.serverConfig!.baseUrl.isEmpty) {
      _showServerConfigDialog();
      return;
    }

    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        final errorMessage = authProvider.lastLoginError ?? Strings.loginFailed;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showServerConfigDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(Strings.configureServerAddress),
        content: Text(Strings.pleaseConfigureServer),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ServerConfigPage()),
              );
            },
            child: Text(Strings.goToSettings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Strings.appTitle,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: Strings.email,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.emailRequired;
                      }
                      if (!value.contains('@')) {
                        return Strings.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: Strings.password,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.passwordRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: authProvider.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(Strings.login, style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 16),
                  // RSA 公钥设置（可展开/折叠）
                  ExpansionTile(
                    title: Text(_showRsaPublicKeySettings 
                        ? Strings.hideRsaPublicKeySettings 
                        : Strings.showRsaPublicKeySettings),
                    leading: const Icon(Icons.vpn_key),
                    initiallyExpanded: false,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _showRsaPublicKeySettings = expanded;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              Strings.rsaPublicKeyHint,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _rsaPublicKeyController,
                              decoration: InputDecoration(
                                labelText: Strings.rsaPublicKey,
                                border: const OutlineInputBorder(),
                                hintText: Strings.rsaPublicKeyHint,
                              ),
                              maxLines: 5,
                              enabled: !_isLoadingRsaKey,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _isLoadingRsaKey ? null : _resetToDefaultRsaPublicKey,
                                    icon: const Icon(Icons.restore),
                                    label: Text(Strings.resetToDefault),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isLoadingRsaKey ? null : _saveRsaPublicKey,
                                    icon: _isLoadingRsaKey
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.save),
                                    label: Text(Strings.save),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ServerConfigPage()),
                      );
                    },
                    icon: const Icon(Icons.settings),
                    label: Text(Strings.setServerAddress),
                  ),
                  if (authProvider.serverConfig != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      Strings.currentServer(authProvider.serverConfig!.baseUrl),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
