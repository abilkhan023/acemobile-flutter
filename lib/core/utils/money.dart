import 'package:intl/intl.dart';

final _ru = NumberFormat.decimalPattern('ru');

String formatMoney(Object? value) {
  final n = value is num ? value : num.tryParse(value?.toString() ?? '') ?? 0;
  return '${_ru.format(n)} ₸';
}
