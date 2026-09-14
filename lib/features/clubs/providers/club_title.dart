import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/providers/home_providers.dart';

class ClubTitleNotifier extends Notifier<String> {
  ClubTitleNotifier(this.branchId);

  final String branchId;

  @override
  String build() {
    final cards = branchCardsOf(ref.watch(homeBranchesProvider));
    return cards.where((c) => c.branch.id == branchId).firstOrNull?.title ?? '';
  }

  void set(String value) => state = value;
}

final clubTitleProvider = NotifierProvider.family<ClubTitleNotifier, String, String>(ClubTitleNotifier.new);
