import '../../l10n/generated/app_localizations.dart';
import 'mobile_socket.dart';

String socketErrorText(Object e, AppLocalizations l) {
  final kind = e is SocketRequestError ? e.kind : '';
  return switch (kind) {
    'door_cooldown' => l.doorCooldown,
    'unauthorized' => l.doorUnauthorized,
    'reservation_not_found' => l.anErrorOccurred,
    'room_not_renter' => l.roomNotRenter,
    'room_member_not_found' => l.roomMemberGone,
    'room_leave_not_allowed' => l.roomLeaveNotAllowed,
    'computer_not_free' => l.roomBookedByOthers,
    _ => l.tryAgainLater,
  };
}
