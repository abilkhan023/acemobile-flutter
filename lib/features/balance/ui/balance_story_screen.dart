import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';

class BalanceStoryScreen extends StatefulWidget {
  const BalanceStoryScreen({super.key});

  @override
  State<BalanceStoryScreen> createState() => _BalanceStoryScreenState();
}

class _BalanceStoryScreenState extends State<BalanceStoryScreen> {
  final _before = TextEditingController();
  final _after = TextEditingController();

  @override
  void dispose() {
    _before.dispose();
    _after.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = {if (_before.text.isNotEmpty) 'before': _before.text, if (_after.text.isNotEmpty) 'after': _after.text};
    return AcePage(
      gap: 12,
      children: [
        Text(context.l10n.selectPeriod, style: AceText.style(size: 18)),
        AceInput(controller: _before, placeholder: 'wdawd', onChanged: (_) => setState(() {})),
        AceInput(controller: _after, placeholder: 'wdawd', onChanged: (_) => setState(() {})),
        Text(const JsonEncoder.withIndent('  ').convert(filter), style: AceText.style(size: 14).copyWith(fontFamily: 'monospace')),
      ],
    );
  }
}
