import 'package:ace_mobile/core/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async => initializeDateFormatting('ru'));

  test('formats with ru grouping and tenge sign', () {
    expect(formatMoney(12330), '12 330 ₸');
    expect(formatMoney('5000'), '5 000 ₸');
    expect(formatMoney(null), '0 ₸');
    expect(formatMoney(100), '100 ₸');
  });
}
