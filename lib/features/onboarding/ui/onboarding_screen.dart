import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _name = TextEditingController();
  File? _avatar;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _avatar = File(file.path));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AcePage(
      fillHeight: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 32,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pick,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _avatar != null
                      ? Image.file(_avatar!, width: 160, height: 160, fit: BoxFit.cover)
                      : Image.asset('assets/images/placeholder-ava.png', width: 160, height: 160, fit: BoxFit.cover),
                ),
              ),
            ),
            AceInput(controller: _name, label: l.whatIsYourName, placeholder: l.enterYourName),
          ],
        ),
        const Spacer(),
        AceButton(label: l.next, style: AceButtonStyle.white, onPressed: () => context.go('/')),
      ],
    );
  }
}
