class ApiException implements Exception {
  ApiException({this.status, this.body, this.cause});

  final int? status;
  final dynamic body;
  final Object? cause;

  String get message {
    final b = body;
    if (b is Map) {
      final detail = b['detail'] ?? b['message'] ?? b['error'];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first['msg'] is String) return first['msg'] as String;
        return detail.join(', ');
      }
    }
    if (b is String && b.isNotEmpty) return b;
    return cause?.toString() ?? 'HTTP $status';
  }

  @override
  String toString() => 'ApiException($status): $message';
}
