import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/env.dart';
import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../providers/auth_controller.dart';
import 'auth_header.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final l = context.l10n;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider).login(username: _username.text, password: _password.text);
      if (mounted) context.go('/');
    } catch (_) {
      ref.read(toastProvider.notifier).danger(l.somethingWentWrong);
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
        AuthHeader(title: l.loginViaLogin, subtitle: l.enterYourLoginAndPassword),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _username, label: l.login, placeholder: l.enterLogin, rules: const ['required', 'min-3'], textInputAction: TextInputAction.next),
              AceInput(controller: _password, label: l.password, placeholder: l.enterPassword, type: 'password', rules: const ['required', 'min-3'], onSubmitted: (_) => _submit()),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push('/login/recover-password/input-email'),
                child: Text(l.forgotPassword, textAlign: TextAlign.right, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
              ),
              AceButton(style: AceButtonStyle.red, label: l.enter, loading: _loading, onPressed: _submit),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push('/register'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  child: Text(l.register, textAlign: TextAlign.center, style: AceText.style(size: 15, weight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => launchUrl(Uri.parse(Env.privacyPdfUrl), mode: LaunchMode.inAppBrowserView),
          child: Text(l.byLoggingInYouAgreeToThePrivacyPolicy, textAlign: TextAlign.center, style: AceText.caption),
        ),
      ],
    );
  }
}
