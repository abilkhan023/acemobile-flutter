import 'package:flutter/widgets.dart';

import 'l10n.dart';

String _find(String prefix, List<String> rules) {
  final item = rules.firstWhere((r) => r.startsWith(prefix), orElse: () => '');
  if (item.isEmpty) return '';
  final parts = item.split('-');
  return parts.length > 1 ? parts[1] : item;
}

bool rulesHaveNumber(List<String> rules) => _find('number', rules).isNotEmpty;

FormFieldValidator<String> aceValidator(BuildContext context, List<String> rules, {bool isNumber = false}) {
  return (value) {
    final l = context.l10n;
    final v = value ?? '';
    final required = _find('required', rules);
    final max = _find('max', rules);
    final min = _find('min', rules);
    final email = _find('email', rules);

    if (v.isEmpty && required.isNotEmpty) return l.requiredField;
    if (v.isEmpty) return null;

    if (!isNumber) {
      if (max.isNotEmpty && v.length > int.parse(max)) return '${l.maxLength} $max ${l.symbols}';
      if (min.isNotEmpty && v.length < int.parse(min)) return '${l.minLength} $min ${l.symbols}';
      if (email.isNotEmpty) {
        final split = v.split('@');
        if (!v.contains('@') || split.length < 2 || split[1].isEmpty) return l.thisIsEmail;
      }
    } else {
      final n = num.tryParse(v.replaceAll(' ', ''));
      if (n != null) {
        if (max.isNotEmpty && n > num.parse(max)) return '${l.maximum} $max ₸';
        if (min.isNotEmpty && n < num.parse(min)) return '${l.minimum} $min ₸';
      }
    }
    return null;
  };
}
