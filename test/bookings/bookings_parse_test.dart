import 'package:ace_mobile/features/bookings/data/bookings_api.dart';
import 'package:ace_mobile/features/clubs/data/booking_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a v3 booking from the spec shape', () {
    final b = Booking.fromJson({
      'id': 'b1',
      'kind': 'computers',
      'status': 'active',
      'starts_at': '2026-10-05T13:00:00',
      'ends_at': '2026-10-05T16:00:00',
      'role': 'owner',
      'owner': {'id': 'u1', 'username': 'root'},
      'access_code': 'QF7K3M',
      'tariff': {'id': 't', 'name': '3 часа', 'duration': 10800},
      'zone': {'id': 'z', 'name': 'V1', 'has_door': true},
      'members': [],
      'places': [
        {'id': 'p1', 'computer_id': 'c1', 'computer': 'A1', 'status': 'waiting', 'assigned': {'id': 'f1', 'username': 'user2'}, 'claimed_by': null, 'mine': false},
        {'id': 'p2', 'computer_id': 'c2', 'computer': 'A2', 'status': 'waiting', 'assigned': null, 'claimed_by': null, 'mine': true},
      ],
    });
    expect(b.startsAt, DateTime.utc(2026, 10, 5, 13));
    expect(b.places.first.assignedToId, 'f1');
    expect(b.places.last.mine, isTrue);
    expect(b.doorAvailable(DateTime.utc(2026, 10, 5, 12, 30)), isTrue);
    expect(b.doorAvailable(DateTime.utc(2026, 10, 5, 11, 30)), isFalse);
    expect(b.canCancel(DateTime.utc(2026, 10, 5, 12)), isTrue);
    expect(b.canCancel(DateTime.utc(2026, 10, 5, 13, 1)), isFalse);
  });

  test('parses friends in several shapes and skips self and pending', () {
    final list = parseFriends({
      'data': [
        {'id': 'x', 'friend': {'id': 'f1', 'username': 'user2'}},
        {'user_a': {'id': 'me', 'username': 'root'}, 'user_b': {'id': 'f2', 'username': 'user3'}},
        {'id': 'f3', 'username': 'user4'},
        {'id': 'f4', 'username': 'pending', 'status': 'pending'},
      ],
    }, 'me');
    expect(list.map((f) => f.username), ['user2', 'user3', 'user4']);
  });

  test('uses dynamic price when present', () {
    const plain = Tariff(id: 'a', basePrice: '2500.00');
    final dyn = Tariff(id: 'b', basePrice: '2500.00', dynamicPrice: const {'price': '3100.00', 'estimate': true});
    expect(plain.priceNum, 2500);
    expect(dyn.isDynamic, isTrue);
    expect(dyn.priceNum, 3100);
  });
}
