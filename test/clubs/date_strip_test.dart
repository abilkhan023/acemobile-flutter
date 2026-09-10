import 'package:ace_mobile/features/clubs/widgets/date_strip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('date key round trip', () {
    final d = DateTime(2026, 1, 5);
    expect(dateKey(d), '2026-01-05');
    expect(parseDateKey('2026-01-05'), d);
  });
}
