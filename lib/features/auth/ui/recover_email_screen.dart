import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../data/auth_api.dart';
import 'auth_header.dart';

class RecoverEmailScreen extends ConsumerStatefulWidget {
  const RecoverEmailScreen({super.key});

  @override
  ConsumerState<RecoverEmailScreen> createState() => _RecoverEmailScreenState();
}

class _RecoverEmailScreenState extends ConsumerState<RecoverEmailScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    final toast = ref.read(toastProvider.notifier);
    final l = context.l10n;
    try {
      await ref.read(authApiProvider).resetPassword(_email.text);
      _email.clear();
      if (mounted) context.go('/login');
      toast.success(l.newPasswordSent);
    } catch (_) {
      toast.warning(l.resetPasswordFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AcePage(
      gap: 24,
      children: [
        AuthHeader(title: l.enterYourEmail, subtitle: l.weWillSendYouANewPasswordToYourRegisteredEmail),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _email, label: 'Email', placeholder: l.enterEmail, rules: const ['required', 'email', 'min-5'], onSubmitted: (_) => _submit()),
              AceButton(style: AceButtonStyle.white, label: l.continueAction, loading: _loading, onPressed: _submit),
            ],
          ),
        ),
      ],
    );
  }
}
