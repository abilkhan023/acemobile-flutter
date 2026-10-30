import 'package:ace_mobile/features/balance/providers/balance_providers.dart';
import 'package:ace_mobile/features/clubs/data/booking_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no hold: spendable is balance', () {
    final w = Wallet.fromJson({'balance': '1000.00', 'bonuses': '0.00', 'held': null, 'available': null});
    expect(w.hasHold, false);
    expect(w.spendable, '1000.00');
  });

  test('hold: spendable is available', () {
    final w = Wallet.fromJson({'balance': '1000.00', 'bonuses': '200.00', 'held': '300.00', 'available': '900.00'});
    expect(w.hasHold, true);
    expect(w.spendable, '900.00');
  });

  test('zero hold is ignored', () {
    final w = Wallet.fromJson({'balance': '1000.00', 'held': '0.00', 'available': '1000.00'});
    expect(w.hasHold, false);
  });
}
