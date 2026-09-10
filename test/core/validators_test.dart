import 'package:ace_mobile/core/utils/validators.dart';
import 'package:ace_mobile/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<FormFieldValidator<String> Function(List<String>, {bool isNumber})> pump(WidgetTester tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ru'),
      home: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }),
    ));
    return (rules, {isNumber = false}) => aceValidator(ctx, rules, isNumber: isNumber);
  }

  testWidgets('required, min, max, email rules', (tester) async {
    final v = await pump(tester);
    expect(v(['required'])(''), 'Обязательное поле');
    expect(v(['required'])('x'), isNull);
    expect(v(['min-3'])('ab'), 'Минимальная длина 3 символов');
    expect(v(['max-3'])('abcd'), 'Максимальная длина 3 символов');
    expect(v(['email'])('nope'), 'Введите почту');
    expect(v(['email'])('a@'), 'Введите почту');
    expect(v(['email'])('a@b.c'), isNull);
    expect(v(['min-3'])(''), isNull);
  });

  testWidgets('number rules compare numerically with tenge', (tester) async {
    final v = await pump(tester);
    expect(v(['required', 'number', 'min-100', 'max-50000'], isNumber: true)('50'), 'Минимально 100 ₸');
    expect(v(['required', 'number', 'min-100', 'max-50000'], isNumber: true)('60000'), 'Максимально 50000 ₸');
    expect(v(['required', 'number', 'min-100', 'max-50000'], isNumber: true)('500'), isNull);
    expect(rulesHaveNumber(['required', 'number']), isTrue);
    expect(rulesHaveNumber(['required']), isFalse);
  });
}
