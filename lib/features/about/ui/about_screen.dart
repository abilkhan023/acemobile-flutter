import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_page.dart';

TextStyle get aboutText => AceText.style(size: 14, weight: FontWeight.w300, height: 24 / 14);

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AcePage(
      gap: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Ace Gaming', style: aboutText.copyWith(fontWeight: FontWeight.w700)),
              const TextSpan(text: ' - ваш лучший проводник в мир компьютерных игр, предоставляющий удобные условия для незабываемого времяпрепровождения.'),
            ],
          ),
          style: aboutText,
        ),
        Text('Основные особенности нашей платформы включают:', style: aboutText),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Просмотр доступных компьютеров с помощью смартфона и быстрое бронирование в несколько кликов.', style: aboutText),
            Text('2. Удобное пополнение баланса с использованием сервиса Kaspi или переводом между клиентами.', style: aboutText),
            Text('3. Начало игровой сессии без необходимости заполнять авторизационные данные благодаря сканированию QR-кода.', style: aboutText),
          ],
        ),
        Text('Наши партнеры предлагают эксклюзивные преимущества, такие как выгодные тарифы и индивидуальные скидки, делая ваш игровой опыт еще более приятным.', style: aboutText),
        Text('Добро пожаловать в Ace Gaming - погрузитесь в удивительный мир компьютерных игр вместе с нами!', style: aboutText),
        GestureDetector(
          onTap: () => context.push('/about/privacy-policy'),
          child: Text(context.l10n.privacyPolicyLink, style: AceText.style(size: 16, weight: FontWeight.w500, color: AceColors.link)),
        ),
      ],
    );
  }
}
