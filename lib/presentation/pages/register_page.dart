import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/validators.dart';
import '../../data/services/auth_api.dart';
import '../../core/routes/app_routes.dart';

/// 注册页（自动注册）
/// - 邮箱 + 验证码
/// - 未注册邮箱验证通过后自动注册
/// - 注册按钮：内容为空 → 浅灰底灰字；内容非空 → 蓝底白字
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const Color _primaryColor = Color(0xFF2B7BFF);
  static const Color _fieldFill = Color(0xFFF5F7FA);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreed = false;
  bool _sendingCode = false;
  bool _submitting = false;
  int _countdown = 0;
  Timer? _timer;
  String? _hintText;
  String? _captchaToken;

  /// 输入内容非空 → 按钮可用
  bool get _canSubmit =>
      _emailController.text.trim().isNotEmpty &&
      _codeController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      !_submitting;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChanged);
    _codeController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() => setState(() {});

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _setHint(String? text) {
    if (!mounted) return;
    setState(() => _hintText = text);
  }

  /// 发送验证码
  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _setHint('请先填写邮箱地址');
      return;
    }
    if (Validators.validateEmail(email) != null) {
      _setHint('邮箱格式不正确，请检查后重试');
      return;
    }
    if (!_agreed) {
      _setHint('请先勾选并同意《用户协议》与《隐私政策》');
      return;
    }

    setState(() {
      _sendingCode = true;
      _countdown = 60;
      _captchaToken = null; // 重新发送时清除旧 token
    });
    _setHint(null);

    try {
      final res = await AuthApi.sendCaptcha(username: email, type: 'email');
      // 保存验证码 token（注册时需携带）
      final responseData = res.data;
      final data = responseData is Map<String, dynamic> ? responseData['data'] : responseData;
      if (data is Map<String, dynamic>) {
        _captchaToken = data['token'] as String?;
      }
      _setHint('验证码已发送至您的邮箱，5 分钟内有效');
    } catch (e) {
      _setHint('发送失败：${e.toString()}');
      setState(() {
        _sendingCode = false;
        _countdown = 0;
      });
      return;
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown <= 1) {
        timer.cancel();
        setState(() {
          _sendingCode = false;
          _countdown = 0;
        });
      } else {
        setState(() => _countdown--);
      }
    });
  }

  /// 注册（自动注册）
  Future<void> _handleRegister() async {
    if (_submitting || !_canSubmit) return;

    if (!_formKey.currentState!.validate()) {
      _setHint('请完整填写邮箱与验证码');
      return;
    }
    if (!_agreed) {
      _setHint('请先勾选并同意《用户协议》与《隐私政策》');
      return;
    }

    setState(() {
      _submitting = true;
      _hintText = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final code = int.tryParse(_codeController.text.trim()) ?? 0;

      if (_captchaToken == null || _captchaToken!.isEmpty) {
        _setHint('请先获取验证码');
        setState(() => _submitting = false);
        return;
      }

      await AuthApi.register(
        username: email,
        password: password,
        token: _captchaToken!,
        code: code,
        type: 'email',
      );

      if (!mounted) return;
      _setHint('注册成功！');
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      _setHint('注册失败：${e.toString()}');
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
                      
                      // 标题：注册
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 15,
                            decoration: BoxDecoration(
                              color: _primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '注册',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      const Text(
                        '未注册的邮箱验证成功后将自动注册',
                        style: TextStyle(fontSize: 14, color: Color(0xFF8A94A6)),
                      ),

                      SizedBox(height: compact ? 32 : 48),

                      // 表单
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // 邮箱
                            _buildEmailField(),
                            const SizedBox(height: 14),

                            // 验证码 + 发送按钮
                            _buildCodeField(),
                            const SizedBox(height: 14),

                            // 密码
                            _buildPasswordField(),
                            const SizedBox(height: 14),

                            // 确认密码
                            _buildConfirmPasswordField(),

                            // 提示信息
                            if (_hintText != null) ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _hintText!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _hintText!.contains('成功') || _hintText!.contains('发送')
                                        ? const Color(0xFF1FA86C)
                                        : const Color(0xFFE54848),
                                  ),
                                ),
                              ),
                            ],

                            SizedBox(height: compact ? 28 : 36),

                            // 注册按钮 — 内容空=浅灰，内容非空=蓝
                            _PrimaryButton(
                              text: _submitting ? '注册中...' : '注 册',
                              enabled: _canSubmit,
                              color: _primaryColor,
                              onPressed: _handleRegister,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 协议
                      _AgreementRow(
                        value: _agreed,
                        onChanged: (v) {
                          setState(() => _agreed = v ?? false);
                          if (_agreed) _setHint(null);
                        },
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

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      inputFormatters: [LengthLimitingTextInputFormatter(64)],
      validator: Validators.validateEmail,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: _inputDecoration(
        hint: '请输入邮箱地址',
        prefixIcon: Icons.alternate_email,
      ),
    );
  }

  Widget _buildCodeField() {
    return TextFormField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
      validator: (v) {
        if (v == null || v.isEmpty) return null;
        if (v.length < 4) return '验证码至少 4 位';
        return null;
      },
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: _inputDecoration(
        hint: '请输入验证码',
        prefixIcon: Icons.lock_outline,
      ).copyWith(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: TextButton(
            onPressed: _sendingCode ? null : _sendCode,
            style: TextButton.styleFrom(
              foregroundColor: _primaryColor,
              disabledForegroundColor: const Color(0xFFB0B7C3),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              _sendingCode ? '${_countdown}s 后重试' : '获取验证码',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      autocorrect: false,
      validator: Validators.validatePassword,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: _inputDecoration(
        hint: '请设置密码',
        prefixIcon: Icons.lock_outline,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      autocorrect: false,
      validator: (v) {
        if (v == null || v.isEmpty) return '请确认密码';
        if (v != _passwordController.text) return '两次输入的密码不一致';
        return null;
      },
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: _inputDecoration(
        hint: '请再次输入密码',
        prefixIcon: Icons.lock_outline,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFFB0B7C3), size: 20),
      filled: true,      
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFF2B7BFF), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE54848), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE54848), width: 1.4),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 2),
        ),
      ),
    );
  }
}

class _AgreementRow extends StatefulWidget {
  const _AgreementRow({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  State<_AgreementRow> createState() => _AgreementRowState();
}

class _AgreementRowState extends State<_AgreementRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Checkbox(
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: const Color(0xFF2B7BFF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              children: [
                const Text('我已阅读并同意 ', style: TextStyle(fontSize: 12, color: Color(0xFF8A94A6))),
                GestureDetector(
                  onTap: () {/* TODO: 跳转用户协议 */},
                  child: const Text('《用户协议》', style: TextStyle(fontSize: 12, color: Color(0xFF2B7BFF))),
                ),
                const Text('、', style: TextStyle(fontSize: 12, color: Color(0xFF8A94A6))),
                GestureDetector(
                  onTap: () {/* TODO: 跳转隐私政策 */},
                  child: const Text('《隐私政策》', style: TextStyle(fontSize: 12, color: Color(0xFF2B7BFF))),
                ),
                const Text(
                  '，未注册的邮箱验证成功后将自动注册。',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A94A6)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
