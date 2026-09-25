import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../env.dart';
import 'api_exception.dart';
import 'hidden_clubs.dart';

Dio _createDio(String baseUrl, Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
    responseType: ResponseType.json,
  ));
  dio.interceptors.add(AuthInterceptor(ref, dio));
  dio.interceptors.add(HiddenClubsInterceptor());
  return dio;
}

final coreDioProvider = Provider<Dio>((ref) => _createDio(Env.coreUrl, ref));
final shopDioProvider = Provider<Dio>((ref) => _createDio(Env.shopUrl, ref));
final bankingDioProvider = Provider<Dio>((ref) => _createDio(Env.bankingUrl, ref));
final fileDioProvider = Provider<Dio>((ref) => _createDio(Env.fileUrl, ref));

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._ref, this._dio);

  final Ref _ref;
  final Dio _dio;
  Future<String?>? _refreshing;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _ref.read(authProvider).accessToken;
    if (token != null && token.isNotEmpty && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 || err.requestOptions.extra['retried'] == true) {
      return handler.next(err);
    }
    final auth = _ref.read(authProvider.notifier);
    final newToken = await (_refreshing ??= _refresh().whenComplete(() => _refreshing = null));
    if (newToken == null) {
      await auth.clear();
      return handler.next(err);
    }
    final opts = err.requestOptions;
    opts.headers['Authorization'] = 'Bearer $newToken';
    opts.extra['retried'] = true;
    try {
      final response = await _dio.fetch(opts);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<String?> _refresh() async {
    final state = _ref.read(authProvider);
    final refresh = state.refreshToken;
    if (refresh == null || refresh.isEmpty) return null;
    try {
      final res = await Dio(BaseOptions(baseUrl: Env.coreUrl)).post('/auth/refresh/', data: {'refreshToken': refresh});
      final data = res.data;
      if (data is! Map) return null;
      final access = data['accessToken'] as String?;
      if (access == null || access.isEmpty) return null;
      await _ref.read(authProvider.notifier).setTokens(access, data['refreshToken'] as String? ?? refresh);
      return access;
    } catch (_) {
      return null;
    }
  }
}

Future<T> apiCall<T>(Future<Response<dynamic>> Function() request, [T Function(dynamic data)? map]) async {
  try {
    final res = await request();
    final data = res.data;
    if (map != null) return map(data);
    return data as T;
  } on DioException catch (e) {
    throw ApiException(status: e.response?.statusCode, body: e.response?.data, cause: e);
  }
}
