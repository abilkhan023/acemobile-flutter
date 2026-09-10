import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/app_storage.dart';

class DeviceTokenNotifier extends Notifier<String?> {
  @override
  String? build() => ref.read(sharedPrefsProvider).getString(PrefsKeys.deviceToken);

  Future<void> set(String? token) async {
    state = token;
    final prefs = ref.read(sharedPrefsProvider);
    if (token == null) {
      await prefs.remove(PrefsKeys.deviceToken);
    } else {
      await prefs.setString(PrefsKeys.deviceToken, token);
    }
  }
}

final deviceTokenProvider = NotifierProvider<DeviceTokenNotifier, String?>(DeviceTokenNotifier.new);
