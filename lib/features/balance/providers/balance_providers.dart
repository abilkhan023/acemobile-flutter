import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth_provider.dart';
import '../../clubs/data/booking_api.dart';
import '../../clubs/data/booking_models.dart';
import '../../clubs/data/clubs_api.dart';
import '../../clubs/data/models.dart';
import '../../session/mobile_socket.dart';

final gameCentersProvider = FutureProvider<List<GameCenter>>((ref) => ref.watch(clubsApiProvider).gameCenters());

final walletsProvider = FutureProvider<List<Wallet>>((ref) async {
  ref.watch(walletsVersionProvider);
  final userId = ref.watch(authProvider.select((s) => s.isAuth ? s.user?.id : null));
  if (userId == null) return const [];
  return ref.watch(bookingApiProvider).wallets(userId: userId);
});

class WalletClub {
  const WalletClub({required this.wallet, this.club});

  final Wallet wallet;
  final GameCenter? club;

  String get name => club?.name ?? '';
  String get displayName => club?.name ?? (wallet.gameCenter is String ? wallet.gameCenter! as String : '');
  Object get ownBalance => wallet.balance ?? 0;
  String get key => wallet.gameCenterId ?? wallet.id ?? '';
  Object get balance => club == null ? 0 : (wallet.balance ?? 0);
}

class ClubWallet {
  const ClubWallet({required this.club, this.wallet});

  final GameCenter club;
  final Wallet? wallet;

  Object get balance => wallet?.balance ?? 0;
}

final walletClubsProvider = FutureProvider<List<WalletClub>>((ref) async {
  final wallets = await ref.watch(walletsProvider.future);
  final clubs = await ref.watch(gameCentersProvider.future).catchError((_) => const <GameCenter>[]);
  return [
    for (final w in wallets)
      WalletClub(wallet: w, club: clubs.where((c) => c.id == w.gameCenterId).firstOrNull),
  ];
});

final clubWalletsProvider = FutureProvider<List<ClubWallet>>((ref) async {
  final clubs = await ref.watch(gameCentersProvider.future);
  final wallets = await ref.watch(walletsProvider.future).catchError((_) => const <Wallet>[]);
  return [
    for (final c in clubs) ClubWallet(club: c, wallet: wallets.where((w) => w.gameCenterId == c.id).firstOrNull),
  ];
});

class BalanceSelection extends Notifier<ClubWallet?> {
  @override
  ClubWallet? build() => null;

  void toggle(ClubWallet club) => state = state?.club.id == club.club.id ? null : club;

  void clear() => state = null;

  void select(ClubWallet club) => state = club;
}

void openTopUp(WidgetRef ref, BuildContext context, WalletClub w) {
  final club = w.club;
  if (club == null) return;
  ref.read(balanceSelectionProvider.notifier).select(ClubWallet(club: club, wallet: w.wallet));
  context.push('/balance/form');
}

final balanceSelectionProvider = NotifierProvider<BalanceSelection, ClubWallet?>(BalanceSelection.new);

class PaymentMethod {
  const PaymentMethod({required this.id, required this.name, required this.img});

  final String id;
  final String name;
  final String img;
}

const kaspiMethod = PaymentMethod(id: '1', name: 'Kaspi.kz', img: 'assets/images/kaspi.png');
