import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/l10n.dart';
import '../../shared/theme/ace_colors.dart';
import '../../shared/theme/ace_theme.dart';
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
    return Scaffold(
      backgroundColor: AceColors.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AceHeader(meta: meta, path: path, canPop: canPop),
            Expanded(child: child),
            if (showFooter) AceFooter(path: path),
          ],
        ),
      ),
    );
  }
}

class _BackChip extends StatelessWidget {
  const _BackChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.canPop() ? context.pop() : context.go('/'),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            const AceIcon('chevron-left', size: 20),
            Text(label, style: AceText.style(size: 14)),
          ],
        ),
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
          if (canPop && path != '/')
            Positioned(
              top: top + 19,
              left: 2,
              child: _BackChip(label: context.l10n.back, color: const Color(0xAA000000)),
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
          if (canPop && path != '/')
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Center(child: _BackChip(label: context.l10n.backToHome, color: const Color(0x6B000000))),
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
                    Image.asset('assets/images/ace.png', width: 250, height: 250),
                    Text(context.l10n.soonDots, style: AceText.style(size: 22, weight: FontWeight.w600)),
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
