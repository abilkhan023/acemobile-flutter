import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/app_storage.dart';

const supportedLocales = [Locale('ru'), Locale('en'), Locale('kk')];

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final code = ref.read(sharedPrefsProvider).getString(PrefsKeys.language);
    return switch (code) {
      'en' => const Locale('en'),
      'kk' || 'kz' => const Locale('kk'),
      _ => const Locale('ru'),
    };
  }

  Future<void> set(Locale locale) async {
    state = locale;
    await ref.read(sharedPrefsProvider).setString(PrefsKeys.language, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);
