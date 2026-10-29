import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../../clubs/data/clubs_api.dart';
import '../../clubs/data/models.dart';

class BranchCard {
  const BranchCard(this.branch, this.center);

  final Branch branch;
  final GameCenter? center;

  String get title => center?.name ?? branch.name ?? '';
  String get text => branch.address ?? '';
  String? get img => center?.logo;
}

List<BranchCard> branchCardsOf(AsyncValue<List<BranchCard>> value) => value.maybeWhen(
      data: (c) => c,
      error: (e, _) => e is BranchesLoadException ? e.cards : const <BranchCard>[],
      orElse: () => const <BranchCard>[],
    );

class BranchesLoadException implements Exception {
  const BranchesLoadException(this.cards);

  final List<BranchCard> cards;
}

final homeBranchesProvider = FutureProvider<List<BranchCard>>((ref) async {
  final api = ref.watch(clubsApiProvider);
  final branches = await api.branches(isAvailable: true);
  var failed = false;
  final cards = await Future.wait(branches.map((b) async {
    GameCenter? center;
    final id = b.gameCenterId;
    if (id != null && id.isNotEmpty) {
      try {
        center = await api.gameCenter(id);
      } catch (_) {
        failed = true;
      }
    }
    return BranchCard(b, center);
  }));
  if (failed) throw BranchesLoadException(cards);
  return cards;
});

class ActivityNotifier extends AsyncNotifier<List<Reservation>> {
  @override
  Future<List<Reservation>> build() async {
    final userId = ref.watch(authProvider.select((s) => s.isAuth ? s.user?.id : null));
    if (userId == null) return const [];
    final list = await ref.read(reservationsApiProvider).list(userId: userId, onlyIsActive: false);
    final old = DateTime(1970);
    return [...list]..sort((a, b) {
        final byActive = (b.isActive == true ? 1 : 0) - (a.isActive == true ? 1 : 0);
        return byActive != 0 ? byActive : (b.dateTimeParsed ?? old).compareTo(a.dateTimeParsed ?? old);
      });
  }

  Future<void> cancel(String id) async {
    await ref.read(reservationsApiProvider).deactivate(id);
    ref.invalidateSelf();
    await future;
  }
}

final activityProvider = AsyncNotifierProvider<ActivityNotifier, List<Reservation>>(ActivityNotifier.new);
