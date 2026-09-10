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
    final sorted = [...list]..sort((a, b) => (b.isActive == true ? 1 : 0) - (a.isActive == true ? 1 : 0));
    return sorted;
  }

  Future<void> cancel(String id) async {
    await ref.read(reservationsApiProvider).deactivate(id);
    ref.invalidateSelf();
    await future;
  }
}

final activityProvider = AsyncNotifierProvider<ActivityNotifier, List<Reservation>>(ActivityNotifier.new);
