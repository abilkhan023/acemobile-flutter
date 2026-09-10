import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/env.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final height = MediaQuery.sizeOf(context).height;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset('assets/images/gaming.png', height: 248, fit: BoxFit.contain),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -16,
          child: Container(
            constraints: BoxConstraints(minHeight: height * 0.5),
            padding: EdgeInsets.fromLTRB(16, 36, 16, 45 + bottom),
            decoration: const BoxDecoration(
              color: AceColors.card,
              borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              boxShadow: [BoxShadow(color: Color(0x14FFFFFF), offset: Offset(0, -12), blurRadius: 24)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 24,
              children: [
                Column(
                  spacing: 12,
                  children: [
                    Text(l.loginToAceGaming, textAlign: TextAlign.center, style: AceText.style(size: 24, weight: FontWeight.w600)),
                    Text(l.toLogIntoTheApplicationChooseAMethodConvenientForYou, textAlign: TextAlign.center, style: AceText.style(size: 15, weight: FontWeight.w500, color: AceColors.muted)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    spacing: 16,
                    children: [
                      AceButton(
                        style: AceButtonStyle.white,
                        label: l.loginViaEmail,
                        icon: 'email-icon',
                        gap: 12,
                        padding: const EdgeInsets.symmetric(vertical: 14.5, horizontal: 16),
                        onPressed: () => context.push('/login/email'),
                      ),
                      AceButton(
                        style: AceButtonStyle.lightBlue,
                        label: l.loginViaTelegram,
                        leading: Image.asset('assets/images/telegram-icon.png', width: 20, height: 20),
                        gap: 12,
                        padding: const EdgeInsets.symmetric(vertical: 14.5, horizontal: 16),
                        onPressed: () => launchUrl(Uri.parse(Env.telegramBotUrl), mode: LaunchMode.inAppBrowserView),
                      ),
                    ],
                  ),
                ),
                Text(l.byLoggingInYouAgreeToThePrivacyPolicy, textAlign: TextAlign.center, style: AceText.style(size: 13, weight: FontWeight.w500, color: AceColors.muted)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
