import 'http_service.dart';

/// 用户信息
class UserInfo {
  final int id;
  final String username;
  final String? role;
  final String? department;

  const UserInfo({
    required this.id,
    required this.username,
    this.role,
    this.department,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as int,
      username: json['username'] as String,
      role: json['role'] as String?,
      department: json['department'] as String?,
    );
  }
}

/// 全局认证状态管理
///
/// 单例模式，全局可访问。
/// 登录成功后保存 token、用户信息、菜单权限等，
/// 供页面跳转、权限判断等场景使用。
class AuthManager {
  AuthManager._();
  static final AuthManager _instance = AuthManager._();
  static AuthManager get instance => _instance;

  String? _token;
  String? _refreshToken;
  String? _expireTime;
  UserInfo? _userInfo;
  List<dynamic>? _menus;
  List<dynamic>? _roles;
  List<String>? _permissions;

  /// 访问令牌
  String? get token => _token;

  /// 刷新令牌
  String? get refreshToken => _refreshToken;

  /// 过期时间
  String? get expireTime => _expireTime;

  /// 当前用户信息
  UserInfo? get userInfo => _userInfo;

  /// 菜单列表
  List<dynamic>? get menus => _menus;

  /// 角色列表
  List<dynamic>? get roles => _roles;

  /// 权限列表
  List<String>? get permissions => _permissions;

  /// 是否已登录
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;

  /// 登录成功后保存完整信息
  void setLoginInfo(Map<String, dynamic> data) {
    _token = data['token'] as String?;
    _refreshToken = data['refreshToken'] as String?;
    _expireTime = data['expireTime'] as String?;

    if (data['userInfo'] != null) {
      _userInfo = UserInfo.fromJson(data['userInfo'] as Map<String, dynamic>);
    }

    _menus = data['menus'] as List<dynamic>?;
    _roles = data['roles'] as List<dynamic>?;
    _permissions = (data['permissions'] as List<dynamic>?)?.cast<String>();

    // 同步 token 到 HttpService，后续请求自动携带
    if (_token != null) {
      HttpService.setToken(_token!);
    }
  }

  /// 清空登录状态（退出登录）
  void clear() {
    _token = null;
    _refreshToken = null;
    _expireTime = null;
    _userInfo = null;
    _menus = null;
    _roles = null;
    _permissions = null;
    HttpService.clearToken();
  }
}