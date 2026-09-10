import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/theme/ace_colors.dart';
import '../../shared/theme/ace_theme.dart';
import '../../shared/widgets/ace_icon.dart';

enum ToastType { warning, danger, success, primary, secondary }

class ToastItem {
  ToastItem({required this.id, required this.type, required this.text});

  final int id;
  final ToastType type;
  final String text;
}

const toastSeconds = 5;

class ToastNotifier extends Notifier<List<ToastItem>> {
  final Map<int, Timer> _timers = {};

  @override
  List<ToastItem> build() {
    ref.onDispose(() {
      for (final t in _timers.values) {
        t.cancel();
      }
    });
    return const [];
  }

  void show(String text, {ToastType type = ToastType.primary}) {
    final id = DateTime.now().microsecondsSinceEpoch;
    state = [ToastItem(id: id, type: type, text: text), ...state];
    _timers[id] = Timer(const Duration(seconds: toastSeconds), () => remove(id));
  }

  void success(String text) => show(text, type: ToastType.success);
  void danger(String text) => show(text, type: ToastType.danger);
  void warning(String text) => show(text, type: ToastType.warning);

  void remove(int id) {
    _timers.remove(id)?.cancel();
    state = state.where((e) => e.id != id).toList();
  }
}

final toastProvider = NotifierProvider<ToastNotifier, List<ToastItem>>(ToastNotifier.new);

class ToastStack extends ConsumerWidget {
  const ToastStack({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(toastProvider);
    if (items.isEmpty) return const SizedBox.shrink();
    return Positioned(
      top: 50,
      right: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 16,
        children: [for (final item in items) _Toast(key: ValueKey(item.id), item: item)],
      ),
    );
  }
}

class _Toast extends ConsumerStatefulWidget {
  const _Toast({super.key, required this.item});

  final ToastItem item;

  @override
  ConsumerState<_Toast> createState() => _ToastState();
}

class _ToastState extends ConsumerState<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _timer = AnimationController(vsync: this, duration: const Duration(seconds: toastSeconds))..forward();

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  Color get _color => switch (widget.item.type) {
        ToastType.warning => AceColors.toastOrange,
        ToastType.danger => AceColors.toastRed,
        ToastType.success => AceColors.toastGreen,
        ToastType.primary => AceColors.toastBlue,
        ToastType.secondary => AceColors.toastGray,
      };

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: (width - 60).clamp(200, 326).toDouble(),
        constraints: const BoxConstraints(minHeight: 64),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Row(
                spacing: 16,
                children: [
                  const AceIcon('circle-information', size: 24),
                  Expanded(child: Text(widget.item.text, style: AceText.style(size: 16, weight: FontWeight.w500))),
                  GestureDetector(
                    onTap: () => ref.read(toastProvider.notifier).remove(widget.item.id),
                    child: const AceIcon('xmark', size: 24),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _timer,
                builder: (context, _) => Container(
                  width: (1 - _timer.value) * 326,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0x3C000000),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
