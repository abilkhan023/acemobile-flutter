import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/storage/app_storage.dart';
import 'features/auth/data/user.dart';
import 'features/auth/providers/auth_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  ));

  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(overrides: [sharedPrefsProvider.overrideWithValue(prefs)]);
  final secure = container.read(secureStorageProvider);
  String? access;
  String? refresh;
  try {
    access = await secure.read(key: SecureKeys.accessToken);
    refresh = await secure.read(key: SecureKeys.refreshToken);
  } on PlatformException {
    access = null;
    refresh = null;
  }
  User? user;
  final userJson = prefs.getString(PrefsKeys.user);
  if (userJson != null) {
    try {
      user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (_) {
      user = null;
    }
  }
  container.dispose();

  runApp(ProviderScope(
    overrides: [
      sharedPrefsProvider.overrideWithValue(prefs),
      initialAuthProvider.overrideWithValue(AuthState(accessToken: access, refreshToken: refresh, user: user)),
    ],
    child: const AceApp(),
  ));
}
