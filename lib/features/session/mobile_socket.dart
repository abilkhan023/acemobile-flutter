import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/env.dart';
import '../../core/toast/toast.dart';
import '../../core/utils/l10n.dart';
import '../../core/utils/money.dart';
import '../auth/providers/auth_provider.dart';
import '../settings/locale_provider.dart';

class SessionContext {
  const SessionContext({required this.userId, this.username, this.isGuest = false, this.activeSession = false, this.computerId, this.computerName});

  final String userId;
  final String? username;
  final bool isGuest;
  final bool activeSession;
  final String? computerId;
  final String? computerName;

  factory SessionContext.fromJson(Map<String, dynamic> j) => SessionContext(
        userId: (j['user_id'] ?? '').toString(),
        username: j['username']?.toString(),
        isGuest: j['is_guest'] == true,
        activeSession: j['active_session'] == true,
        computerId: j['computer_id']?.toString(),
        computerName: j['computer_name']?.toString(),
      );

  SessionContext cleared() => SessionContext(userId: userId, username: username, isGuest: isGuest);
}

class SessionInfo {
  const SessionInfo({
    required this.sessionId,
    required this.tariffType,
    this.startedAt,
    this.endsAt,
    this.tariffId,
    this.tariffName,
    this.originalPrice,
    this.discountPercent,
    this.finalPrice,
  });

  final String sessionId;
  final String tariffType;
  final String? startedAt;
  final String? endsAt;
  final String? tariffId;
  final String? tariffName;
  final String? originalPrice;
  final String? discountPercent;
  final String? finalPrice;

  factory SessionInfo.fromJson(Map<String, dynamic> j) => SessionInfo(
        sessionId: (j['session_id'] ?? '').toString(),
        tariffType: (j['tariff_type'] ?? 'tariff').toString(),
        startedAt: j['started_at']?.toString(),
        endsAt: j['ends_at']?.toString(),
        tariffId: j['tariff_id']?.toString(),
        tariffName: j['tariff_name']?.toString(),
        originalPrice: j['original_price']?.toString(),
        discountPercent: j['discount_percent']?.toString(),
        finalPrice: j['final_price']?.toString(),
      );

  DateTime? get endsAtUtc {
    final raw = endsAt;
    if (raw == null) return null;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return null;
    if (raw.endsWith('Z') || RegExp(r'[+-]\d\d:?\d\d$').hasMatch(raw)) return parsed.toUtc();
    return DateTime.utc(parsed.year, parsed.month, parsed.day, parsed.hour, parsed.minute, parsed.second, parsed.millisecond);
  }
}

class WalletBalance {
  const WalletBalance({required this.balance, required this.bonuses});

  final String balance;
  final String bonuses;

  factory WalletBalance.fromJson(Map<String, dynamic> j) =>
      WalletBalance(balance: (j['balance'] ?? '0').toString(), bonuses: (j['bonuses'] ?? '0').toString());
}

enum SocketStatus { closed, connecting, open }

class SocketState {
  const SocketState({
    this.status = SocketStatus.closed,
    this.context,
    this.session,
    this.balance,
    this.timeOffset = 0,
    this.walletsVersion = 0,
  });

  final SocketStatus status;
  final SessionContext? context;
  final SessionInfo? session;
  final WalletBalance? balance;
  final int timeOffset;
  final int walletsVersion;

  bool get hasActiveSession => context?.activeSession == true && session != null;

  SocketState copyWith({
    SocketStatus? status,
    SessionContext? context,
    SessionInfo? session,
    WalletBalance? balance,
    int? timeOffset,
    int? walletsVersion,
    bool clearContext = false,
    bool clearSession = false,
    bool clearBalance = false,
  }) =>
      SocketState(
        status: status ?? this.status,
        context: clearContext ? null : (context ?? this.context),
        session: clearSession ? null : (session ?? this.session),
        balance: clearBalance ? null : (balance ?? this.balance),
        timeOffset: timeOffset ?? this.timeOffset,
        walletsVersion: walletsVersion ?? this.walletsVersion,
      );
}

class _PendingStop {
  _PendingStop(this.completer, this.timer, this.requestId);

