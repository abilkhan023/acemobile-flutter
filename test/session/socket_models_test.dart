import 'package:ace_mobile/features/session/mobile_socket.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('session ends_at without zone is treated as UTC', () {
    const s = SessionInfo(sessionId: '1', tariffType: 'tariff', endsAt: '2026-09-10T12:30:00');
    final end = s.endsAtUtc!;
    expect(end.isUtc, isTrue);
    expect(end.hour, 12);
    expect(end.minute, 30);
  });

  test('session ends_at with Z stays the same instant', () {
    const s = SessionInfo(sessionId: '1', tariffType: 'tariff', endsAt: '2026-09-10T12:30:00Z');
    expect(s.endsAtUtc, DateTime.utc(2026, 9, 10, 12, 30));
  });

  test('context and balance parse from json', () {
    final ctx = SessionContext.fromJson({'user_id': 'u', 'username': 'n', 'is_guest': false, 'active_session': true, 'computer_id': 'c', 'computer_name': '12'});
    expect(ctx.activeSession, isTrue);
    expect(ctx.computerName, '12');
    expect(ctx.cleared().activeSession, isFalse);
    expect(ctx.cleared().computerName, isNull);

    final b = WalletBalance.fromJson({'balance': '1500', 'bonuses': 20});
    expect(b.balance, '1500');
    expect(b.bonuses, '20');
  });

  test('state helpers', () {
    const empty = SocketState();
    expect(empty.hasActiveSession, isFalse);
    final s = empty.copyWith(
      context: const SessionContext(userId: 'u', activeSession: true),
      session: const SessionInfo(sessionId: 's', tariffType: 'free'),
    );
    expect(s.hasActiveSession, isTrue);
    expect(s.copyWith(clearSession: true).hasActiveSession, isFalse);
  });
}
