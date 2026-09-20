import 'package:dio/dio.dart';
import '../../core/constants/api_config.dart';
import '../../core/utils/fingerprint.dart';

/// 统一 HTTP 请求服务
///
/// 使用示例：
/// ```dart
/// final res = await HttpService.instance.post('/auth/send-code', data: {'email': 'a@b.com'});
/// final res = await HttpService.instance.get('/user/profile');
/// ```
class HttpService {
  HttpService._();

  static HttpService? _instance;
  late final Dio _dio;

  /// 获取单例
  static HttpService get instance {
    _instance ??= HttpService._().._init();
    return _instance!;
  }

  void _init() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 拦截器：日志 + 统一错误处理 + Token 注入
    _dio.interceptors.add(_HttpInterceptor());
  }

  // ---- 请求方法 ----

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    return _dio.get(path, queryParameters: queryParameters, cancelToken: cancelToken);
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.post(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.put(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.delete(path, data: data, cancelToken: cancelToken);
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return _dio.patch(path, data: data, cancelToken: cancelToken);
  }

  // ---- Token 管理 ----

  static String? _token;

  /// 登录后保存 token
  static void setToken(String token) => _token = token;

  /// 退出登录清除 token
  static void clearToken() => _token = null;

  static String? get token => _token;
}

/// 请求/响应拦截器
class _HttpInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 自动注入 Token
    if (HttpService.token != null) {
      options.headers['Authorization'] = 'Bearer ${HttpService.token}';
    }

    // 添加浏览器指纹和 UserAgent
    final fingerprint = Fingerprint.collectDeviceInfo();
    options.headers['X-Fingerprint'] = fingerprint;
    options.headers['X-UA'] = Fingerprint.getUserAgent();

    if (ApiConfig.isDev) {
      // ignore: avoid_print
      print('══════════ REQUEST ══════════');
      // ignore: avoid_print
      print('🌐 [${options.method}] ${options.uri} ${options.headers}');
      // ignore: avoid_print
      print('🔑 Fingerprint: $fingerprint');
      if (options.data != null) {
        // ignore: avoid_print
        print('📦 Body: ${options.data}');
      }
      // ignore: avoid_print
      print('═════════════════════════════');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (ApiConfig.isDev) {
      // ignore: avoid_print
      print('══════════ RESPONSE ══════════');
      // ignore: avoid_print
      print('✅ [${response.statusCode}] ${response.requestOptions.uri}');
      if (response.data != null) {
        // ignore: avoid_print
        print('📦 Data: ${response.data}');
      }
      // ignore: avoid_print
      print('══════════════════════════════');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (ApiConfig.isDev) {
      // ignore: avoid_print
      print('══════════ ERROR ══════════');
      // ignore: avoid_print
      print('❌ [${err.response?.statusCode}] ${err.requestOptions.uri}');
      // ignore: avoid_print
      print('Message: ${err.message}');
      if (err.response?.data != null) {
        // ignore: avoid_print
        print('📦 Data: ${err.response?.data}');
      }
      // ignore: avoid_print
      print('═══════════════════════════');
    }

    // 统一错误处理：仅在无业务错误消息时覆盖
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          message: '网络连接超时，请稍后重试',
        );
        break;
      case DioExceptionType.connectionError:
        err = DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: err.type,
          message: '网络连接失败，请检查网络设置',
        );
        break;
      case DioExceptionType.badResponse:
        // 尝试提取服务端返回的错误消息
        final data = err.response?.data;
        String? serverMsg;
        if (data is Map<String, dynamic>) {
          serverMsg = data['message'] as String?;
        }
        if (serverMsg != null && serverMsg.isNotEmpty) {
          err = DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: err.type,
            message: serverMsg,
          );
        }
        break;
      default:
        break;
    }

    handler.next(err);
  }
}
