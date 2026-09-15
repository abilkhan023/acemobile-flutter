import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_storage.dart';

const _key = 'favorite_clubs';

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => (ref.watch(sharedPrefsProvider).getStringList(_key) ?? const []).toSet();

  void toggle(String branchId) {
    final next = {...state};
    if (!next.remove(branchId)) next.add(branchId);
    state = next;
    ref.read(sharedPrefsProvider).setStringList(_key, next.toList());
  }
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);
