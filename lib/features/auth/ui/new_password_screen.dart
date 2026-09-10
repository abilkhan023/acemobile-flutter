import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import 'auth_header.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _repeat = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _repeat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AcePage(
      gap: 24,
      children: [
        AuthHeader(title: l.createANewPassword, subtitle: l.createANewPasswordForYourAccount),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _password, label: l.newPassword, placeholder: l.createAPassword, type: 'password', rules: const ['required', 'min-3']),
              AceInput(controller: _repeat, label: l.repeatPassword, placeholder: l.repeatPassword, type: 'password', rules: const ['required', 'min-3']),
              AceButton(
                style: AceButtonStyle.white,
                label: l.continueAction,
                onPressed: () {
                  if (_form.currentState!.validate()) context.go('/');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
