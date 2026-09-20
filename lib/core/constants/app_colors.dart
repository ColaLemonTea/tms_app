import 'package:flutter/material.dart';

/// 全局统一配色（与登录/注册页保持一致）
class AppColors {
  AppColors._();

  /// 主色调 - 蓝
  static const Color primary = Color(0xFF2B7BFF);

  /// 主色浅底（用于图标背景、标签底）
  static const Color primaryLight = Color(0xFFEFF6FF);

  /// 装饰条 - 青
  static const Color accent = Color(0xFF4FE0CB);

  /// 页面背景
  static const Color background = Color(0xFFF5F7FA);

  /// 卡片背景
  static const Color card = Colors.white;

  /// 输入框/次级填充
  static const Color fieldFill = Color(0xFFF5F7FA);

  /// 主文字
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// 次文字
  static const Color textSecondary = Color(0xFF8A94A6);

  /// 占位/提示文字
  static const Color textHint = Color(0xFFB0B7C3);

  /// 分割线 / 边框
  static const Color border = Color(0xFFE0E2E6);

  /// 禁用态
  static const Color disabled = Color(0xFFF2F3F5);

  /// 成功 - 绿
  static const Color success = Color(0xFF1FA86C);

  /// 警告 - 橙
  static const Color warning = Color(0xFFF5A623);

  /// 错误 - 红
  static const Color error = Color(0xFFE54848);
}
