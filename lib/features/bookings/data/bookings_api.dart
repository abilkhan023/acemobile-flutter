import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/env.dart';
import '../../auth/providers/auth_provider.dart';

DateTime? parseUtc(Object? raw) {
  final s = raw?.toString();
  if (s == null || s.isEmpty) return null;
  final p = DateTime.tryParse(s);
  if (p == null) return null;
  if (s.endsWith('Z') || RegExp(r'[+-]\d\d:?\d\d$').hasMatch(s)) return p.toUtc();
  return DateTime.utc(p.year, p.month, p.day, p.hour, p.minute, p.second);
}

class UserRef {
  const UserRef({required this.id, required this.username});

  final String id;
  final String username;

  static UserRef? fromJson(Object? j) {
    if (j is! Map) return null;
    final id = j['id']?.toString();
    if (id == null || id.isEmpty) return null;
    return UserRef(id: id, username: (j['username'] ?? j['name'] ?? '').toString());
  }
}

class BookingPlace {
  const BookingPlace({required this.id, this.computerId, this.computer, this.status, this.assigned, this.assignedToId, this.claimedBy, this.mine = false});

  final String? assignedToId;

  final String id;
  final String? computerId;
  final String? computer;
  final String? status;
  final UserRef? assigned;
  final UserRef? claimedBy;
  final bool mine;

  bool get waiting => status == null || status == 'waiting';

  factory BookingPlace.fromJson(Map<String, dynamic> j) => BookingPlace(
        id: j['id'].toString(),
        computerId: j['computer_id']?.toString(),
        computer: (j['computer'] is Map ? (j['computer'] as Map)['name'] : j['computer'])?.toString(),
        status: j['status']?.toString(),
        assigned: UserRef.fromJson(j['assigned']),
        assignedToId: (j['assigned'] is Map ? (j['assigned'] as Map)['id'] : j['assigned_to'])?.toString(),
        claimedBy: UserRef.fromJson(j['claimed_by']),
        mine: j['mine'] == true,
      );
}

class Booking {
  const Booking({
    required this.id,
    required this.kind,
    this.status,
    this.startsAt,
    this.endsAt,
    this.role = 'owner',
    this.owner,
    this.accessCode,
    this.tariffName,
    this.tariffDuration,
    this.zoneId,
    this.zoneName,
    this.hasDoor = false,
    this.branchId,
    this.branchAddress,
    this.gameCenterName,
    this.members = const [],
    this.places = const [],
  });

  final String id;
  final String kind;
  final String? status;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String role;
  final UserRef? owner;
  final String? accessCode;
  final String? tariffName;
  final num? tariffDuration;
  final String? zoneId;
  final String? zoneName;
  final bool hasDoor;
  final String? branchId;
  final String? branchAddress;
  final String? gameCenterName;
  final List<UserRef> members;
  final List<BookingPlace> places;

  bool get isRoom => kind == 'room';
  bool get isOwner => role == 'owner';

  bool doorAvailable(DateTime nowUtc) {
    final s = startsAt;
    final e = endsAt;
    if (!hasDoor || s == null || e == null) return false;
    return !nowUtc.isBefore(s.subtract(const Duration(hours: 1))) && nowUtc.isBefore(e);
  }

  bool canCancel(DateTime nowUtc) => isOwner && startsAt != null && nowUtc.isBefore(startsAt!);

  factory Booking.fromJson(Map<String, dynamic> j) {
    Map? m(String k) => j[k] is Map ? j[k] as Map : null;
    final tariff = m('tariff');
    final zone = m('zone');
    final branch = m('branch');
    final center = m('game_center');
    return Booking(
      id: j['id'].toString(),
      kind: (j['kind'] ?? 'computers').toString(),
      status: j['status']?.toString(),
      startsAt: parseUtc(j['starts_at']),
      endsAt: parseUtc(j['ends_at']),
      role: (j['role'] ?? 'owner').toString(),
      owner: UserRef.fromJson(j['owner']),
      accessCode: j['access_code']?.toString(),
      tariffName: tariff?['name']?.toString(),
      tariffDuration: tariff?['duration'] is num ? tariff!['duration'] as num : num.tryParse('${tariff?['duration']}'),
      zoneId: (zone?['id'] ?? j['zone_id'])?.toString(),
      zoneName: zone?['name']?.toString(),
      hasDoor: zone?['has_door'] == true,
      branchId: branch?['id']?.toString(),
      branchAddress: branch?['address']?.toString(),
      gameCenterName: center?['name']?.toString(),
      members: [for (final x in (j['members'] as List? ?? const [])) ?UserRef.fromJson(x)],
      places: [for (final x in (j['places'] as List? ?? const [])) if (x is Map) BookingPlace.fromJson(Map<String, dynamic>.from(x))],
    );
  }
}

