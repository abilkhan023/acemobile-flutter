import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/l10n.dart';
import '../../shared/theme/ace_colors.dart';
import '../../shared/theme/ace_theme.dart';
import '../../shared/widgets/ace_button.dart';
import '../../shared/widgets/ace_icon.dart';
import '../route_meta.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';

class DefaultLayout extends StatelessWidget {
  const DefaultLayout({super.key, required this.meta, required this.path, required this.canPop, required this.child});

  final RouteMeta meta;
  final String path;
  final bool canPop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final showFooter = !meta.hideFooter && !path.contains('login');
    final mq = MediaQuery.of(context);
    final body = showFooter
        ? MediaQuery(
            data: mq.copyWith(padding: mq.padding.copyWith(bottom: mq.padding.bottom + footerOverlayHeight)),
            child: child,
          )
        : child;
    return Scaffold(
      backgroundColor: AceColors.bg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  AceHeader(meta: meta, path: path, canPop: canPop),
                  Expanded(child: body),
                ],
              ),
            ),
          ),
          if (showFooter) Positioned(left: 0, right: 0, bottom: 0, child: AceFooter(path: path)),
        ],
      ),
    );
  }
}

class _BackChip extends StatelessWidget {
  const _BackChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AcePill(
      height: 44,
      color: AceColors.card,
      padding: const EdgeInsets.fromLTRB(10, 0, 18, 0),
      onTap: () => context.canPop() ? context.pop() : context.go('/'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          const AceIcon('chevron-left', size: 20),
          Text(label, style: AceText.style(size: 14, weight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class EmptyLayout extends StatelessWidget {
  const EmptyLayout({super.key, required this.path, required this.canPop, required this.child});

  final String path;
  final bool canPop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AceColors.bg,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          if (path != '/')
            Positioned(
              top: top + 12,
              left: 16,
              child: _BackChip(label: context.l10n.back),
            ),
        ],
      ),
    );
  }
}

class QrLayout extends StatelessWidget {
  const QrLayout({super.key, required this.path, required this.canPop, required this.child});

  final String path;
  final bool canPop;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AceColors.bg,
      body: Stack(
        children: [
          Positioned.fill(child: child),
          if (path != '/')
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 40,
              left: 0,
              right: 0,
              child: Center(child: _BackChip(label: context.l10n.backToHome)),
            ),
        ],
      ),
    );
  }
}

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AceColors.bg,
      body: SafeArea(
        bottom: false,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: child),
      ),
    );
  }
}

class SoonLayout extends StatelessWidget {
  const SoonLayout({super.key, required this.meta, required this.path, required this.canPop});

  final RouteMeta meta;
  final String path;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AceColors.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AceHeader(meta: meta, path: path, canPop: canPop),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Image.asset('assets/images/ace.png', width: 220, height: 220),
                    Text(context.l10n.soonDots, style: AceText.style(size: 20, weight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
