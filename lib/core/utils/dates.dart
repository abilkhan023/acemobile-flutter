DateTime? parseUtc(Object? raw) {
  final s = raw?.toString();
  if (s == null || s.isEmpty) return null;
  final p = DateTime.tryParse(s);
  if (p == null) return null;
  if (s.endsWith('Z') || RegExp(r'[+-]\d\d:?\d\d$').hasMatch(s)) return p.toUtc();
  return DateTime.utc(p.year, p.month, p.day, p.hour, p.minute, p.second);
}
