import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../settings/locale_provider.dart';

class SelectLanguage extends ConsumerStatefulWidget {
  const SelectLanguage({super.key});

  @override
  ConsumerState<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends ConsumerState<SelectLanguage> {
  Locale? _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(localeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final langs = [
      (locale: const Locale('ru'), name: l.langRussian, translate: 'Русский'),
      (locale: const Locale('en'), name: l.langEnglish, translate: 'English'),
      (locale: const Locale('kk'), name: l.langKazakh, translate: 'Қазақша'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: AceColors.cardAlt), borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              for (final (i, item) in langs.indexed)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _selected = _selected == item.locale ? null : item.locale),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      border: i == langs.length - 1 ? null : const Border(bottom: BorderSide(color: AceColors.cardAlt)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            Text(item.name, style: AceText.style(size: 16, weight: FontWeight.w600)),
                            Text(item.translate, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
                          ],
                        ),
                        AceIcon(_selected == item.locale ? 'circle-check' : 'circle'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        AceButton(
          style: AceButtonStyle.white,
          label: l.selectLanguage,
          onPressed: () async {
            final locale = _selected;
            if (locale != null) await ref.read(localeProvider.notifier).set(locale);
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
