import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_checkbox.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../home/providers/home_providers.dart';
import '../widgets/club_card.dart';

Widget clubsHeaderActions(BuildContext context) => const _ClubsActions();

class _ClubsActions extends StatefulWidget {
  const _ClubsActions();

  @override
  State<_ClubsActions> createState() => _ClubsActionsState();
}

class _ClubsActionsState extends State<_ClubsActions> {
  final _search = TextEditingController();
  final Set<String> _filter = {};
  String? _sort;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openSearch() {
    final l = context.l10n;
    showAceSheet(
      context,
      title: l.search,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          AceInput(controller: _search, placeholder: l.enterTheClubName),
          AceButton(label: l.apply, style: AceButtonStyle.white, onPressed: () => Navigator.of(ctx).pop()),
          AceButton(label: l.reset, onPressed: () => _search.clear()),
        ],
      ),
    );
  }

  void _openFilter() {
    final l = context.l10n;
    final filters = {'kitchen': l.kitchen, 'open': l.open, 'seats_available': l.seatsAvailable};
    final sorts = {'recommended': l.recommended, 'rating': l.rating, 'distance': l.distance, 'cost': l.cost};
    showAceSheet(
      context,
      title: l.filter,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final e in filters.entries)
                  AceChip(
                    label: e.value,
                    active: _filter.contains(e.key),
                    onTap: () => setSheet(() => _filter.contains(e.key) ? _filter.remove(e.key) : _filter.add(e.key)),
                  ),
              ],
            ),
            Text(l.sorting, style: AceText.style(size: 14)),
            AceRadioChips(
              options: sorts.keys.toList(),
              labelOf: (k) => sorts[k]!,
              value: _sort,
              onChanged: (v) => setSheet(() => _sort = v),
            ),
            AceButton(label: l.apply, style: AceButtonStyle.white, onPressed: () => Navigator.of(ctx).pop()),
            AceButton(
              label: l.reset,
              onPressed: () => setSheet(() {
                _filter.clear();
                _sort = null;
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 30,
      children: [
        GestureDetector(behavior: HitTestBehavior.opaque, onTap: _openSearch, child: const AceIcon('search')),
        GestureDetector(behavior: HitTestBehavior.opaque, onTap: _openFilter, child: const AceIcon('sliders-simple')),
      ],
    );
  }
}

class ClubsScreen extends ConsumerWidget {
  const ClubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branches = ref.watch(homeBranchesProvider);
    final cards = branches.maybeWhen(
      data: (c) => c,
      error: (e, _) => e is BranchesLoadException ? e.cards : const <BranchCard>[],
      orElse: () => const <BranchCard>[],
    );
    if (branches.isLoading) {
      return const Center(child: AceSpinner(color: AceColors.accent));
    }
    return AcePage(
      gap: 16,
      children: [
        for (final c in cards)
          ClubCard(
            title: c.center?.name ?? c.branch.name ?? '',
            subtitle: c.branch.address ?? '',
            logo: null,
            onTap: () => context.push('/clubs/${c.branch.id}'),
          ),
      ],
    );
  }
}
