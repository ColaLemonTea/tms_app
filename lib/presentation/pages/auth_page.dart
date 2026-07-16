import 'package:flutter/material.dart';

/// 认证入口页
/// - 顶部：返回按钮 + 装饰条 + "欢迎登录" + "TMS 企业版" + Logo 占位
/// - 下方：两个纵向排列按钮（登录 / 注册）
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static const Color _primaryColor = Color(0xFF2B7BFF);
  static const Color _accentColor = Color(0xFF4FE0CB);
  static const Color _textSecondary = Color(0xFF8A94A6);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenHeight = mq.size.height - mq.padding.top - mq.padding.bottom;
    final bool compact = screenHeight < 720;

    return Scaffold(
      backgroundColor: Colors.white,
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
                      // ========== 返回按钮 ==========
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

                      SizedBox(height: compact ? 24 : 70),

                      // ========== 头部：装饰条 + 标题 + Logo ==========
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 装饰条 + 欢迎登录
                                Row(
                                  children: [
                                    Container(
                                      width: 4,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: _primaryColor,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      '欢迎登录',
                                      style: TextStyle(fontSize: 16, color: _textSecondary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'TMS 企业版',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A),
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Logo 占位
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.business_rounded,
                              size: 38,
                              color: _primaryColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: compact ? 30: 70),
                      // const Spacer(),

                      // ========== 两个按钮 ==========
                      // 登录按钮 — 蓝底白字
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            '登录',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 注册按钮 — 浅灰底 + 描边 + 黑字
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF2F3F5),
                            foregroundColor: const Color(0xFF1A1A1A),
                            side: const BorderSide(color: Color(0xFFE0E2E6), width: 1),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            '注册',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      SizedBox(height: compact ? 30: 70),
                      const Spacer(),

                      const Text(
                        '©2026 TMS 企业版',
                        style: TextStyle(fontSize: 10, color: _textSecondary),
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
}
