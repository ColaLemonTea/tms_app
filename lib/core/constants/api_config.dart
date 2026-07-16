/// API 环境配置
///
/// 切换环境：
/// - 开发：将 [current] 指向 [dev]
/// - 生产：将 [current] 指向 [prod]
///
/// 后续可根据 kReleaseMode 自动切换，或通过 flavor 控制。
// ignore_for_file: library_private_types_in_public_api
class ApiConfig {
  ApiConfig._();

  // ============ 环境定义 ============

  /// 开发环境
  static const _Environment dev = _Environment(
    name: 'dev',
    baseUrl: 'http://localhost:8080',
    connectTimeout: Duration(seconds: 15),
    receiveTimeout: Duration(seconds: 15),
    sendTimeout: Duration(seconds: 10),
  );

  /// 生产环境（上线前填入正式地址）
  static const _Environment prod = _Environment(
    name: 'prod',
    baseUrl: 'https://api.your-company.com', // TODO: 替换为正式地址
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    sendTimeout: Duration(seconds: 10),
  );

  // ============ 当前环境（在这里切换） ============
  static const _Environment current = dev;

  // ============ 便捷访问 ============
  static String get envName => current.name;
  static String get baseUrl => current.baseUrl;
  static Duration get connectTimeout => current.connectTimeout;
  static Duration get receiveTimeout => current.receiveTimeout;
  static Duration get sendTimeout => current.sendTimeout;
  static bool get isDev => current.name == 'dev';
  static bool get isProd => current.name == 'prod';
}

class _Environment {
  final String name;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  const _Environment({
    required this.name,
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
  });
}
