import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../auth/providers/auth_controller.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _repeat = TextEditingController();
  String? _repeatError;
  bool _loading = false;

  @override
  void dispose() {
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  void _checkRepeat() {
    setState(() => _repeatError = _repeat.text.isEmpty || _password.text == _repeat.text ? null : context.l10n.differentPasswords);
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate() || _repeatError != null) return;
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    setState(() => _loading = true);
    try {
      await ref.read(authControllerProvider).changePassword(_password.text);
      _password.clear();
      _repeat.clear();
      toast.success(l.passwordChanged);
    } catch (_) {
      toast.danger(l.passwordChangeFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Form(
      key: _form,
      child: AcePage(
        fillHeight: true,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _password, label: l.password, placeholder: l.enterPassword, type: 'password', rules: const ['required', 'min-8'], onChanged: (_) => _checkRepeat()),
              AceInput(controller: _repeat, label: l.repeatPassword, placeholder: l.enterPassword, type: 'password', rules: const ['required', 'min-8'], errorText: _repeatError, onChanged: (_) => _checkRepeat()),
            ],
          ),
          const Spacer(),
          AceButton(style: AceButtonStyle.red, label: l.save, loading: _loading, onPressed: _submit),
        ],
      ),
    );
  }
}
