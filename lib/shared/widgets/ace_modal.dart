import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_button.dart';

Future<bool> showAceModal(
  BuildContext context, {
  required String title,
  required Widget body,
  required List<String> actions,
  required String submit,
  bool hideHead = false,
  bool hideFooter = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: AceColors.overlay,
    builder: (ctx) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: AceModal(title: title, body: body, actions: actions, submit: submit, hideHead: hideHead, hideFooter: hideFooter),
      ),
    ),
  );
  return result ?? false;
}

class AceModal extends StatelessWidget {
  const AceModal({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
    required this.submit,
    this.hideHead = false,
    this.hideFooter = false,
  });

  final String title;
  final Widget body;
  final List<String> actions;
  final String submit;
  final bool hideHead;
  final bool hideFooter;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: (width - 40).clamp(0, 400).toDouble(),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AceColors.card,
        borderRadius: BorderRadius.circular(AceRadius.card),
        boxShadow: AceShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          if (!hideHead) Text(title, style: AceText.titleBig),
          Flexible(child: SingleChildScrollView(child: body)),
          if (!hideFooter)
            Row(
              spacing: 10,
              children: [
                for (final action in actions)
                  Expanded(
                    child: AceButton(
                      label: action,
                      style: action == submit ? AceButtonStyle.red : AceButtonStyle.gray,
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      onPressed: () => Navigator.of(context).pop(action == submit),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
