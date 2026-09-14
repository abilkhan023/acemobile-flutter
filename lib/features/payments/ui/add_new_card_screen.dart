import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _form = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _date = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    _number.dispose();
    _date.dispose();
    _cvv.dispose();
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _number, label: l.cardNumber, placeholder: '0000 0000 0000 0000', rules: const ['required', 'number', 'min-16', 'max-16']),
              Row(
                spacing: 8,
                children: [
                  Expanded(child: AceInput(controller: _date, label: l.validityPeriod, placeholder: '00/00', rules: const ['required'])),
                  Expanded(child: AceInput(controller: _cvv, label: 'CVV', placeholder: '***', rules: const ['required', 'number', 'min-5', 'max-5'])),
                ],
              ),
            ],
          ),
          const Spacer(),
          AceButton(label: l.addACard, style: AceButtonStyle.red, onPressed: () => _form.currentState!.validate()),
        ],
      ),
    );
  }
}
