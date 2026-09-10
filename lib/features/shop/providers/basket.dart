import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/app_storage.dart';
import '../data/shop_api.dart';

class BasketItem {
  const BasketItem({required this.product, required this.total});

  final Product product;
  final int total;

  BasketItem copyWith({int? total}) => BasketItem(product: product, total: total ?? this.total);

  Map<String, dynamic> toJson() => {...product.toJson(), 'total': total};

  factory BasketItem.fromJson(Map<String, dynamic> j) => BasketItem(product: Product.fromJson(j), total: (j['total'] as num?)?.toInt() ?? 1);
}

class BasketNotifier extends Notifier<List<BasketItem>> {
  @override
  List<BasketItem> build() {
    final raw = ref.read(sharedPrefsProvider).getString(PrefsKeys.basket);
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      return [for (final e in list) BasketItem.fromJson(Map<String, dynamic>.from(e as Map))];
    } catch (_) {
      return const [];
    }
  }

  void _persist() => ref.read(sharedPrefsProvider).setString(PrefsKeys.basket, jsonEncode([for (final i in state) i.toJson()]));

  int totalOf(String id) => state.where((i) => i.product.id == id).firstOrNull?.total ?? 0;

  void add(Product p) {
    if (state.any((i) => i.product.id == p.id)) return;
    state = [...state, BasketItem(product: p, total: 1)];
    _persist();
  }

  void increment(Product p) {
    state = [for (final i in state) i.product.id == p.id ? i.copyWith(total: i.total + 1) : i];
    _persist();
  }

  void decrement(Product p) {
    state = [for (final i in state) i.product.id == p.id ? i.copyWith(total: i.total - 1) : i];
    _persist();
  }

  void remove(Product p) {
    state = [for (final i in state) if (i.product.id != p.id) i];
    _persist();
  }
}

final basketProvider = NotifierProvider<BasketNotifier, List<BasketItem>>(BasketNotifier.new);

final basketTotalProvider = Provider<num>((ref) => ref.watch(basketProvider).fold<num>(0, (acc, i) => acc + i.total * (i.product.price ?? 0)));
