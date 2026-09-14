import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';

String dateKey(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

DateTime parseDateKey(String v) {
  final p = v.split('-').map(int.parse).toList();
  return DateTime(p[0], p[1], p[2]);
}

class DateStrip extends StatefulWidget {
  const DateStrip({super.key, required this.value, required this.onChanged, this.label, this.count = 14});

  final String? value;
  final ValueChanged<String> onChanged;
  final String? label;
  final int count;

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  final _controller = ScrollController();
  static const _itemWidth = 60.0;
  static const _gap = 8.0;

  DateTime get _start {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  List<DateTime> get _days => [for (var i = 0; i < widget.count; i++) _start.add(Duration(days: i))];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.value == null) {
        widget.onChanged(dateKey(_days.first));
      } else {
        _scrollToSelected();
      }
    });
  }

  @override
  void didUpdateWidget(covariant DateStrip old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      if (widget.value == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => widget.onChanged(dateKey(_days.first)));
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
      }
    }
  }

  void _scrollToSelected() {
    if (!_controller.hasClients || widget.value == null) return;
    final index = _days.indexWhere((d) => dateKey(d) == widget.value);
    if (index < 0) return;
    final viewport = _controller.position.viewportDimension;
    final target = (index * (_itemWidth + _gap) - (viewport - _itemWidth) / 2).clamp(0.0, _controller.position.maxScrollExtent);
    _controller.animateTo(target, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _caption(AppLocalizations l, String locale) {
    final v = widget.value;
    if (v == null) return '';
    final selected = parseDateKey(v);
    final diff = selected.difference(_start).inDays;
    if (diff == 0) return l.today;
    if (diff == 1) return l.tomorrow;
    return DateFormat('d MMMM', locale).format(selected);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        if (widget.label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(widget.label!, style: AceText.style(size: 15, weight: FontWeight.w600)),
              Text(_caption(l, locale), style: AceText.text),
            ],
          ),
        SizedBox(
          height: 76,
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: widget.count,
            separatorBuilder: (_, _) => const SizedBox(width: _gap),
            itemBuilder: (context, i) {
              final day = _days[i];
              final key = dateKey(day);
              final active = key == widget.value;
              final weekend = day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
              final color = active ? AceColors.white : (weekend ? AceColors.accent : null);
              return GestureDetector(
                onTap: () => widget.onChanged(key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _itemWidth,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? AceColors.accent : AceColors.card,
                    borderRadius: BorderRadius.circular(AceRadius.input),
                    boxShadow: active ? AceShadows.accent : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 4,
                    children: [
                      Text(DateFormat.E(locale).format(day).toLowerCase(), style: AceText.style(size: 12, weight: FontWeight.w500, color: color ?? AceColors.dim)),
                      Text('${day.day}', style: AceText.style(size: 20, weight: FontWeight.w700, color: color ?? AceColors.white).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
