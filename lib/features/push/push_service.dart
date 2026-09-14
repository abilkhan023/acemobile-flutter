import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_token.dart';

class PushService {
  PushService(this._ref);

  final Ref _ref;
  bool _started = false;

  Future<void> init() async {
    if (_started) return;
    _started = true;
    try {
      await Firebase.initializeApp();
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(alert: true, badge: true, sound: true);
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return;
      }
      if (Platform.isIOS) {
        await messaging.getAPNSToken();
      }
      final token = await messaging.getToken();
      if (token != null) await _ref.read(deviceTokenProvider.notifier).set(token);
      messaging.onTokenRefresh.listen((t) => _ref.read(deviceTokenProvider.notifier).set(t));
    } catch (_) {}
  }
}

final pushServiceProvider = Provider<PushService>((ref) => PushService(ref));
