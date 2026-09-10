import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import 'models.dart';

class ClubsApi {
  ClubsApi(this._dio);

  final Dio _dio;

  Future<List<Branch>> branches({bool? isAvailable}) => apiCall(
        () => _dio.get('/branches', queryParameters: {'is_available': ?isAvailable}),
        (d) => unwrapList(d, Branch.fromJson),
      );

  Future<Branch> branch(String id) => apiCall(() => _dio.get('/branches/$id'), (d) => Branch.fromJson(Map<String, dynamic>.from(d as Map)));

  Future<List<GameCenter>> gameCenters({bool? isAvailable}) => apiCall(
        () => _dio.get('/game_centers', queryParameters: {'is_available': ?isAvailable}),
        (d) => unwrapList(d, GameCenter.fromJson),
      );

  Future<GameCenter> gameCenter(String id) =>
      apiCall(() => _dio.get('/game_centers/$id'), (d) => GameCenter.fromJson(Map<String, dynamic>.from(d as Map)));
}

final clubsApiProvider = Provider<ClubsApi>((ref) => ClubsApi(ref.watch(coreDioProvider)));

class ReservationsApi {
  ReservationsApi(this._dio);

  final Dio _dio;

  Future<List<Reservation>> list({required String userId, bool onlyIsActive = false}) => apiCall(
        () => _dio.get('/reservations', queryParameters: {'only_is_active': onlyIsActive, 'user_id': userId}),
        (d) => unwrapList(d, Reservation.fromJson),
      );

  Future<Reservation> get(String id) =>
      apiCall(() => _dio.get('/reservations/$id'), (d) => Reservation.fromJson(Map<String, dynamic>.from(d as Map)));

  Future<void> deactivate(String id) => apiCall<void>(() => _dio.get('/reservations/deactivate/$id'));

  Future<Reservation> create({required String dateTime, required String computerId, required String userTariffId}) => apiCall(
        () => _dio.post('/reservations', data: {'date_time': dateTime, 'computer_id': computerId, 'user_tariff_id': userTariffId}),
        (d) => Reservation.fromJson(Map<String, dynamic>.from(d as Map)),
      );
}

final reservationsApiProvider = Provider<ReservationsApi>((ref) => ReservationsApi(ref.watch(coreDioProvider)));
