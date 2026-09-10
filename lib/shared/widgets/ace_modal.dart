import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_button.dart';
import 'ace_icon.dart';

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
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
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
      width: (width - 32).clamp(0, 400).toDouble(),
      decoration: BoxDecoration(
        color: AceColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14FFFFFF), offset: Offset(0, -12), blurRadius: 24)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!hideHead)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: AceText.style(size: 18, weight: FontWeight.w600))),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(false),
                    child: const AceIcon('xmark', color: AceColors.muted),
                  ),
                ],
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: body,
            ),
          ),
          if (!hideFooter)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                spacing: 16,
                children: [
                  for (final (i, action) in actions.indexed)
                    Expanded(
                      child: AceButton(
                        label: action,
                        style: action == submit ? AceButtonStyle.plain : AceButtonStyle.white,
                        textColor: i == 0 ? AceColors.muted : null,
                        onPressed: () => Navigator.of(context).pop(action == submit),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
