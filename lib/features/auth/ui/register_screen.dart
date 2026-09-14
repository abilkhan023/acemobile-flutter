import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../providers/auth_controller.dart';
import 'auth_header.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _repeat = TextEditingController();
  bool _loading = false;
  String? _repeatError;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  void _checkRepeat() {
    final l = context.l10n;
    setState(() {
      _repeatError = _repeat.text.isEmpty || _password.text == _repeat.text ? null : l.differentPasswords;
    });
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate() || _repeatError != null) return;
    final l = context.l10n;
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider).register(username: _username.text, email: _email.text, password: _password.text);
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
        AuthHeader(title: l.registration, subtitle: l.enterYourEmailAndCreateAPassword),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _username, label: l.login, placeholder: l.enterLogin, rules: const ['required'], textInputAction: TextInputAction.next),
              AceInput(controller: _email, label: 'Email', placeholder: l.enterEmail, rules: const ['required'], textInputAction: TextInputAction.next),
              AceInput(controller: _password, label: l.password, placeholder: l.createAPasswordRegist, type: 'password', rules: const ['required', 'min-8'], onChanged: (_) => _checkRepeat(), textInputAction: TextInputAction.next),
              AceInput(controller: _repeat, label: l.repeatPassword, placeholder: l.repeatPassword, type: 'password', rules: const ['required'], errorText: _repeatError, onChanged: (_) => _checkRepeat(), onSubmitted: (_) => _submit()),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: AceButton(style: AceButtonStyle.red, label: l.register, loading: _loading, onPressed: _submit),
              ),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.go('/login'),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text.rich(
              TextSpan(
                text: '${l.alreadyHaveAnAccount} ',
                style: AceText.style(size: 15, weight: FontWeight.w500, color: AceColors.muted),
                children: [TextSpan(text: l.enter, style: AceText.style(size: 15, weight: FontWeight.w600))],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Text(l.byLoggingInYouAgreeToThePrivacyPolicy, textAlign: TextAlign.center, style: AceText.caption),
      ],
    );
  }
}
