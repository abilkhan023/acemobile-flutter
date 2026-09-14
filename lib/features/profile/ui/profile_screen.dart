import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_modal.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/link_menu.dart';
import '../../auth/providers/auth_controller.dart';
import '../../auth/providers/auth_provider.dart';
import '../../balance/providers/balance_providers.dart';
import '../../clubs/widgets/club_card.dart';
import '../../settings/locale_provider.dart';
import '../widgets/select_language.dart';

Future<void> confirmLogout(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final ok = await showAceModal(
    context,
    title: l.attention,
    body: Text(l.areYouSureYouWantToExit, style: AceText.style(size: 15, color: AceColors.muted)),
    actions: [l.yesLogout, l.cancel],
    submit: l.yesLogout,
  );
  if (!ok) return;
  await ref.read(authControllerProvider).logout();
  if (context.mounted) context.go('/login');
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(authControllerProvider).refreshMe().catchError((_) {}));
  }

  Future<void> _deleteAccount() async {
    final l = context.l10n;
    final ok = await showAceModal(
      context,
      title: l.deleteAccount,
      body: Text(l.deleteAccountWarning, style: AceText.style(size: 15, color: AceColors.muted)),
      actions: [l.yesDelete, l.cancel],
      submit: l.yesDelete,
    );
    if (!ok) return;
    final toast = ref.read(toastProvider.notifier);
    try {
      await ref.read(authControllerProvider).deleteAccount();
      if (mounted) context.go('/login');
      toast.success(l.accountDeleted);
    } catch (_) {
      toast.danger(l.accountDeleteFailed);
    }
  }

  void _openLanguage() {
    showAceSheet(context, title: context.l10n.selectLanguage, builder: (ctx) => const SelectLanguage());
  }

  String _localeName(Locale locale, AppLocalizations l) => switch (locale.languageCode) {
        'en' => l.langEnglish,
        'kk' => l.langKazakh,
        _ => l.langRussian,
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final wallets = ref.watch(walletClubsProvider).value ?? const <WalletClub>[];
    final locale = ref.watch(localeProvider);
    final name = user?.username?.isNotEmpty == true ? user!.username! : 'User';
    return AcePage(
      gap: 20,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        Column(
          spacing: 12,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(color: AceColors.card, shape: BoxShape.circle, boxShadow: AceShadows.card),
              child: const Center(child: AceIcon('user', size: 42)),
            ),
            Column(
              spacing: 4,
              children: [
                Text(auth.isAuth ? name : l.hi, textAlign: TextAlign.center, style: AceText.titleBig),
                if (user?.email?.isNotEmpty == true) Text(user!.email!, textAlign: TextAlign.center, style: AceText.text),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 14,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.currentBalance, style: AceText.text),
                  AceButton(
                    label: l.topUpBalance,
                    style: AceButtonStyle.red,
                    expand: false,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    shadow: const [],
                    onPressed: () => context.push('/balance_replenishment'),
                  ),
                ],
              ),
              if (wallets.isEmpty)
                Text(l.noBalancesAvailable, style: AceText.text)
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    spacing: 10,
                    children: [
                      for (final w in wallets.where((w) => w.club != null))
                        AcePill(
                          height: 40,
                          padding: const EdgeInsets.fromLTRB(8, 0, 14, 0),
                          onTap: () => context.push('/current_balance'),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              ClubLogo(url: w.club?.logo, size: 24),
                              Text(formatMoney(w.balance), style: AceText.style(size: 14, weight: FontWeight.w600)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            LinkMenu(title: l.selectLanguage, icon: 'globe', trailing: _localeName(locale, l), onTap: _openLanguage),
            LinkMenu(title: l.changePassword, icon: 'lock', onTap: () => context.push('/change_password')),
            LinkMenu(title: l.logout, icon: 'logout', onTap: () => confirmLogout(context, ref)),
          ],
        ),
        LinkMenu(title: l.deleteAccount, danger: true, onTap: _deleteAccount),
      ],
    );
  }
}
