import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/balance/providers/balance_providers.dart';
import '../features/home/providers/home_providers.dart';
import '../features/news/data/news_api.dart';
import '../shared/widgets/refresh_on_enter.dart';
import '../shared/theme/ace_colors.dart';
import '../features/about/ui/about_screen.dart';
import '../features/about/ui/privacy_policy_screen.dart';
import '../features/activity/ui/activity_detail_screen.dart';
import '../features/activity/ui/activity_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/ui/email_login_screen.dart';
import '../features/auth/ui/enter_code_screen.dart';
import '../features/auth/ui/login_screen.dart';
import '../features/auth/ui/new_password_screen.dart';
import '../features/auth/ui/recover_email_screen.dart';
import '../features/auth/ui/register_screen.dart';
import '../features/balance/ui/balance_form_screen.dart';
import '../features/balance/ui/balance_id_screen.dart';
import '../features/balance/ui/balance_replenishment_screen.dart';
import '../features/balance/ui/balance_screen.dart';
import '../features/balance/ui/balance_story_screen.dart';
import '../features/balance/ui/current_balance_screen.dart';
import '../features/clubs/ui/club_screen.dart';
import '../features/clubs/ui/clubs_feed_screen.dart';
import '../features/locations/ui/locations_screen.dart';
import '../features/news/ui/news_detail_screen.dart';
import '../features/news/ui/news_screen.dart';
import '../features/notifications/ui/notifications_screen.dart';
import '../features/onboarding/ui/onboarding_screen.dart';
import '../features/payments/ui/add_new_card_screen.dart';
import '../features/payments/ui/payment_details_screen.dart';
import '../features/payments/ui/payment_history_screen.dart';
import '../features/payments/ui/payment_methods_screen.dart';
import '../features/profile/ui/change_password_screen.dart';
import '../features/profile/ui/personal_information_screen.dart';
import '../features/profile/ui/profile_screen.dart';
import '../features/profile/ui/promocode_screen.dart';
import '../features/qr/ui/qr_screen.dart';
import '../features/shop/ui/order_details_screen.dart';
import '../features/shop/ui/shop_screen.dart';
import '../features/stories/ui/stories_screen.dart';
import 'layouts/layouts.dart';
import 'route_meta.dart';

class RouterRefresh extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final routerRefreshProvider = Provider<RouterRefresh>((ref) {
  final notifier = RouterRefresh();
  ref.onDispose(notifier.dispose);
  ref.listen(isAuthProvider, (_, _) => notifier.refresh());
  return notifier;
});

final _metas = <String, RouteMeta>{};

RouteMeta metaForState(GoRouterState state) {
  final pattern = state.fullPath ?? state.matchedLocation;
  var meta = _metas[pattern] ?? const RouteMeta();
  if (pattern == '/login/:option') {
    final option = state.pathParameters['option'];
    if (option == 'apple' || option == 'google') meta = meta.copyWith(layout: AceLayout.soon);
  }
  return meta;
}

const _instantPaths = {'/', '/:uuid', '/clubs', '/activity', '/balance', '/profile', '/login'};

class _DeepPage<T> extends CupertinoPage<T> {
  const _DeepPage({required super.child, super.key});

  @override
  Route<T> createRoute(BuildContext context) => _DeepRoute<T>(page: this);
}

class _DeepRoute<T> extends PageRoute<T> with CupertinoRouteTransitionMixin<T> {
  _DeepRoute({required CupertinoPage<T> page}) : super(settings: page);

  CupertinoPage<T> get _page => settings as CupertinoPage<T>;

  @override
  Widget buildContent(BuildContext context) => _page.child;

  @override
  String? get title => _page.title;

  @override
  bool get maintainState => _page.maintainState;

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);
}

GoRoute _route(String path, RouteMeta meta, Widget Function(GoRouterState state) builder) {
  _metas[path] = meta;
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      final child = ColoredBox(color: AceColors.bg, child: builder(state));
      if (_instantPaths.contains(path)) return NoTransitionPage<void>(key: state.pageKey, child: child);
      return _DeepPage<void>(key: state.pageKey, child: child);
    },
  );
}

