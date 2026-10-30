import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/env.dart';
import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../home/providers/home_providers.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/link_menu.dart';
import '../../auth/providers/auth_provider.dart';
import '../../balance/providers/balance_providers.dart';
import '../data/availability.dart';
import '../data/booking_api.dart';
import '../data/booking_models.dart';
import '../data/clubs_api.dart';
import '../data/models.dart';
import '../logic/map_layout.dart';
import '../providers/favorites.dart';
import '../../bookings/data/bookings_api.dart';
import '../../bookings/widgets/booking_sheet.dart';
import '../../bookings/widgets/booking_view.dart';
import '../widgets/computer_map.dart';
import '../widgets/date_strip.dart';
import '../widgets/review_card.dart';
import '../widgets/time_wheel.dart';

class ClubScreen extends ConsumerStatefulWidget {
  const ClubScreen({super.key, required this.branchId});

  final String branchId;

  @override
  ConsumerState<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends ConsumerState<ClubScreen> {
  bool _loading = true;
  bool _loadingBooking = true;
  Branch? _branch;
  GameCenter? _center;
  List<Zone> _zones = const [];
  final Map<String, List<Computer>> _computersByZone = {};
  DateTime? _serverTime;
  Map<String, PcAvailability> _avail = const {};
  String? _availReason;

  bool _onMap = false;
  bool _isNow = true;
  String? _bookDay;
  String _bookTime = '12:00';
  final Set<String> _selected = {};
  String? _selectedZoneId;
  bool _sheetOpen = false;
  bool _mapLoading = false;
  int _statesRequest = 0;

  final _reviewController = TextEditingController();

  String get _book => _bookDay == null ? '' : '${_bookDay}T$_bookTime';

  List<Computer> get _allComputers => [for (final list in _computersByZone.values) ...list];

  @override
  void initState() {
    super.initState();
    final cards = branchCardsOf(ref.read(homeBranchesProvider));
    final card = cards.where((c) => c.branch.id == widget.branchId).firstOrNull;
    if (card != null) {
      _branch = card.branch;
      _center = card.center;
      _loading = false;
    }
    _load();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final clubs = ref.read(clubsApiProvider);
    final booking = ref.read(bookingApiProvider);
    try {
      final branch = await clubs.branch(widget.branchId);
      _branch = branch;
      if (branch.gameCenterId != null) {
        _center = await clubs.gameCenter(branch.gameCenterId!);
      }
      if (mounted) setState(() => _loading = false);
      _zones = await booking.zones(widget.branchId);
      DateTime now = DateTime.now();
      try {
        final datetime = await booking.serverDatetime();
        now = (datetime == null ? null : DateTime.tryParse(datetime)) ?? now;
      } catch (_) {}
      _serverTime = now;
      _bookTime = DateFormat('HH:mm').format(now);
      _bookDay = dateKey(now);
      await Future.wait(_zones.map((z) async => _computersByZone[z.id] = await booking.computersByZone(z.id)));
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
          _loadingBooking = false;
        });
      }
      _createWallet();
    }
  }

  Future<void> _createWallet() async {
    if (!mounted) return;
    final user = ref.read(authProvider).user;
    final gameCenterId = _branch?.gameCenterId;
    if (user == null || gameCenterId == null) return;
    try {
      await ref.read(bookingApiProvider).wallets(userId: user.id, gameCenterId: gameCenterId);
    } catch (_) {}
  }

  Future<void> _applyDatetimeStates() async {
    if (!mounted) return;
    final api = ref.read(bookingApiProvider);
    final request = ++_statesRequest;
    try {
      final av = await api.availability(branchId: widget.branchId, datetime: _isNow ? null : '$_book:00');
      if (request != _statesRequest) return;
      _avail = av.computers;
      _availReason = av.reason;
      for (final entry in _computersByZone.entries) {
        _computersByZone[entry.key] = [
          for (final c in entry.value)
            if (av.computers[c.id] case final a?) c.copyWith(state: a.stateAt ?? c.state, staffHold: a.staffHold) else c,
        ];
      }
      return;
    } catch (_) {
      _avail = const {};
      _availReason = null;
    }
    final states = await api.computersMap(branchId: widget.branchId, datetime: '$_book:00');
    if (request != _statesRequest) return;
    final byId = {for (final c in states) c.id: c};
    for (final entry in _computersByZone.entries) {
      _computersByZone[entry.key] = [
        for (final c in entry.value)
          if (byId[c.id] case final fresh? when fresh.state != c.state) fresh else c,
      ];
    }
  }

  Future<void> _refreshComputers() async {
    if (!mounted) return;
    final request = _statesRequest + 1;
    setState(() {
      _selected.clear();
      _selectedZoneId = null;
      _mapLoading = true;
    });
    try {
      await _applyDatetimeStates();
    } catch (_) {}
    if (mounted && request == _statesRequest) setState(() => _mapLoading = false);
  }

  String _reserveDateLabel() {
    final dt = DateTime.tryParse(_book);
    if (dt == null) return '';
    final locale = Localizations.localeOf(context).toString();
    return context.l10n.dateAtTime(DateFormat('d MMM yyyy', locale).format(dt), DateFormat('H:mm').format(dt));
  }

  Future<void> _share() async {
    final l = context.l10n;
    try {
      await SharePlus.instance.share(ShareParams(text: '${l.shareClubsText} https://${Env.deepLinkHost}/clubs/${widget.branchId}', subject: l.shareTitle, title: l.shareTitle));
    } catch (_) {}
  }

  Zone? get _selectedZone => _zones.where((z) => z.id == _selectedZoneId).firstOrNull;

  List<Computer> get _selectedComputers => [
    for (final c in _allComputers)
      if (_selected.contains(c.id)) c,
  ];

  void _onPcTap(Computer c) {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    final a = _avail[c.id];
    final locale = Localizations.localeOf(context).toString();
    String hm(DateTime t) => dateKey(t) == _bookDay ? DateFormat('HH:mm').format(t) : DateFormat('d MMM, HH:mm', locale).format(t);
    if (_availReason case final reason?) {
      toast.warning(_topReasonText(reason, l));
      return;
    }
    if (_mapLoading) return;
    if (!ComputerMap.isSelectable(c)) {
      _showBusy(c, a, hm);
      return;
    }
    if (a?.reason == 'not_bookable') {
      toast.warning(l.pcUnavailableNamed(c.name ?? ''));
      return;
    }
    if (!_selected.contains(c.id) && a != null) {
      if (a.freeUntil != null && (a.maxDuration ?? 0) < 12 * 3600) {
        toast.warning(l.pcFreeOnlyUntil(c.name ?? '', hm(a.freeUntil!)));
      }
    }
    final zone = _zones.where((z) => z.id == c.zoneId).firstOrNull;
    if (zone != null && zone.isRoom && _selectedZoneId != zone.id) {
      final busy = _allComputers.any((x) => x.zoneId == zone.id && (!ComputerMap.isSelectable(x) || _avail[x.id]?.reason == 'room_partially_busy'));
      if (busy) {
        toast.warning(l.roomBookedNamed(zone.name ?? ''));
        return;
      }
    }
    setState(() {
      if (zone != null && zone.isRoom) {
        final roomPcs = [
          for (final x in _allComputers)
            if (x.zoneId == zone.id) x.id,
        ];
        if (_selectedZoneId == zone.id) {
          _selected.clear();
          _selectedZoneId = null;
        } else {
          _selected
            ..clear()
            ..addAll(roomPcs);
          _selectedZoneId = zone.id;
        }
        return;
      }
      if (_selectedZoneId != c.zoneId || (_selectedZone?.isRoom ?? false)) {
        _selected.clear();
        _selectedZoneId = c.zoneId;
      }
      if (!_selected.remove(c.id)) _selected.add(c.id);
      if (_selected.isEmpty) _selectedZoneId = null;
    });
  }

  void _showBusy(Computer c, PcAvailability? a, String Function(DateTime) hm) {
    final l = context.l10n;
    final state = ComputerMap.stateOf(c);
    final (icon, text) = switch (state) {
      _ when c.staffHold == true => (Icons.phone_in_talk_outlined, l.staffHold),
      'TECHNICAL_WORK' => (Icons.build_outlined, l.techWork),
      'IN_USE' => (Icons.schedule, a?.sessionUntil != null ? l.busyUntil(hm(a!.sessionUntil!)) : l.nowBusy),
      _ when a?.reservedFrom != null && a?.reservedTo != null => (Icons.event_busy_outlined, l.busyFromTo(hm(a!.reservedFrom!), hm(a.reservedTo!))),
      _ when (a?.freeFrom ?? a?.reservedTo) != null => (Icons.event_busy_outlined, l.busyUntil(hm((a!.freeFrom ?? a.reservedTo)!))),
      _ => (Icons.event_busy_outlined, l.pcReservedShort),
    };
    showAceSheet(
      context,
      title: l.pcBusyTitle(c.name ?? ''),
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(AceRadius.input)),
            child: Row(
              spacing: 12,
              children: [
                Icon(icon, size: 24, color: AceColors.accent),
                Expanded(
                  child: Text(text, style: AceText.style(size: 16, weight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          AceButton(label: l.gotIt, style: AceButtonStyle.red, onPressed: () => Navigator.of(ctx).pop()),
        ],
      ),
    );
  }

  String _topReasonText(String reason, AppLocalizations l) => switch (reason) {
    'in_the_past' => l.pickFutureTime,
    'beyond_horizon' => l.bookingHorizon,
    _ => l.tariffUnavailableAtTime,
  };

  int? get _maxDuration {
    int? min;
    for (final id in _selected) {
      final m = _avail[id]?.maxDuration;
      if (m != null && (min == null || m < min)) min = m;
    }
    return min;
  }

  Future<void> _openBooking() async {
    final zone = _selectedZone;
    final computers = _selectedComputers;
    if (zone == null || computers.isEmpty || _sheetOpen) return;
    _sheetOpen = true;
    final names = {for (final c in _allComputers) c.id: c.name ?? ''};
    final booking = await showBookingSheet(
      context,
      zone: zone,
      computers: computers,
      bookDateTime: _book,
      dateLabel: _reserveDateLabel(),
      gameCenterId: _center?.id,
      centerName: _center?.name,
      serverTime: _serverTime,
      maxDuration: _maxDuration,
      branchId: widget.branchId,
    );
    _sheetOpen = false;
    if (!mounted || booking == null) return;
    final friends = {for (final f in ref.read(friendsProvider).value ?? const <UserRef>[]) f.id: f.username};
    _refreshComputers();
    await showBookingSuccess(context, booking, computerNames: names, friendNames: friends, zoneName: zone.name);
  }

  DateTime get _now => DateTime.now();

  void _resetWhen() {
    final now = _now;
    _bookDay = dateKey(now);
    _bookTime = DateFormat('HH:mm').format(now);
  }

  void _continue() {
    final picked = DateTime.tryParse(_book);
    final now = _now;
    if (picked == null) return;
    if (picked.isBefore(now.subtract(const Duration(minutes: 1)))) {
      if (dateKey(picked) == dateKey(now) && now.difference(picked) < const Duration(minutes: 15)) {
        _resetWhen();
      } else {
        ref.read(toastProvider.notifier).warning(context.l10n.pickFutureTime);
        return;
      }
    }
    final start = DateTime.tryParse(_book)!;
    _isNow = start.difference(now).inMinutes.abs() < 2;
    setState(() => _onMap = true);
    _refreshComputers();
  }

  void _backToTime() {
    setState(() {
      _onMap = false;
      _selected.clear();
      _selectedZoneId = null;
    });
  }

  String _dayLabel(String day, AppLocalizations l) {
    final now = _now;
    if (day == dateKey(now)) return l.today;
    if (day == dateKey(now.add(const Duration(days: 1)))) return l.tomorrow;
    return DateFormat('d MMM', Localizations.localeOf(context).toString()).format(parseDateKey(day));
  }

  void _openTariffInfo() {
    final l = context.l10n;
    showAceSheet(
      context,
      title: l.tariffs,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          LinkMenu(title: '2 000 ₸', subtitle: l.morningTariff),
          LinkMenu(title: '3 500 ₸', subtitle: l.dayTariff),
          LinkMenu(title: '5 000 ₸', subtitle: l.nightTariff),
        ],
      ),
    );
  }

  void _openMaps() {
    final l = context.l10n;
    showAceSheet(
      context,
      title: l.getDirections,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          LinkMenu(title: l.twoGis),
          LinkMenu(title: l.yandexMaps),
          LinkMenu(title: l.googleMaps),
          LinkMenu(title: l.appleMaps),
        ],
      ),
    );
  }

  void _openReviews() {
    final l = context.l10n;
    showAceSheet(
      context,
      title: l.reviews,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Row(
            spacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('8.8', style: AceText.style(size: 48, weight: FontWeight.w700, height: 1)),
                  Text(l.outOf10, style: AceText.style(size: 20, weight: FontWeight.w700)),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 6,
                  children: [
                    for (var stars = 5; stars >= 1; stars--)
                      Row(
                        spacing: 10,
                        children: [
                          SizedBox(
                            width: 56,
                            child: Row(mainAxisAlignment: MainAxisAlignment.end, spacing: 4, children: [for (var i = 0; i < stars; i++) const AceIcon('star-filled', size: 8)]),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(15)),
                                ),
                                FractionallySizedBox(
                                  widthFactor: 0.63,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(color: AceColors.white, borderRadius: BorderRadius.circular(15)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    Text(l.reviews15, style: AceText.style(size: 14, weight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
          const Column(spacing: 10, children: [ReviewCard(), ReviewCard(), ReviewCard()]),
          AceButton(
            label: l.writeAReview,
            style: AceButtonStyle.gray,
            onPressed: () {
              Navigator.of(ctx).pop();
              _openWriteReview();
            },
          ),
        ],
      ),
    );
  }

  void _openWriteReview() {
    final l = context.l10n;
    showAceSheet(
      context,
      title: l.writeAReview,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Row(spacing: 8, children: [for (var i = 0; i < 5; i++) const AceIcon('star', size: 36, color: AceColors.accent)]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              AceInput(controller: _reviewController, label: l.review, placeholder: l.startWritingOptional),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [
                  AceButton(label: l.send, style: AceButtonStyle.red, onPressed: () => Navigator.of(ctx).pop()),
                  AceButton(label: l.cancel, onPressed: () => Navigator.of(ctx).pop()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip({required Widget child, VoidCallback? onTap}) => AcePill(height: 30, padding: const EdgeInsets.symmetric(horizontal: 12), onTap: onTap, child: child);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final branch = _branch;
    final center = _center;
    final fav = ref.watch(favoritesProvider).contains(widget.branchId);
    final wallet = ref.watch(authProvider).isAuth ? ref.watch(walletClubsProvider).value?.where((w) => w.club != null && w.wallet.gameCenterId == branch?.gameCenterId).firstOrNull : null;
    final free = _allComputers.where(ComputerMap.isFree).length;
    final page = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Row(
            spacing: 12,
            children: [
              AceCircleButton(icon: 'chevron-left', onTap: () => _onMap ? _backToTime() : (context.canPop() ? context.pop() : context.go('/'))),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      center?.name ?? branch?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AceText.style(size: 16, weight: FontWeight.w600),
                    ),
                    if ((branch?.address ?? '').isNotEmpty) Text(branch!.address!, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.caption),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => ref.read(favoritesProvider.notifier).toggle(widget.branchId),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(color: AceColors.card, shape: BoxShape.circle),
                  child: Icon(fav ? Icons.favorite : Icons.favorite_border, size: 22, color: fav ? AceColors.accent : AceColors.text),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: AceSpinner(color: AceColors.accent))
              : _onMap
              ? _mapStep(l, free)
              : _timeStep(l, wallet),
        ),
        if (!_loading && !_onMap)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
              child: AceButton(label: l.continueAction, style: AceButtonStyle.red, onPressed: _loadingBooking ? null : _continue),
            ),
          ),
        if (_onMap && _selected.isNotEmpty) _selectionBar(l),
      ],
    );
    return PopScope(
      canPop: !_onMap,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _onMap) _backToTime();
      },
      child: page,
    );
  }

  Widget _timeStep(AppLocalizations l, WalletClub? wallet) {
    return AcePage(
      gap: 16,
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            if (wallet != null)
              _chip(
                onTap: () => openTopUp(ref, context, wallet),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    const AceIcon('coin-vertical', size: 12, color: AceColors.accent),
                    Text(formatMoney(wallet.ownBalance), style: AceText.style(size: 12, weight: FontWeight.w600)),
                  ],
                ),
              ),
            _chip(
              onTap: _openReviews,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  const AceIcon('star-filled', size: 12, color: AceColors.accent),
                  Text('8.8', style: AceText.style(size: 12, weight: FontWeight.w600)),
                ],
              ),
            ),
            _chip(
              onTap: _openTariffInfo,
              child: Text(l.fromPerHour, style: AceText.style(size: 12, weight: FontWeight.w600)),
            ),
            _chip(
              onTap: _openMaps,
              child: Text(l.openOnMap, style: AceText.style(size: 12, weight: FontWeight.w600)),
            ),
            _chip(onTap: _share, child: const AceIcon('arrow-up-from-bracket', size: 14)),
          ],
        ),
        Text(l.whenToPlay, style: AceText.title),
        DateStrip(value: _bookDay, count: 7, expand: true, onChanged: (v) => setState(() => _bookDay = v)),
        TimeWheel(value: _bookTime, onChanged: (v) => setState(() => _bookTime = v)),
      ],
    );
  }

  Widget _mapStep(AppLocalizations l, int free) {
    final when = _isNow ? l.now : '${_dayLabel(_bookDay!, l)}, $_bookTime';
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 6, 20, _selected.isEmpty ? 12 + MediaQuery.paddingOf(context).bottom : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _backToTime,
                  child: Row(
                    spacing: 8,
                    children: [
                      const AceIcon('calendar-alt', size: 18, color: AceColors.accent),
                      Flexible(
                        child: Text(when, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.title),
                      ),
                    ],
                  ),
                ),
              ),
              if (!_mapLoading)
                AcePill(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: const Color(0x2434C77B),
                  child: Text(
                    l.freeCount('$free'),
                    style: AceText.style(size: 12, weight: FontWeight.w600, color: AceColors.success),
                  ),
                ),
            ],
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedOpacity(
                  opacity: _mapLoading ? 0.3 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: ComputerMap(
                    size: const MapSize(xLen: Env.defaultMapSize, yLen: Env.defaultMapSize),
                    zones: _zones,
                    computers: _allComputers,
                    selected: _selected,
                    onTap: _onPcTap,
                  ),
                ),
                if (_mapLoading)
                  const Positioned.fill(
                    child: Center(child: AceSpinner(color: AceColors.accent)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectionBar(AppLocalizations l) {
    final zone = _selectedZone;
    final count = _selected.length;
    final room = zone?.isRoom ?? false;
    final names = _selectedComputers.map((c) => c.name ?? '').join(', ');
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.bar),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(room ? l.roomSelected(zone?.name ?? '', '$count') : l.selectedPcs('$count'), style: AceText.style(size: 15, weight: FontWeight.w600)),
                  Text(room ? _reserveDateLabel() : names, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.caption),
                ],
              ),
            ),
            AceButton(label: l.continueAction, style: AceButtonStyle.red, expand: false, padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20), fontSize: 14, onPressed: _openBooking),
          ],
        ),
      ),
    );
  }
}
