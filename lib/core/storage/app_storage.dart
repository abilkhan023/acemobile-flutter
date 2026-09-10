import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class PrefsKeys {
  static const user = 'user';
  static const deviceToken = 'device_token';
  static const basket = 'basket';
  static const language = 'language';
  static const bookDate = 'book_date';
  static const datetime = 'datetime';
}

abstract final class SecureKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError('overridden in bootstrap'));

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
  );
});
