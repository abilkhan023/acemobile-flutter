import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';

class PromocodeScreen extends StatefulWidget {
  const PromocodeScreen({super.key});

  @override
  State<PromocodeScreen> createState() => _PromocodeScreenState();
}

class _PromocodeScreenState extends State<PromocodeScreen> {
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
    return Form(
      key: _form,
      child: AcePage(
        fillHeight: true,
        children: [
          AceInput(controller: _code, label: l.promocode, placeholder: l.enterPromocode, icon: 'qr-code', rules: const ['required', 'min-3']),
          const Spacer(),
          AceButton(style: AceButtonStyle.red, label: l.activate, onPressed: () => _form.currentState!.validate()),
        ],
      ),
    );
  }
}
