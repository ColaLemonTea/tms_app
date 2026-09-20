/// 高德地图配置
///
/// 使用前请到高德开放平台申请 Key：
/// https://console.amap.com/dev/key/app
///
/// - Android Key：需绑定「包名 + SHA1」
///   - 包名见 android/app/build.gradle.kts 中的 applicationId
///   - 获取 SHA1：`cd android && ./gradlew signingReport`
/// - iOS Key：需绑定 Bundle Identifier
///   - 见 ios/Runner.xcodeproj/project.pbxproj 的 PRODUCT_BUNDLE_IDENTIFIER
class AmapConfig {
  AmapConfig._();

  /// 请替换为你自己的 Key
  static const String androidKey = 'YOUR_ANDROID_AMAP_KEY';
  static const String iosKey = 'YOUR_IOS_AMAP_KEY';

  /// 隐私合规：上架前必须让用户确认隐私政策后再设为 true
  /// 开发调试阶段可临时设 true 以显示地图
  static const bool privacyAgreed = true;

  /// 默认地图缩放级别与中心点（北京天安门）
  static const double defaultZoom = 14;
  static const double defaultLat = 39.909187;
  static const double defaultLng = 116.397451;
}