List<UserRef> parseFriends(Object? data, String? meId) {
  final list = data is Map ? (data['data'] ?? data['items'] ?? const []) : data;
  if (list is! List) return const [];
  final out = <String, UserRef>{};
  for (final item in list) {
    if (item is! Map) continue;
    final status = item['status']?.toString();
    if (status != null && status != 'accepted' && status != 'active') continue;
    if (item['is_active'] == false || item['is_deleted'] == true || item['accepted'] == false) continue;
    UserRef? ref;
    for (final k in ['friend', 'user', 'profile']) {
      ref ??= UserRef.fromJson(item[k]);
    }
    if (ref == null) {
      for (final k in ['user_a', 'user_b', 'requester', 'addressee']) {
        final r = UserRef.fromJson(item[k]);
        if (r != null && r.id != meId) ref ??= r;
      }
    }
    if (ref == null && item['username'] != null) {
      final id = (item['friend_id'] ?? item['user_id'] ?? item['id'])?.toString();
      if (id != null) ref = UserRef(id: id, username: item['username'].toString());
    }
    if (ref != null && ref.id != meId) out[ref.id] = ref;
  }
  return out.values.toList();
}

class BookingsApi {
  BookingsApi(this._dio);

  final Dio _dio;

  Future<Booking> create({
    required String dateTime,
    required List<String> computerIds,
    required String tariffId,
    List<String> friendIds = const [],
  }) =>
      apiCall(
        () => _dio.post('/reservations', data: {
          'date_time': dateTime,
          'timezone': Env.timezone,
          'computer_ids': computerIds,
          'tariff_id': tariffId,
          if (friendIds.isNotEmpty) 'friend_ids': friendIds,
        }),
        (d) => Booking.fromJson(Map<String, dynamic>.from(d as Map)),
      );

  Future<List<Booking>> bookings() => apiCall(() => _dio.get('/reservations/bookings'), (d) {
        final list = d is Map ? (d['data'] ?? const []) : d;
        return [for (final x in (list as List)) if (x is Map) Booking.fromJson(Map<String, dynamic>.from(x))];
      });

  Future<List<UserRef>> friends(String? meId) => apiCall(() => _dio.get('/friends'), (d) => parseFriends(d, meId));

  Future<void> assignFriend(String placeId, String? userId) =>
      apiCall<void>(() => _dio.put('/reservations/$placeId/friend', data: {'user_id': userId}));

  Future<void> setMembers(String bookingId, List<String> userIds) =>
      apiCall<void>(() => _dio.put('/reservations/bookings/$bookingId/members', data: {'user_ids': userIds}));

  Future<void> cancel(String placeId) => apiCall<void>(() => _dio.get('/reservations/deactivate/$placeId'));

  Future<String> startOnFriendPc(String placeId) =>
      apiCall(() => _dio.post('/reservations/$placeId/start'), (d) => (d is Map ? d['username'] : null)?.toString() ?? '');
}

final bookingsApiProvider = Provider<BookingsApi>((ref) => BookingsApi(ref.watch(coreDioProvider)));

final myBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final userId = ref.watch(authProvider.select((s) => s.isAuth ? s.user?.id : null));
  if (userId == null) return const [];
  final list = await ref.watch(bookingsApiProvider).bookings();
  return [...list]..sort((a, b) => (a.startsAt ?? DateTime(2100)).compareTo(b.startsAt ?? DateTime(2100)));
});

final friendsProvider = FutureProvider<List<UserRef>>((ref) async {
  final userId = ref.watch(authProvider.select((s) => s.isAuth ? s.user?.id : null));
  if (userId == null) return const [];
  return ref.watch(bookingsApiProvider).friends(userId);
});
