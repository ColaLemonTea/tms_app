import 'dart:convert';
import 'package:web/web.dart' as web;

/// 浏览器指纹收集工具
///
/// 参考 React 端 collectDeviceInfo()，收集浏览器特征生成指纹
class Fingerprint {
  Fingerprint._();

  /// 收集设备信息并生成指纹（同步）
  static String collectDeviceInfo() {
    final navigator = web.window.navigator;
    final screen = web.window.screen;

    final deviceInfo = {
      // 浏览器信息
      'userAgent': navigator.userAgent,
      'language': navigator.language,
      'languages': navigator.languages,
      'platform': navigator.platform,
      'hardwareConcurrency': navigator.hardwareConcurrency,
      'maxTouchPoints': navigator.maxTouchPoints,

      // 屏幕信息
      'screenWidth': screen.width,
      'screenHeight': screen.height,
      'screenColorDepth': screen.colorDepth,
      'screenPixelDepth': screen.pixelDepth,

      // 时区
      'timezone': DateTime.now().timeZoneName,
      'timezoneOffset': DateTime.now().timeZoneOffset.inMinutes,

      // 其他
      'cookieEnabled': navigator.cookieEnabled,
    };

    // 生成简单哈希作为指纹
    return _generateHash(deviceInfo);
  }

  /// 生成简单的哈希值
  static String _generateHash(Map<String, dynamic> info) {
    final jsonString = jsonEncode(info);
    return _simpleHash(jsonString);
  }

  /// 简单的字符串哈希算法
  static String _simpleHash(String input) {
    int hash = 0;
    for (int i = 0; i < input.length; i++) {
      final char = input.codeUnitAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // Convert to 32-bit integer
    }
    // 转为正数的十六进制字符串
    return (hash.abs()).toRadixString(16).padLeft(8, '0');
  }

  /// 获取 UserAgent
  static String getUserAgent() {
    return web.window.navigator.userAgent;
  }
}
