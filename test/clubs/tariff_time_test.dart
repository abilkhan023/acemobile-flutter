import 'package:ace_mobile/features/clubs/data/booking_models.dart';
import 'package:ace_mobile/features/clubs/widgets/tariffs_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tariff = Tariff(
    id: 't',
    name: 'Day',
    basePrice: 2000,
    duration: 120,
    property: TariffProperty(
      tariffId: 't',
      availabilities: TariffAvailabilities(toBuy: [
        TariffAvailability(weekdayFrom: 0, weekdayTo: 6, availableFrom: '08:00:00', availableTo: '12:00:00'),
        TariffAvailability(weekdayFrom: 0, weekdayTo: 6, availableFrom: '12:00:00', availableTo: '18:00:00'),
      ]),
    ),
  );

  test('returns matching window for server time', () {
    expect(tariffTimeToBuy(tariff, DateTime(2026, 9, 10, 9, 15)), '08:00 - 12:00');
    expect(tariffTimeToBuy(tariff, DateTime(2026, 9, 10, 12, 0)), '08:00 - 12:00');
    expect(tariffTimeToBuy(tariff, DateTime(2026, 9, 10, 15, 0)), '12:00 - 18:00');
  });

  test('returns dashes when outside windows or no time', () {
    expect(tariffTimeToBuy(tariff, DateTime(2026, 9, 10, 23, 0)), '---');
    expect(tariffTimeToBuy(tariff, null), '---');
  });
}
