import 'package:flutter/widgets.dart';

import '../l10n/generated/app_localizations.dart';

enum AceLayout { normal, empty, qr, login, soon }

typedef TitleBuilder = String Function(AppLocalizations l);
typedef HeaderActionsBuilder = Widget Function(BuildContext context);

class RouteMeta {
  const RouteMeta({
    this.title,
    this.isGuest = false,
    this.hideBack = false,
    this.hideFooter = false,
    this.hideHeader = false,
    this.isDeep = false,
    this.layout = AceLayout.normal,
    this.headerActions,
  });

  final TitleBuilder? title;
  final bool isGuest;
  final bool hideBack;
  final bool hideFooter;
  final bool hideHeader;
  final bool isDeep;
  final AceLayout layout;
  final HeaderActionsBuilder? headerActions;

  RouteMeta copyWith({AceLayout? layout}) => RouteMeta(
        title: title,
        isGuest: isGuest,
        hideBack: hideBack,
        hideFooter: hideFooter,
        hideHeader: hideHeader,
        isDeep: isDeep,
        layout: layout ?? this.layout,
        headerActions: headerActions,
      );
}
