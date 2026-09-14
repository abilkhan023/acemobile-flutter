import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/env.dart';
import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
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
import '../data/booking_api.dart';
import '../data/booking_models.dart';
import '../data/clubs_api.dart';
import '../data/models.dart';
import '../logic/map_layout.dart';
import '../providers/club_title.dart';
import '../widgets/club_card.dart';
import '../widgets/computer_map.dart';
import '../widgets/date_strip.dart';
import '../widgets/review_card.dart';
import '../widgets/tariffs_list.dart';
import '../widgets/time_wheel.dart';

Widget clubHeaderTitle(BuildContext context, String path) => _ClubTitle(branchId: path.split('/').last);

class _ClubTitle extends ConsumerWidget {
  const _ClubTitle({required this.branchId});

  final String branchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(clubTitleProvider(branchId));
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AceText.style(size: 16, weight: FontWeight.w600),
    );
  }
}

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

  int _step = 1;
  String? _bookDay;
  String _bookTime = '12:00';
  Computer? _computer;
  List<Tariff> _tariffs = const [];
  bool _loadingContinue = false;

  final _reviewController = TextEditingController();

  String get _book => _bookDay == null ? '' : '${_bookDay}T$_bookTime';

  List<Computer> get _allComputers => [for (final list in _computersByZone.values) ...list];

  bool get _barVisible => _step == 2 && _computer != null;

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
      if (mounted) {
        ref.read(clubTitleProvider(widget.branchId).notifier).set(_center?.name ?? branch.name ?? '');
        setState(() => _loading = false);
      }
      _zones = await booking.zones(widget.branchId);
      final datetime = await booking.serverDatetime();
      final parsed = datetime == null ? null : DateTime.tryParse(datetime);
      if (parsed != null) {
        _serverTime = parsed;
        _bookTime = DateFormat('HH:mm').format(parsed);
      }
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
    final user = ref.read(authProvider).user;
    final gameCenterId = _branch?.gameCenterId;
    if (user == null || gameCenterId == null) return;
    try {
      await ref.read(bookingApiProvider).wallets(userId: user.id, gameCenterId: gameCenterId);
    } catch (_) {}
  }

  Future<void> _applyDatetimeStates() async {
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

  void _setBookDay(String? day) {
    if (_bookDay == day) return;
    setState(() => _bookDay = day);
    _refreshComputers();
  }

  void _setBookTime(String time) {
    if (_bookTime == time) return;
    setState(() => _bookTime = time);
    _refreshComputers();
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
    showAceSheet(
      context,
      title: l.selectTariff,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 20,
          children: [
            Text(l.bookingPcAt(computer?.name ?? '', dateLabel), style: AceText.text),
            TariffsList(tariffs: _tariffs, selected: selected, serverTime: _serverTime, onSelect: (v) => setSheet(() => selected = v)),
            AceButton(
              label: l.reserve,
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
    );
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
    setState(() {
      _bookDay = null;
      _computer = null;
      _step = 1;
    });
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
    ).then((_) {
      if (mounted) setState(() => _bookDay = null);
    });
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
    if (_loading) return const Center(child: AceSpinner(color: AceColors.accent));
    final bottom = MediaQuery.paddingOf(context).bottom;
    final branch = _branch;
    final center = _center;

    return Stack(
      children: [
        AcePage(
          gap: 16,
          padding: EdgeInsets.fromLTRB(20, 8, 20, _barVisible ? 120 : 20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AceColors.card,
                borderRadius: BorderRadius.circular(AceRadius.card),
                boxShadow: AceShadows.card,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14,
                children: [
                  ClubLogo(url: center?.logo, size: 64),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(center?.name ?? '', style: AceText.title)),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _share,
                              child: const AceIcon('arrow-up-from-bracket', size: 22, color: AceColors.dim),
                            ),
                          ],
                        ),
                        Text(branch?.address ?? '', style: AceText.text),
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
                            _chip(
                              onTap: _openTariffInfo,
                              child: Text(l.fromPerHour, style: AceText.style(size: 12, weight: FontWeight.w600)),
                            ),
                            _chip(
                              onTap: _openMaps,
                              child: Text(l.openOnMap, style: AceText.style(size: 12, weight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_step == 1 ? l.computerBackup : l.selectComputer, style: AceText.title),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: _loadingBooking
                  ? const Padding(
                      key: ValueKey(0),
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: AceSpinner(color: AceColors.accent)),
                    )
                  : _step == 1
                  ? Column(
                      key: const ValueKey(1),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 18,
                      children: [
                        DateStrip(value: _bookDay, onChanged: _setBookDay, label: l.bookingDate),
                        TimeWheel(value: _bookTime, onChanged: _setBookTime, label: l.selectTime),
                        AceButton(
                          label: l.continueAction,
                          style: AceButtonStyle.red,
                          disabled: _book.isEmpty,
                          onPressed: () => setState(() => _step = 2),
                        ),
                      ],
                    )
                  : Column(
                      key: const ValueKey(2),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 14,
                      children: [
                        LinkMenu(
                          title: _reserveDateLabel(),
                          subtitle: l.changeDateTime,
                          icon: 'calendar-alt',
                          onTap: () => setState(() => _step = 1),
                        ),
                        ComputerMap(
                          size: const MapSize(xLen: Env.defaultMapSize, yLen: Env.defaultMapSize),
                          zones: _zones,
                          computers: _allComputers,
                          selected: _computer,
                          onSelect: (c) => setState(() => _computer = c),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: bottom + 22,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            offset: _barVisible ? Offset.zero : const Offset(0, 1.6),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _barVisible ? 1 : 0,
              child: IgnorePointer(
                ignoring: !_barVisible,
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.fromLTRB(22, 0, 8, 0),
                  decoration: BoxDecoration(color: AceColors.accent, borderRadius: BorderRadius.circular(32), boxShadow: AceShadows.accent),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.selectedPc(_computer?.name ?? ''),
                              style: AceText.style(size: 15, weight: FontWeight.w700, color: AceColors.white),
                            ),
                            Text(_reserveDateLabel(), style: AceText.style(size: 12, color: const Color(0xD9FFFFFF))),
                          ],
                        ),
                      ),
                      AceButton(
                        label: l.continueAction,
                        style: AceButtonStyle.white,
                        expand: false,
                        loading: _loadingContinue,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        onPressed: _continueToTariffs,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
