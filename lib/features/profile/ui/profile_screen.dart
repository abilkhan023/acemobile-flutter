import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_modal.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/link_menu.dart';
import '../../auth/providers/auth_controller.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/select_language.dart';

Widget profileHeaderActions(BuildContext context) => const _LogoutAction();

class _LogoutAction extends ConsumerWidget {
  const _LogoutAction();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => confirmLogout(context, ref),
      child: const AceIcon('logout', size: 24, color: AceColors.muted),
    );
  }
}

Future<void> confirmLogout(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final ok = await showAceModal(
    context,
    title: l.attention,
    body: Text(l.areYouSureYouWantToExit, style: AceText.style(size: 16, weight: FontWeight.w500, color: AceColors.muted)),
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
      body: Text(l.deleteAccountWarning, style: AceText.style(size: 16, weight: FontWeight.w500, color: AceColors.muted)),
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

  void _openBalance() {
    final l = context.l10n;
    showAceSheet(
      context,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          Text(l.balance, style: AceText.titleBig),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              LinkMenu(title: l.currentBalance, onTap: () { Navigator.of(ctx).pop(); context.push('/current_balance'); }),
              LinkMenu(title: l.balanceReplenishment, onTap: () { Navigator.of(ctx).pop(); context.push('/balance_replenishment'); }),
            ],
          ),
        ],
      ),
    );
  }

  void _openLanguage() {
    showAceSheet(context, title: context.l10n.selectLanguage, builder: (ctx) => const SelectLanguage());
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = ref.watch(authProvider);
    final user = auth.user;
    final name = auth.isAuth ? '${l.hi}, ${user?.username?.isNotEmpty == true ? user!.username : 'User'}' : l.hi;
    return AcePage(
      gap: 32,
      children: [
        Column(
          spacing: 20,
          children: [
            SvgPicture.asset('assets/images/avatar-icon.svg', width: 100, height: 100),
            Column(
              spacing: 8,
              children: [
                Text('$name!', textAlign: TextAlign.center, style: AceText.style(size: 20, weight: FontWeight.w700)),
                Text(user?.email ?? '', textAlign: TextAlign.center, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            LinkMenu(title: l.balance, onTap: _openBalance),
            LinkMenu(title: l.selectLanguage, onTap: _openLanguage),
            LinkMenu(title: l.changePassword, onTap: () => context.push('/change_password')),
            LinkMenu(title: l.deleteAccount, danger: true, onTap: _deleteAccount),
          ],
        ),
      ],
    );
  }
}
