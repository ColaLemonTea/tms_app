import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/validators.dart';

/// 登录页（含自动注册逻辑）
/// - 邮箱 + 验证码 登录
/// - 未注册的邮箱在验证通过后将自动完成注册
/// - 布局针对不同屏幕尺寸做了适配（短屏压缩间距、长屏居中、键盘弹出可滚动）
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // 主题色：蓝色
  static const Color _primaryColor = Color(0xFF2B7BFF);
  static const Color _accentColor = Color(0xFF4FE0CB); // 装饰条
  static const Color _fieldFill = Color(0xFFF5F7FA);
  static const Color _textSecondary = Color(0xFF8A94A6);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  bool _agreed = false;
  bool _sendingCode = false;
  bool _submitting = false;
  int _countdown = 0;
  Timer? _timer;

  // 提示信息（轻量反馈，不弹 SnackBar）
  String? _hintText;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
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
    });
    _setHint('验证码已发送至您的邮箱，5 分钟内有效');

    // TODO: 调用发送验证码 API
    // 倒计时
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

  /// 登录（自动注册）
  Future<void> _handleLogin() async {
    if (_submitting) return;

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

    // TODO: 调用登录/注册 API
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _submitting = false);
    _setHint('登录成功！');
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    // 短屏压缩、长屏居中
    final screenHeight = mq.size.height - mq.padding.top - mq.padding.bottom;
    final bool compact = screenHeight < 720;

    return Scaffold(
      backgroundColor: Colors.white,
      // 键盘弹起时自动调整
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
                      // ============ 顶部：返回按钮 ============
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 22,
                        ),
                      ),

                      // ============ 标题区 + 右侧装饰图 ============
                      SizedBox(height: compact ? 16 : 32),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 左侧：装饰条 + 标题
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: _accentColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '欢迎登录',
                                      style: TextStyle(
                                        fontSize: compact ? 14 : 16,
                                        color: _textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'TMS 企业版',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // 右侧：装饰 mascot 占位
                          _buildMascot(compact),
                        ],
                      ),

                      SizedBox(height: compact ? 28 : 48),

                      // ============ 表单 ============
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // 邮箱输入框
                            _EmailField(
                              controller: _emailController,
                              fillColor: _fieldFill,
                              onChanged: (_) => _setHint(null),
                            ),
                            const SizedBox(height: 14),

                            // 验证码输入框 + 发送按钮
                            _CodeField(
                              controller: _codeController,
                              fillColor: _fieldFill,
                              sending: _sendingCode,
                              countdown: _countdown,
                              onSend: _sendCode,
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

                            SizedBox(height: compact ? 20 : 28),

                            // 登录按钮
                            _PrimaryButton(
                              text: _submitting ? '登录中...' : '登 录',
                              onPressed: _submitting ? null : _handleLogin,
                              color: _primaryColor,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ============ 协议复选框 ============
                      _AgreementRow(
                        value: _agreed,
                        onChanged: (v) {
                          setState(() => _agreed = v ?? false);
                          if (_agreed) _setHint(null);
                        },
                        primaryColor: _primaryColor,
                        textColor: _textSecondary,
                      ),

                      const Spacer(),

                      // 底部说明
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '© TMS 智能运输管理平台',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                        ),
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

  /// 右上角装饰 mascot（占位）— 实际可换成 Image.asset
  Widget _buildMascot(bool compact) {
    final size = compact ? 72.0 : 96.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(size),
      ),
      child: Icon(
        Icons.smart_toy_outlined,
        size: size * 0.55,
        color: _primaryColor,
      ),
    );
  }
}

// =====================================================================
// 组件拆分
// =====================================================================

class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.fillColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Color fillColor;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      inputFormatters: [LengthLimitingTextInputFormatter(64)],
      onChanged: onChanged,
      validator: Validators.validateEmail,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: _inputDecoration(
        hint: '请输入邮箱地址',
        prefixIcon: Icons.alternate_email,
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFFB0B7C3), size: 20),
      filled: true,
      fillColor: fillColor,
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
    );
  }
}

class _CodeField extends StatelessWidget {
  const _CodeField({
    required this.controller,
    required this.fillColor,
    required this.sending,
    required this.countdown,
    required this.onSend,
  });

  final TextEditingController controller;
  final Color fillColor;
  final bool sending;
  final int countdown;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
      validator: (v) {
        if (v == null || v.isEmpty) return null; // 由按钮点击时统一提示
        if (v.length < 4) return '验证码至少 4 位';
        return null;
      },
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        hintText: '请输入验证码',
        hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 15),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFB0B7C3), size: 20),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        // 右侧发送按钮
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: TextButton(
            onPressed: sending ? null : onSend,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2B7BFF),
              disabledForegroundColor: const Color(0xFFB0B7C3),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              sending ? '${countdown}s 后重试' : '获取验证码',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, required this.onPressed, required this.color});

  final String text;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? const Color(0xFFB8D1FF) : color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFB8D1FF),
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

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({
    required this.value,
    required this.onChanged,
    required this.primaryColor,
    required this.textColor,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color primaryColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
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
                Text('我已阅读并同意 ', style: TextStyle(fontSize: 12, color: textColor)),
                _LinkText(text: '《用户协议》', color: primaryColor),
                Text('、', style: TextStyle(fontSize: 12, color: textColor)),
                _LinkText(text: '《隐私政策》', color: primaryColor),
                Text(
                  '，未注册的邮箱验证成功后将自动注册。',
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LinkText extends StatelessWidget {
  const _LinkText({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: 跳转协议详情
      },
      child: Text(text, style: TextStyle(fontSize: 12, color: color)),
    );
  }
}
