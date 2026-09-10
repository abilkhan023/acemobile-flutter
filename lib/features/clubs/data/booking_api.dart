import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/env.dart';
import 'booking_models.dart';
import 'models.dart';

class BookingApi {
  BookingApi(this._dio);

  final Dio _dio;

  Future<List<Zone>> zones(String branchId) =>
      apiCall(() => _dio.get('/zones', queryParameters: {'branch_id': branchId}), (d) => unwrapList(d, Zone.fromJson));

  Future<List<Computer>> computersByZone(String zoneId) =>
      apiCall(() => _dio.get('/computers', queryParameters: {'zone_id': zoneId}), (d) => unwrapList(d, Computer.fromJson));

  Future<List<Computer>> computersMap({required String branchId, required String datetime}) => apiCall(
        () => _dio.get('/computers/map', queryParameters: {'branch_id': branchId, 'datetime': datetime}),
        (d) => unwrapList(d, Computer.fromJson),
      );

  Future<String?> serverDatetime() => apiCall(() => _dio.get('/healthcheck'), (d) => d is Map ? d['datetime']?.toString() : null);

  Future<List<Tariff>> availableTariffs({required String zoneId, required String datetime}) => apiCall(
        () => _dio.get('/tariffs/available', queryParameters: {
          'zone_id_in': zoneId,
          'datetime': datetime,
          'insert_property': true,
          'timezone': Env.timezone,
        }),
        (d) => unwrapList(d, Tariff.fromJson),
      );

  Future<Tariff> tariff(String id) => apiCall(
        () => _dio.get('/tariffs/$id', queryParameters: {'timezone': Env.timezone}),
        (d) => Tariff.fromJson(Map<String, dynamic>.from(d as Map)),
      );

  Future<String> createUserTariff({required String tariffId, required String gameCenterId, required String branchId}) => apiCall(
        () => _dio.post('/user_tariffs/$tariffId', data: {'game_center_id': gameCenterId, 'branch_id': branchId, 'timezone': Env.timezone}),
        (d) => (d as Map)['id'].toString(),
      );

  Future<List<Wallet>> wallets({required String userId, String? gameCenterId}) => apiCall(
        () => _dio.get('/wallets', queryParameters: {'user_id': userId, 'game_center_id': ?gameCenterId}),
        (d) => unwrapList(d, Wallet.fromJson),
      );
}

final bookingApiProvider = Provider<BookingApi>((ref) => BookingApi(ref.watch(coreDioProvider)));
