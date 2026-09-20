import 'package:dio/dio.dart';
import 'http_service.dart';

/// 认证相关 API
///
/// 参考 React 端 authApi.ts：
/// - 登录: POST /sys/login/detail  → LoginResponse
/// - 发送验证码: POST /sys/register/send-captcha → CaptchaResponse
/// - 注册: POST /sys/register/signup → RegisterResponse
class AuthApi {
  AuthApi._();

  /// 登录
  /// 请求: { username, password }
  /// 响应: { token, refreshToken, expireTime, userInfo, menus, roles, permissions }
  static Future<Response<dynamic>> login({
    required String username,
    required String password,
  }) {
    return HttpService.instance.post('/sys/login/detail', data: {
      'username': username,
      'password': password,
    });
  }

  /// 发送邮箱验证码
  /// 请求: { username (邮箱), type }
  /// 响应: { token (验证码凭证), message }
  static Future<Response<dynamic>> sendCaptcha({
    required String username,
    required String type,
  }) {
    return HttpService.instance.post('/sys/register/send-captcha', data: {
      'username': username,
      'type': type,
    });
  }

  /// 注册
  /// 请求: { username (邮箱), password, token (验证码凭证), code, type }
  /// 响应: { message }
  static Future<Response<dynamic>> register({
    required String username,
    required String password,
    required String token,
    required int code,
    required String type,
  }) {
    return HttpService.instance.post('/sys/register/signup', data: {
      'username': username,
      'password': password,
      'token': token,
      'code': code,
      'type': type,
    });
  }
}