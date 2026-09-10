import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/env.dart';
import '../../clubs/data/models.dart';

class Product {
  const Product({required this.id, this.description, this.price, this.thumbnailUrl, this.name});

  final String id;
  final String? description;
  final num? price;
  final String? thumbnailUrl;
  final String? name;

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: (j['_id'] ?? j['id'] ?? '').toString(),
        description: j['description']?.toString(),
        price: j['price'] is num ? j['price'] as num : num.tryParse(j['price']?.toString() ?? ''),
        thumbnailUrl: j['thumbnail_url']?.toString(),
        name: j['name']?.toString(),
      );

  Map<String, dynamic> toJson() => {'_id': id, 'description': description, 'price': price, 'thumbnail_url': thumbnailUrl, 'name': name};
}

class ShopApi {
  ShopApi(this._shop, this._file);

  final Dio _shop;
  final Dio _file;

  Future<List<Product>> warehouses() => apiCall(
        () => _shop.get('/warehouses/', queryParameters: {'game_center_id': Env.shopGameCenterId}),
        (d) => unwrapList(d, Product.fromJson),
      );

  Future<String?> fileUrl(String id) => apiCall(() => _file.get('/$id'), (d) => d is Map ? d['url']?.toString() : d?.toString());
}

final shopApiProvider = Provider<ShopApi>((ref) => ShopApi(ref.watch(shopDioProvider), ref.watch(fileDioProvider)));
final warehousesProvider = FutureProvider<List<Product>>((ref) => ref.watch(shopApiProvider).warehouses());
final productImageProvider = FutureProvider.family<String?, String>((ref, thumb) async {
  if (thumb.startsWith('http')) return thumb;
  return ref.watch(shopApiProvider).fileUrl(thumb);
});
