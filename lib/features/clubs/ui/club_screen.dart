import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../data/booking_api.dart';
import '../data/booking_models.dart';
import '../data/clubs_api.dart';
import '../data/models.dart';
import '../logic/map_layout.dart';
import '../providers/favorites.dart';
import '../widgets/computer_map.dart';
import '../widgets/date_strip.dart';
import '../widgets/review_card.dart';
import '../widgets/tariffs_list.dart';
import '../widgets/time_wheel.dart';

enum _When { now, today, tomorrow, custom }

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

  _When _when = _When.now;
  String? _bookDay;
  String _bookTime = '12:00';
  Computer? _computer;
  List<Tariff> _tariffs = const [];
  bool _loadingContinue = false;

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
      final datetime = await booking.serverDatetime();
      final parsed = datetime == null ? null : DateTime.tryParse(datetime);
      final now = parsed ?? DateTime.now();
      _serverTime = now;
      _bookTime = DateFormat('HH:mm').format(now);
      _bookDay = dateKey(now);
      await Future.wait(_zones.map((z) async => _computersByZone[z.id] = await booking.computersByZone(z.id)));
      if (_book.isNotEmpty) await _applyDatetimeStates();
    } catch (_) {} finally {
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
    final states = await ref.read(bookingApiProvider).computersMap(branchId: widget.branchId, datetime: '$_book:00');
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
    _computer = null;
    final booking = ref.read(bookingApiProvider);
    try {
      if (_book.isEmpty) {
        await Future.wait(_zones.map((z) async => _computersByZone[z.id] = await booking.computersByZone(z.id)));
      } else {
        await _applyDatetimeStates();
      }
    } catch (_) {}
    if (mounted) setState(() {});
  }



  String _reserveDateLabel() {
    final dt = DateTime.tryParse(_book);
    if (dt == null) return '';
    final locale = Localizations.localeOf(context).toString();
    return context.l10n.dateAtTime(DateFormat('d MMM yyyy', locale).format(dt), DateFormat('H:mm').format(dt));
  }

  String _formatDone(String value) {
    final dt = DateTime.tryParse(value);
    if (dt == null) return value;
    final locale = Localizations.localeOf(context).toString();
    return context.l10n.dateAtTime(DateFormat('d MMM yyyy', locale).format(dt), DateFormat('HH:mm').format(dt));
  }

  Future<void> _share() async {
    final l = context.l10n;
    try {
      await SharePlus.instance.share(
        ShareParams(
          text: '${l.shareClubsText} https://${Env.deepLinkHost}/clubs/${widget.branchId}',
          subject: l.shareTitle,
          title: l.shareTitle,
        ),
      );
    } catch (_) {}
  }

  Future<void> _continueToTariffs() async {
    final computer = _computer;
    if (computer == null) return;
    final l = context.l10n;
    setState(() => _loadingContinue = true);
    try {
      final zoneId = computer.zoneId ?? (_zones.isNotEmpty ? _zones.first.id : '');
      final tariffs = await ref.read(bookingApiProvider).availableTariffs(zoneId: zoneId, datetime: '$_book:00');
      _tariffs = [
        for (final t in tariffs)
          if ((t.duration ?? 0) > 60) t,
      ];
      if (mounted) _openTariffSheet();
    } catch (_) {
      ref.read(toastProvider.notifier).danger(l.tariffsLoadFailed);
    } finally {
      if (mounted) setState(() => _loadingContinue = false);
    }
  }

  void _openTariffSheet() {
    final l = context.l10n;
    final computer = _computer;
    final book = _book;
    final dateLabel = _reserveDateLabel();
    String? selected;
    var reserving = false;
    final zoneName = _zones.where((z) => z.id == computer?.zoneId).firstOrNull?.name ?? '';
    final wallet = (ref.read(walletsProvider).value ?? const []).where((w) => w.gameCenterId == _center?.id).firstOrNull;
    showAceSheet(
      context,
      title: l.pcInZone(computer?.name ?? '', zoneName),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text(l.bookingPcAt(computer?.name ?? '', dateLabel), style: AceText.text),
            TariffsList(tariffs: _tariffs, selected: selected, serverTime: _serverTime, onSelect: (v) => setSheet(() => selected = v)),
            if (wallet != null) Text(l.chargedFromClubBalance(_center?.name ?? '', formatMoney(wallet.balance)), style: AceText.text),
            AceButton(
              label: selected == null ? l.reserve : l.reserveFor(formatMoney(_tariffs.where((t) => t.id == selected).firstOrNull?.basePrice)),
              style: AceButtonStyle.red,
              loading: reserving,
              disabled: selected == null,
              onPressed: () async {
                setSheet(() => reserving = true);
                final ok = await _reserve(tariffId: selected!, computer: computer!, book: book);
                if (ctx.mounted) Navigator.of(ctx).pop();
                _afterReserve(ok, computer, book);
              },
            ),
          ],
        ),
      ),
    ).then((_) {
      if (mounted && _computer != null) setState(() => _computer = null);
    });
  }

  DateTime get _now => DateTime.now();

  DateTime _roundUp(DateTime t) => DateTime(t.year, t.month, t.day, t.hour + 1);

  void _setWhen(_When w) {
    if (w == _When.now) {
      final now = _now;
      setState(() {
        _when = w;
        _bookDay = dateKey(now);
        _bookTime = DateFormat('HH:mm').format(now);
      });
      _refreshComputers();
      return;
    }
    final now = _now;
    final day = switch (w) {
      _When.today => dateKey(now),
      _When.tomorrow => dateKey(now.add(const Duration(days: 1))),
      _ => _when == _When.custom ? (_bookDay ?? dateKey(now)) : dateKey(now),
    };
    _openDateSheet(w, day, w == _When.custom);
  }

  void _openDateSheet(_When w, String initialDay, bool pickDay) {
    final l = context.l10n;
    var day = initialDay;
    var time = _when == w ? _bookTime : DateFormat('HH:00').format(_roundUp(_now));
    showAceSheet(
      context,
      title: pickDay ? l.selectDate : (w == _When.today ? l.today : l.tomorrow),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            if (pickDay) DateStrip(value: day, onChanged: (v) => setSheet(() => day = v)),
            TimeWheel(value: time, onChanged: (v) => setSheet(() => time = v)),
            AceButton(
              label: '${l.apply} · ${_dayLabel(day, l)}, $time',
              style: AceButtonStyle.red,
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _when = w;
                  _bookDay = day;
                  _bookTime = time;
                });
                _refreshComputers();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _dayLabel(String day, AppLocalizations l) {
    final now = _now;
    if (day == dateKey(now)) return l.today;
    if (day == dateKey(now.add(const Duration(days: 1)))) return l.tomorrow;
    return DateFormat('d MMM', Localizations.localeOf(context).toString()).format(parseDateKey(day));
  }

  String _whenLabel(_When w, AppLocalizations l) {
    final selected = _when == w;
    return switch (w) {
      _When.now => l.now,
      _When.today => selected ? '${l.today}, $_bookTime' : l.today,
      _When.tomorrow => selected ? '${l.tomorrow}, $_bookTime' : l.tomorrow,
      _When.custom => selected && _bookDay != null ? '${_dayLabel(_bookDay!, l)}, $_bookTime' : l.pickDate,
    };
  }

  Future<bool> _reserve({required String tariffId, required Computer computer, required String book}) async {
    final api = ref.read(bookingApiProvider);
    try {
      final userTariffId = await api.createUserTariff(
        tariffId: tariffId,
        gameCenterId: _center?.id ?? '',
        branchId: _branch?.id ?? widget.branchId,
      );
      await ref.read(reservationsApiProvider).create(dateTime: '$book:00', computerId: computer.id, userTariffId: userTariffId);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _afterReserve(bool ok, Computer computer, String book) {
    if (!mounted) return;
    setState(() => _computer = null);
    _refreshComputers();
    final l = context.l10n;
    final name = computer.name ?? '';
    showAceSheet(
      context,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20,
        children: ok
            ? [
                SvgPicture.asset('assets/images/CheckCircle-true.svg', width: 40, height: 40, alignment: Alignment.centerLeft),
                Text(l.bookingSuccess, style: AceText.title),
                Text(l.pcReserved(name), style: AceText.title),
                Text(l.bookingDetails(_formatDone('$book:00')), style: AceText.text),
                Text(l.thanksForChoosing, style: AceText.text),
                AceButton(label: l.ready, style: AceButtonStyle.red, onPressed: () => Navigator.of(ctx).pop()),
              ]
            : [
                SvgPicture.asset('assets/images/WarningExclamination.svg', width: 40, height: 40, alignment: Alignment.centerLeft),
                Text(l.somethingWentWrong, style: AceText.title),
                Text(l.couldNotReserve(name), style: AceText.text),
                AceButton(label: l.startOver, style: AceButtonStyle.red, onPressed: () => Navigator.of(ctx).pop()),
              ],
      ),
    );
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              spacing: 4,
                              children: [for (var i = 0; i < stars; i++) const AceIcon('star-filled', size: 8)],
                            ),
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

  Widget _chip({required Widget child, VoidCallback? onTap}) =>
      AcePill(height: 30, padding: const EdgeInsets.symmetric(horizontal: 12), onTap: onTap, child: child);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final branch = _branch;
    final center = _center;
    final fav = ref.watch(favoritesProvider).contains(widget.branchId);
    final free = _allComputers.where((c) => ComputerMap.stateOf(c) == 'FREE').length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Row(
            spacing: 12,
            children: [
              AceCircleButton(icon: 'chevron-left', onTap: () => context.canPop() ? context.pop() : context.go('/')),
              Expanded(
                child: Column(
                  children: [
                    Text(center?.name ?? branch?.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.style(size: 16, weight: FontWeight.w600)),
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
              : AcePage(
                  gap: 14,
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        spacing: 8,
                        children: [
                          for (final w in _When.values)
                            AcePill(
                              height: 34,
                              color: _when == w ? AceColors.accent : AceColors.cardAlt,
                              onTap: () => _setWhen(w),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 6,
                                children: [
                                  if (w == _When.custom) AceIcon('calendar-alt', size: 15, color: _when == w ? AceColors.white : AceColors.muted),
                                  Text(_whenLabel(w, l), style: AceText.style(size: 13, weight: FontWeight.w600, color: _when == w ? AceColors.white : AceColors.text)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
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
                        _chip(onTap: _openTariffInfo, child: Text(l.fromPerHour, style: AceText.style(size: 12, weight: FontWeight.w600))),
                        _chip(onTap: _openMaps, child: Text(l.openOnMap, style: AceText.style(size: 12, weight: FontWeight.w600))),
                        _chip(onTap: _share, child: const AceIcon('arrow-up-from-bracket', size: 14)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text(l.selectComputer, style: AceText.title)),
                        if (!_loadingBooking)
                          AcePill(
                            height: 28,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: const Color(0x2434C77B),
                            child: Text(l.freeCount('$free'), style: AceText.style(size: 12, weight: FontWeight.w600, color: AceColors.success)),
                          ),
                      ],
                    ),
                    if (_loadingBooking)
                      const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Center(child: AceSpinner(color: AceColors.accent)))
                    else
                      ComputerMap(
                        size: const MapSize(xLen: Env.defaultMapSize, yLen: Env.defaultMapSize),
                        zones: _zones,
                        computers: _allComputers,
                        selected: _computer,
                        onSelect: (c) {
                          if (_loadingContinue) return;
                          setState(() => _computer = c);
                          _continueToTariffs();
                        },
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
