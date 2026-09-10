import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_storage.dart';
import '../data/user.dart';

class AuthState {
  const AuthState({this.accessToken, this.refreshToken, this.user});

  final String? accessToken;
  final String? refreshToken;
  final User? user;

  bool get isAuth => accessToken != null && accessToken!.isNotEmpty;

  AuthState copyWith({String? accessToken, String? refreshToken, User? user, bool clearUser = false}) => AuthState(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        user: clearUser ? null : (user ?? this.user),
      );
}

final initialAuthProvider = Provider<AuthState>((ref) => const AuthState());

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => ref.read(initialAuthProvider);

  Future<void> setTokens(String access, String refresh) async {
    state = state.copyWith(accessToken: access, refreshToken: refresh);
    final secure = ref.read(secureStorageProvider);
    await secure.write(key: SecureKeys.accessToken, value: access);
    await secure.write(key: SecureKeys.refreshToken, value: refresh);
  }

  Future<void> setUser(User user) async {
    state = state.copyWith(user: user);
    await ref.read(sharedPrefsProvider).setString(PrefsKeys.user, jsonEncode(user.toJson()));
  }

  Future<void> clear() async {
    state = const AuthState();
    final secure = ref.read(secureStorageProvider);
    await secure.delete(key: SecureKeys.accessToken);
    await secure.delete(key: SecureKeys.refreshToken);
    final prefs = ref.read(sharedPrefsProvider);
    final language = prefs.getString(PrefsKeys.language);
    final deviceToken = prefs.getString(PrefsKeys.deviceToken);
    await prefs.clear();
    if (language != null) await prefs.setString(PrefsKeys.language, language);
    if (deviceToken != null) await prefs.setString(PrefsKeys.deviceToken, deviceToken);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final currentUserProvider = Provider<User?>((ref) => ref.watch(authProvider).user);
final isAuthProvider = Provider<bool>((ref) => ref.watch(authProvider).isAuth);
