import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  State<EnterCodeScreen> createState() => _EnterCodeScreenState();
}

class _EnterCodeScreenState extends State<EnterCodeScreen> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AcePage(
      gap: 24,
      children: [
        Text(l.codeFromTheLetter, style: AceText.style(size: 24, weight: FontWeight.w600)),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _code, label: l.codeFromTheLetter, placeholder: l.enterCode, rules: const ['required', 'number', 'min-5']),
              AceButton(
                style: AceButtonStyle.red,
                label: l.continueAction,
                onPressed: () {
                  if (_form.currentState!.validate()) context.push('/login/recover-password/new-password');
                },
              ),
            ],
          ),
        ),
        Text('00:00', textAlign: TextAlign.center, style: AceText.style(size: 15, weight: FontWeight.w500, color: AceColors.muted)),
      ],
    );
  }
}