  final Completer<dynamic> completer;
  final Timer timer;
  final String requestId;
}

class MobileSocket extends Notifier<SocketState> with WidgetsBindingObserver {
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  Timer? _reconnectTimer;
  String? _rejectedToken;
  String? _token;
  _PendingStop? _pendingStop;
  bool _disposed = false;

  @override
  SocketState build() {
    _disposed = false;
    WidgetsBinding.instance.addObserver(this);
    _connectivity = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) reconnectIfNeeded();
    });
    ref.listen<String?>(authProvider.select((s) => s.accessToken), (_, token) {
      _rejectedToken = null;
      _applyToken(token);
    });
    ref.onDispose(() {
      _disposed = true;
      WidgetsBinding.instance.removeObserver(this);
      _connectivity?.cancel();
      _reconnectTimer?.cancel();
      _close();
    });
    final initial = ref.read(authProvider).accessToken;
    Future.microtask(() => _applyToken(initial));
    return const SocketState();
  }

  AppLocalizations get _l => lookupAppLocalizations(ref.read(localeProvider));

  ToastNotifier get _toast => ref.read(toastProvider.notifier);

  void _applyToken(String? token) {
    if (_disposed) return;
    _token = (token == null || token.isEmpty) ? null : token;
    if (_token == null) {
      _close();
      state = const SocketState();
    } else {
      _connect();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (this.state.status == SocketStatus.open) {
      requestInfo();
    } else {
      reconnectIfNeeded();
    }
  }

  void reconnectIfNeeded() {
    if (_token == null) return;
    if (_rejectedToken != null && _rejectedToken == _token) return;
    if (state.status == SocketStatus.closed) _connect();
  }

  Future<void> _connect() async {
    final token = _token;
    if (token == null || _disposed) return;
    if (state.status != SocketStatus.closed) return;
    _reconnectTimer?.cancel();
    state = state.copyWith(status: SocketStatus.connecting);
    final uri = Uri.parse('${Env.wsUrl}?kind=mobile&token=$token');
    try {
      final channel = WebSocketChannel.connect(uri);
      await channel.ready;
      if (_disposed || _token != token) {
        channel.sink.close();
        return;
      }
      _channel = channel;
      debugPrint('[mobileSocket] open');
      state = state.copyWith(status: SocketStatus.open);
      _sub = channel.stream.listen(_onMessage, onDone: _onClosed, onError: (Object e) => _onClosed());
      requestInfo();
    } catch (e) {
      debugPrint('[mobileSocket] connect failed: $e');
      _channel = null;
      state = state.copyWith(status: SocketStatus.closed);
      _scheduleReconnect();
    }
  }

  void _onClosed() {
    debugPrint('[mobileSocket] disconnected');
    _sub?.cancel();
    _sub = null;
    _channel = null;
    if (_disposed) return;
    state = state.copyWith(status: SocketStatus.closed);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed || _token == null) return;
    if (_rejectedToken != null && _rejectedToken == _token) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (state.status == SocketStatus.closed) _connect();
    });
  }

  void _close() {
    _reconnectTimer?.cancel();
    _sub?.cancel();
    _sub = null;
    _channel?.sink.close();
    _channel = null;
    if (!_disposed && state.status != SocketStatus.closed) state = state.copyWith(status: SocketStatus.closed);
  }

  bool _send(String kind, [Map<String, dynamic> extra = const {}]) {
    final channel = _channel;
    if (channel == null || state.status != SocketStatus.open) return false;
    channel.sink.add(jsonEncode({
      'mobile': {'kind': kind},
      'client_time': DateTime.now().millisecondsSinceEpoch,
      ...extra,
    }));
    return true;
  }

  bool requestInfo() => _send('info');

  Future<dynamic> stopSession() {
    if (_pendingStop != null) return Future.error(StateError('already_pending'));
    final completer = Completer<dynamic>();
    final requestId = const Uuid().v4();
    final timer = Timer(const Duration(seconds: 10), () {
      _pendingStop = null;
      if (!completer.isCompleted) completer.completeError(TimeoutException('stop_session'));
    });
    _pendingStop = _PendingStop(completer, timer, requestId);
    if (!_send('stop_session', {'request_id': requestId})) {
      timer.cancel();
      _pendingStop = null;
      return Future.error(StateError('socket_closed'));
    }
    return completer.future;
  }

  void _settleStop(bool ok, dynamic payload, String? requestId) {
    final pending = _pendingStop;
    if (pending == null) return;
    if (requestId != null && requestId != pending.requestId) return;
    pending.timer.cancel();
    _pendingStop = null;
    if (pending.completer.isCompleted) return;
    if (ok) {
      pending.completer.complete(payload);
    } else {
      pending.completer.completeError(payload ?? StateError('stop_failed'));
    }
  }

  void _clearSession() {
    state = state.copyWith(clearSession: true, clearBalance: true, context: state.context?.cleared());
  }

  void _bumpWallets() => state = state.copyWith(walletsVersion: state.walletsVersion + 1);

  void _onMessage(dynamic raw) {
    debugPrint('[mobileSocket] <- ${raw.toString().substring(0, raw.toString().length.clamp(0, 160))}');
    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(raw as String);
      if (decoded is! Map) return;
      data = Map<String, dynamic>.from(decoded);
    } catch (_) {
      return;
    }
    final offset = data['time_offset'];
    if (offset is num) state = state.copyWith(timeOffset: offset.toInt());

    final payload = data['data'];
    final map = payload is Map ? Map<String, dynamic>.from(payload) : <String, dynamic>{};

    switch (data['message_type']) {
      case 'context':
        final ctx = SessionContext.fromJson(map);
        state = state.copyWith(context: ctx);
        if (!ctx.activeSession) _clearSession();
      case 'session_info':
        state = state.copyWith(session: SessionInfo.fromJson(map));
      case 'balance':
        state = state.copyWith(balance: WalletBalance.fromJson(map));
      case 'session_stopped':
        _clearSession();
        _settleStop(true, payload, data['request_id']?.toString());
        _toast.success(_l.sessionEnded);
        _bumpWallets();
      case 'session_ended':
        _clearSession();
        requestInfo();
        _bumpWallets();
      case 'notification':
        _notifyMoney(data['kind']?.toString(), _parseMoneyEvent(payload));
        _bumpWallets();
        requestInfo();
      case 'error':
        debugPrint('[mobileSocket] server error: $data');
        final kind = data['kind']?.toString();
        if (kind == 'invalid_token' || kind == 'token_expired') _handleInvalidToken(kind!);
        if (kind == 'session_not_found') {
          _clearSession();
          _settleStop(false, StateError('session_not_found'), data['request_id']?.toString());
          _toast.warning(_l.noActiveSession);
        }
    }
  }

  Map<String, dynamic>? _parseMoneyEvent(dynamic raw) {
    try {
      final parsed = raw is String ? jsonDecode(raw) : raw;
      return parsed is Map ? Map<String, dynamic>.from(parsed) : null;
    } catch (_) {
      return null;
    }
  }

  void _notifyMoney(String? kind, Map<String, dynamic>? event) {
    final l = _l;
    if (kind == 'shop') {
      _toast.success(l.shopOrderPlaced);
      return;
    }
    if (event == null) {
      _toast.show(l.balanceUpdated, type: ToastType.primary);
      return;
    }
    final wallet = event['wallet_type']?.toString().toLowerCase() == 'bonuses' ? l.walletBonuses : l.walletBalance;
    final sum = formatMoney(event['sum']);
    if (event['action'] == 'pop_up') {
      _toast.success(l.topUpBy(wallet, sum));
    } else {
      _toast.warning(l.withdrawBy(wallet, sum));
    }
  }

  void _handleInvalidToken(String kind) {
    _rejectedToken = _token;
    _close();
    if (kind == 'token_expired') _toast.danger(_l.sessionExpired);
  }
}

final mobileSocketProvider = NotifierProvider<MobileSocket, SocketState>(MobileSocket.new);

final walletsVersionProvider = Provider<int>((ref) => ref.watch(mobileSocketProvider.select((s) => s.walletsVersion)));
