import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import 'user.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<String> loginMobile({required String username, required String password}) => apiCall(
        () => _dio.post('/auth/mobile', data: {'username': username, 'password': password}),
        (d) => d['token'] as String,
      );

  Future<String> registerEmail({required String username, required String email, required String password}) => apiCall(
        () => _dio.post('/auth/email', data: {'username': username, 'email': email, 'password': password}),
        (d) => d['token'] as String,
      );

  Future<void> resetPassword(String email) => apiCall<void>(() => _dio.post('/auth/reset_password', data: {'email': email}));

  Future<String> deepLink(String uuid) => apiCall(() => _dio.get('/auth/deep_link/$uuid'), (d) => d['token'] as String);

  Future<void> desktopLogin({required String computerId, required String bearer}) =>
      apiCall<void>(() => _dio.post('/auth/desktop', data: {'computer_id': computerId, 'token': bearer}));

  Future<User> me() => apiCall(() => _dio.get('/users/me'), (d) => User.fromJson(Map<String, dynamic>.from(d as Map)));

  Future<void> registerDevice(String token) => apiCall<void>(() => _dio.post('/users/devices', data: {'token': token}));

  Future<void> unregisterDevice(String token) => apiCall<void>(() => _dio.delete('/users/devices', data: {'token': token}));

  Future<void> deleteUser(String id) => apiCall<void>(() => _dio.delete('/users/$id'));

  Future<void> changePassword({required String id, required String password}) =>
      apiCall<void>(() => _dio.patch('/users/$id', data: {'password': password}));
}

final authApiProvider = Provider<AuthApi>((ref) => AuthApi(ref.watch(coreDioProvider)));
