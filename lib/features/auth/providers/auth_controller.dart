import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../push/device_token.dart';
import '../data/auth_api.dart';
import 'auth_provider.dart';

class AuthController {
  AuthController(this._ref);

  final Ref _ref;

  AuthApi get _api => _ref.read(authApiProvider);
  AuthNotifier get _auth => _ref.read(authProvider.notifier);

  Future<void> loginWithToken(String token) async {
    await _auth.setTokens(token, '');
    final user = await _api.me();
    await _auth.setUser(user);
    final deviceToken = _ref.read(deviceTokenProvider);
    if (deviceToken != null && deviceToken.isNotEmpty) {
      try {
        await _api.registerDevice(deviceToken);
      } on ApiException {
        // device registration is best-effort
      }
    }
  }

  Future<void> login({required String username, required String password}) async {
    final token = await _api.loginMobile(username: username.toLowerCase(), password: password);
    await loginWithToken(token);
  }

  Future<void> register({required String username, required String email, required String password}) async {
    final token = await _api.registerEmail(username: username.toLowerCase(), email: email.toLowerCase(), password: password);
    await loginWithToken(token);
  }

  Future<void> loginByDeepLink(String uuid) async {
    final token = await _api.deepLink(uuid);
    await loginWithToken(token);
  }

  Future<void> logout() async {
    final deviceToken = _ref.read(deviceTokenProvider);
    if (deviceToken != null && deviceToken.isNotEmpty && _ref.read(authProvider).isAuth) {
      try {
        await _api.unregisterDevice(deviceToken);
      } catch (_) {}
    }
    await _auth.clear();
  }

  Future<void> deleteAccount() async {
    final id = _ref.read(authProvider).user?.id;
    if (id == null) throw ApiException(body: 'no user');
    await _api.deleteUser(id);
    await _auth.clear();
  }

  Future<void> changePassword(String password) async {
    final id = _ref.read(authProvider).user?.id;
    if (id == null) throw ApiException(body: 'no user');
    await _api.changePassword(id: id, password: password);
  }

  Future<void> refreshMe() async {
    final user = await _api.me();
    await _auth.setUser(user);
  }
}

final authControllerProvider = Provider<AuthController>((ref) => AuthController(ref));
