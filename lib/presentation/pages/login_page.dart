import 'package:flutter/material.dart';
import '../../utils/validators.dart';
import '../../data/services/http_service.dart';

/// 登录页
/// - 邮箱 + 密码 登录
/// - 登录按钮：内容为空 → 浅灰底灰字；内容非空 → 蓝底白字
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color _primaryColor = Color(0xFF2B7BFF);
  static const Color _fieldFill = Color(0xFFF5F7FA);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _submitting = false;
  String? _hintText;

  /// 输入内容非空 → 按钮可用
  bool get _canSubmit =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      !_submitting;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setHint(String? text) {
    if (!mounted) return;
    setState(() => _hintText = text);
  }

  Future<void> _handleLogin() async {
    if (_submitting || !_canSubmit) return;

    if (!_formKey.currentState!.validate()) {
      _setHint('请完整填写邮箱与密码');
      return;
    }

    setState(() {
      _submitting = true;
      _hintText = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final res = await HttpService.instance.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = res.data?['token'] as String?;
      if (token != null) {
        HttpService.setToken(token);
      }

      if (!mounted) return;
      _setHint('登录成功！');
      // TODO: 跳转主页
    } catch (e) {
      if (!mounted) return;
      _setHint('登录失败：${e.toString()}');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenHeight = mq.size.height - mq.padding.top - mq.padding.bottom;
    final bool compact = screenHeight < 720;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: compact ? 8 : 16,
                bottom: mq.viewInsets.bottom + 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 返回按钮
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 22,
                        ),
                      ),

                      SizedBox(height: compact ? 24 : 48),

                      // 标题：登录
                      const Text(
                        '登录',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '请输入您的邮箱和密码',
                        style: TextStyle(fontSize: 14, color: Color(0xFF8A94A6)),
                      ),

                      SizedBox(height: compact ? 32 : 48),

                      // 表单
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // 邮箱
                            _buildTextField(
                              controller: _emailController,
                              hint: '请输入邮箱地址',
                              icon: Icons.alternate_email,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 14),

                            // 密码
                            _buildTextField(
                              controller: _passwordController,
                              hint: '请输入密码',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: Validators.validatePassword,
                            ),

                            // 提示信息
                            if (_hintText != null) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _hintText!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _hintText!.contains('成功')
                                        ? const Color(0xFF1FA86C)
                                        : const Color(0xFFE54848),
                                  ),
                                ),
                              ),
                            ],

                            SizedBox(height: compact ? 28 : 36),

                            // 登录按钮 — 内容空=浅灰，内容非空=蓝
                            _PrimaryButton(
                              text: _submitting ? '登录中...' : '登 录',
                              enabled: _canSubmit,
                              color: _primaryColor,
                              onPressed: _handleLogin,
                            ),
                          ],
                        ),
                      ),

                      
                      SizedBox(height: compact ? 30: 70),
                      const Spacer(),

                      const Text(
                        '©2026 TMS 企业版',
                        style: TextStyle(fontSize: 10, color: Color(0xFF8A94A6)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      autocorrect: false,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
        prefixIcon: Icon(icon, color: const Color(0xFFB0B7C3), size: 20),
        filled: true,
        fillColor: _fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFF2B7BFF), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFE54848), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFFE54848), width: 1.4),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.text,
    required this.enabled,
    required this.color,
    required this.onPressed,
  });

  final String text;
  final bool enabled;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color : const Color(0xFFF2F3F5),
          foregroundColor: enabled ? Colors.white : const Color(0xFFB0B7C3),
          disabledBackgroundColor: const Color(0xFFF2F3F5),
          disabledForegroundColor: const Color(0xFFB0B7C3),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2),
        ),
      ),
    );
  }
}
