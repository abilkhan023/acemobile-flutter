import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';

class TimeWheel extends StatefulWidget {
  const TimeWheel({super.key, required this.value, required this.onChanged, this.label, this.minuteStep = 1});

  final String value;
  final ValueChanged<String> onChanged;
  final String? label;
  final int minuteStep;

  @override
  State<TimeWheel> createState() => _TimeWheelState();
}

class _TimeWheelState extends State<TimeWheel> {
  static const _itemHeight = 48.0;
  static const _rows = 7;

  late FixedExtentScrollController _hours;
  late FixedExtentScrollController _minutes;
  late int _hour;
  late int _minute;
  int _hourIndex = 0;
  int _minuteIndex = 0;

  List<int> get _minuteValues {
    final step = widget.minuteStep.clamp(1, 60);
    return [for (var i = 0; i * step < 60; i++) i * step];
  }

  @override
  void initState() {
    super.initState();
    _parse(widget.value);
    _hours = FixedExtentScrollController(initialItem: _hourIndex);
    _minutes = FixedExtentScrollController(initialItem: _minuteIndex);
  }

  @override
  void didUpdateWidget(covariant TimeWheel old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && widget.value != _current) {
      _parse(widget.value);
      _hours.jumpToItem(_hourIndex);
      _minutes.jumpToItem(_minuteIndex);
    }
  }

  void _parse(String value) {
    final parts = value.split(':');
    final h = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 0;
    final m = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0;
    _hour = h.clamp(0, 23);
    final values = _minuteValues;
    var best = 0;
    for (var i = 0; i < values.length; i++) {
      if ((values[i] - m).abs() < (values[best] - m).abs()) best = i;
    }
    _minute = values[best];
    _hourIndex = _hour;
    _minuteIndex = best;
  }

  String _pad(int v) => v.toString().padLeft(2, '0');

  String get _current => '${_pad(_hour)}:${_pad(_minute)}';

  void _publish() {
    final next = _current;
    if (next != widget.value) widget.onChanged(next);
  }

  @override
  void dispose() {
    _hours.dispose();
    _minutes.dispose();
    super.dispose();
  }

  Widget _wheel({required List<int> values, required int selectedIndex, required FixedExtentScrollController controller, required ValueChanged<int> onSelected}) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (_) {
        _publish();
        return false;
      },
      child: SizedBox(
        width: 96,
        child: ListWheelScrollView.useDelegate(
          controller: controller,
          itemExtent: _itemHeight,
          diameterRatio: 100,
          perspective: 0.00001,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (i) {
            HapticFeedback.selectionClick();
            onSelected(i);
          },
          childDelegate: ListWheelChildLoopingListDelegate(
            children: [
              for (final (i, v) in values.indexed) _WheelItem(text: _pad(v), distance: (i - selectedIndex).abs().clamp(0, values.length - (i - selectedIndex).abs()).clamp(0, 4)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final minuteValues = _minuteValues;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        if (widget.label != null) Text(widget.label!, textAlign: TextAlign.center, style: AceText.text),
        SizedBox(
          height: _itemHeight * _rows,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                right: 0,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(AceRadius.input)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _wheel(
                    values: List.generate(24, (i) => i),
                    selectedIndex: _hourIndex,
                    controller: _hours,
                    onSelected: (i) => setState(() {
                      _hourIndex = i % 24;
                      _hour = _hourIndex;
                    }),
                  ),
                  _wheel(
                    values: minuteValues,
                    selectedIndex: _minuteIndex,
                    controller: _minutes,
                    onSelected: (i) => setState(() {
                      _minuteIndex = i % minuteValues.length;
                      _minute = minuteValues[_minuteIndex];
                    }),
                  ),
                ],
              ),
              IgnorePointer(child: Text(':', style: AceText.style(size: 32, weight: FontWeight.w700, height: 1))),
            ],
          ),
        ),
      ],
    );
  }
}

class _WheelItem extends StatelessWidget {
  const _WheelItem({required this.text, required this.distance});

  final String text;
  final int distance;

  @override
  Widget build(BuildContext context) {
    final (size, weight, color, blur, opacity) = switch (distance) {
      0 => (32.0, FontWeight.w600, AceColors.white, 0.0, 1.0),
      1 => (24.0, FontWeight.w500, AceColors.muted, 0.3, 1.0),
      2 => (20.0, FontWeight.w400, AceColors.dim, 0.8, 0.8),
      3 => (20.0, FontWeight.w400, AceColors.dim, 1.4, 0.4),
      _ => (20.0, FontWeight.w400, AceColors.dim, 1.4, 0.0),
    };
    Widget child = Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: AceText.style(size: size, weight: weight, color: color).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
        child: Text(text),
      ),
    );
    if (blur > 0) child = ImageFiltered(imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur), child: child);
    return AnimatedOpacity(duration: const Duration(milliseconds: 200), opacity: opacity, child: child);
  }
}