List<RouteBase> _routes() => [
      _route('/', const RouteMeta(isGuest: true, hideBack: true, hideHeader: true), (s) => RefreshOnEnter(providers: [homeBranchesProvider, walletsProvider], child: const ClubsFeedScreen())),
      _route('/qr-code', const RouteMeta(layout: AceLayout.qr), (s) => const QrScreen()),
      _route('/clubs', const RouteMeta(isGuest: true, hideBack: true, hideHeader: true), (s) => RefreshOnEnter(providers: [homeBranchesProvider, walletsProvider], child: const ClubsFeedScreen())),
      _route('/clubs/:id', const RouteMeta(hideFooter: true, hideHeader: true, isDeep: true), (s) => ClubScreen(key: ValueKey(s.pathParameters['id']), branchId: s.pathParameters['id']!)),
      _route('/notifications', RouteMeta(title: (l) => l.notifications, hideFooter: true, layout: AceLayout.soon), (s) => const NotificationsScreen()),
      _route('/shop', RouteMeta(title: (l) => l.shop, hideFooter: true, layout: AceLayout.soon), (s) => const ShopScreen()),
      _route('/shop/order_details/:id', RouteMeta(title: (l) => l.orderDetails, hideFooter: true), (s) => const OrderDetailsScreen()),
      _route('/activity', RouteMeta(title: (l) => l.activity, hideBack: true), (s) => RefreshOnEnter(providers: [activityProvider], child: const ActivityScreen())),
      _route('/activity/:id', RouteMeta(title: (l) => l.lastActivity, hideFooter: true), (s) => ActivityDetailScreen(key: ValueKey(s.pathParameters['id']), id: s.pathParameters['id']!)),
      _route('/locations', RouteMeta(title: (l) => l.locations, layout: AceLayout.empty, isDeep: true), (s) => RefreshOnEnter(providers: [availableGameCentersProvider], child: const LocationsScreen())),
      _route('/balance', RouteMeta(title: (l) => l.wallet, hideBack: true, headerActions: balanceHeaderActions), (s) => RefreshOnEnter(providers: [walletsProvider, gameCentersProvider], child: const BalanceScreen())),
      _route('/balance/story', RouteMeta(title: (l) => l.story), (s) => const BalanceStoryScreen()),
      _route('/balance/form', RouteMeta(title: (l) => l.balance, hideFooter: true, isDeep: true), (s) => const BalanceFormScreen()),
      _route('/balance/:id', RouteMeta(title: (l) => l.topUpBalance), (s) => RefreshOnEnter(providers: [walletsProvider], child: BalanceIdScreen(key: ValueKey(s.pathParameters['id']), walletId: s.pathParameters['id']!))),
      _route('/profile', RouteMeta(title: (l) => l.profile, hideBack: true), (s) => RefreshOnEnter(providers: [walletsProvider], child: const ProfileScreen())),
      _route('/personal_information', RouteMeta(title: (l) => l.personalInformation, layout: AceLayout.soon), (s) => const PersonalInformationScreen()),
      _route('/change_password', RouteMeta(title: (l) => l.changePassword), (s) => const ChangePasswordScreen()),
      _route('/promocode', RouteMeta(title: (l) => l.promocode, layout: AceLayout.soon), (s) => const PromocodeScreen()),
      _route('/news', RouteMeta(title: (l) => l.news), (s) => RefreshOnEnter(providers: [newsListProvider], child: const NewsScreen())),
      _route('/news/:id', RouteMeta(title: (l) => l.news, layout: AceLayout.empty, isDeep: true), (s) => NewsDetailScreen(key: ValueKey(s.pathParameters['id']), id: s.pathParameters['id']!)),
      _route('/current_balance', RouteMeta(title: (l) => l.currentBalance), (s) => RefreshOnEnter(providers: [walletsProvider], child: const CurrentBalanceScreen())),
      _route('/balance_replenishment', RouteMeta(title: (l) => l.balance, hideFooter: true, isDeep: true), (s) => RefreshOnEnter(providers: [walletsProvider, gameCentersProvider], child: const BalanceReplenishmentScreen())),
      _route('/stories', const RouteMeta(hideBack: true, hideFooter: true, hideHeader: true), (s) => const StoriesScreen()),
      _route('/onboarding', const RouteMeta(hideFooter: true), (s) => const OnboardingScreen()),
      _route('/payment_methods', RouteMeta(title: (l) => l.topUpAmount, layout: AceLayout.soon), (s) => const PaymentMethodsScreen()),
      _route('/payment_history', RouteMeta(title: (l) => l.paymentHistory, layout: AceLayout.soon), (s) => const PaymentHistoryScreen()),
      _route('/payment_history/details/:id', RouteMeta(title: (l) => l.paymentDetails), (s) => const PaymentDetailsScreen()),
      _route('/about', RouteMeta(title: (l) => l.about), (s) => const AboutScreen()),
      _route('/about/privacy-policy', const RouteMeta(), (s) => const PrivacyPolicyScreen()),
      _route('/login', const RouteMeta(isGuest: true, hideBack: true, layout: AceLayout.login), (s) => const LoginScreen()),
      _route('/login/recover-password/input-email', const RouteMeta(isGuest: true), (s) => const RecoverEmailScreen()),
      _route('/login/recover-password/enter-code', const RouteMeta(isGuest: true), (s) => const EnterCodeScreen()),
      _route('/login/recover-password/new-password', const RouteMeta(isGuest: true), (s) => const NewPasswordScreen()),
      _route('/login/:option', const RouteMeta(isGuest: true, hideBack: true), (s) => s.pathParameters['option'] == 'email' ? const EmailLoginScreen() : const SizedBox()),
      _route('/register', const RouteMeta(isGuest: true, hideFooter: true), (s) => const RegisterScreen()),
      _route('/add-new-card', RouteMeta(title: (l) => l.addNewCard, layout: AceLayout.soon), (s) => const AddNewCardScreen()),
      _route('/:uuid', const RouteMeta(isGuest: true, hideBack: true, hideHeader: true), (s) => RefreshOnEnter(providers: [homeBranchesProvider, walletsProvider], child: ClubsFeedScreen(key: ValueKey(s.pathParameters['uuid']), deepLinkUuid: s.pathParameters['uuid']))),
    ];

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(routerRefreshProvider);
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuth = ref.read(isAuthProvider);
      final meta = metaForState(state);
      if (!isAuth && !meta.isGuest && state.matchedLocation != '/login') return '/login';
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(state: state, child: child),
        routes: _routes(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meta = metaForState(state);
    final path = state.uri.path;
    final canPop = ref.read(routerProvider).canPop();
    return switch (meta.layout) {
      AceLayout.normal => DefaultLayout(meta: meta, path: path, canPop: canPop, child: child),
      AceLayout.empty => EmptyLayout(path: path, canPop: canPop, child: child),
      AceLayout.qr => QrLayout(path: path, canPop: canPop, child: child),
      AceLayout.login => LoginLayout(child: child),
      AceLayout.soon => SoonLayout(meta: meta, path: path, canPop: canPop),
    };
  }
}
