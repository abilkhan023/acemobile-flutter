import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Александр');
  final _email = TextEditingController(text: 'root@ace.gg');
  File? _avatar;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _avatar = File(file.path));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Form(
      key: _form,
      child: AcePage(
        fillHeight: true,
        children: [
          GestureDetector(
            onTap: _pick,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _avatar != null
                  ? Image.file(_avatar!, width: 100, height: 100, fit: BoxFit.cover)
                  : Image.asset('assets/images/placeholder-ava.png', width: 100, height: 100, fit: BoxFit.cover),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _name, label: l.whatIsYourName, placeholder: l.enterName, rules: const ['required', 'min-1']),
              AceInput(controller: _email, label: l.login, placeholder: l.thisIsEmail, rules: const ['required', 'email', 'min-5']),
            ],
          ),
          const Spacer(),
          AceButton(style: AceButtonStyle.red, label: l.save, onPressed: () => _form.currentState!.validate()),
        ],
      ),
    );
  }
}
