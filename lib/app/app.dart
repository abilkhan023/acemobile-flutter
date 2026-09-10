import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/env.dart';
import '../core/toast/toast.dart';
import '../core/utils/l10n.dart';
import '../features/push/push_service.dart';
import '../features/session/mobile_socket.dart';
import '../features/settings/locale_provider.dart';
import '../shared/theme/ace_theme.dart';
import 'router.dart';

class AceApp extends ConsumerStatefulWidget {
  const AceApp({super.key});

  @override
  ConsumerState<AceApp> createState() => _AceAppState();
}

class _AceAppState extends ConsumerState<AceApp> {
  StreamSubscription<Uri>? _links;
  Uri? _lastLink;
  DateTime? _lastLinkAt;

  @override
  void initState() {
    super.initState();
    final appLinks = AppLinks();
    _links = appLinks.uriLinkStream.listen(_onLink);
    appLinks.getInitialLink().then((uri) {
      if (uri != null) _onLink(uri);
    });
    ref.read(pushServiceProvider).init();
    ref.read(mobileSocketProvider);
  }

  void _onLink(Uri uri) {
    final now = DateTime.now();
    if (uri == _lastLink && _lastLinkAt != null && now.difference(_lastLinkAt!) < const Duration(seconds: 2)) return;
    _lastLink = uri;
    _lastLinkAt = now;
    if (uri.host.isNotEmpty && uri.host != Env.deepLinkHost) return;
    final path = uri.path.isEmpty ? '/' : uri.path;
    final location = uri.hasQuery ? '$path?${uri.query}' : path;
    ref.read(routerProvider).go(location);
  }

  @override
  void dispose() {
    _links?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: 'Ace Gaming',
      debugShowCheckedModeBanner: false,
      theme: AceTheme.dark,
      darkTheme: AceTheme.dark,
      themeMode: ThemeMode.dark,
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) => Stack(
        children: [
          ?child,
          const ToastStack(),
        ],
      ),
    );
  }
}
