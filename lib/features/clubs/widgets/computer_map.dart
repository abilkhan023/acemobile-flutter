import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../data/booking_models.dart';
import '../logic/map_layout.dart';

const _pitch = 54.0;
const _tile = 46.0;
const _freeBg = AceColors.cardAlt;
const _busyBg = Color(0x24F93829);
const _busyFg = Color(0xFFC9645B);
const _soonBg = Color(0x26F2A33A);
const _soonFg = Color(0xFFF2A33A);
const _offBg = Color(0xFF1B181C);
const _offFg = Color(0xFF4A454B);
const _floorBg = Color(0xFF161417);
const _zoneLine = Color(0xFF3E393F);
const _zoneLabel = Color(0xFF8C878D);
const _labelGap = 8.0;

class ComputerMap extends StatelessWidget {
  const ComputerMap({super.key, required this.size, required this.zones, required this.computers, required this.selected, required this.onTap});

  final MapSize size;
  final List<Zone> zones;
  final List<Computer> computers;
  final Set<String> selected;
  final ValueChanged<Computer> onTap;

  static String stateOf(Computer c) => (c.state ?? '').toUpperCase();

  static bool isSelectable(Computer c) {
    final s = stateOf(c);
    return s != 'RESERVED' && s != 'TECHNICAL_WORK' && c.staffHold != true;
  }

  static bool countsInCapacity(Computer c) => stateOf(c) != 'TECHNICAL_WORK';

  static bool isFree(Computer c) {
    final s = stateOf(c);
    return (s == 'FREE' || s == 'POWER_OFF') && c.staffHold != true;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final layout = buildLayout(size, zones, computers);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _Legend(color: AceColors.white, bg: _freeBg, label: l.legendFree),
              _Legend(color: _soonFg, bg: _soonBg, label: l.legendBusySoon),
              _Legend(color: _busyFg, bg: _busyBg, label: l.legendBusy),
              _Legend(color: _offFg, bg: _offBg, label: l.legendOff),
            ],
          ),
          if (layout == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(l.noComputers, textAlign: TextAlign.center, style: AceText.text),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final grid = _MapGrid(layout: layout, zones: zones, selected: selected, onTap: onTap);
                if (layout.cols * _pitch <= constraints.maxWidth) return Center(child: grid);
                return ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0, 0.92, 1],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(right: 24),
                    child: grid,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.bg, required this.label});

  final Color color;
  final Color bg;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(3), border: Border.all(color: color, width: 1.5))),
        Text(label, style: AceText.caption),
      ],
    );
  }
}

class _MapGrid extends StatelessWidget {
  const _MapGrid({required this.layout, required this.zones, required this.selected, required this.onTap});

  final MapLayout layout;
  final List<Zone> zones;
  final Set<String> selected;
  final ValueChanged<Computer> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: _labelGap),
      child: SizedBox(
        width: layout.cols * _pitch,
        height: layout.rows * _pitch,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(color: _floorBg, borderRadius: BorderRadius.circular(6)),
                child: CustomPaint(painter: _FloorPainter(rows: layout.rows, cols: layout.cols)),
              ),
            ),
            for (final zone in layout.zones)
              Positioned(
                left: zone.col * _pitch,
                top: zone.row * _pitch,
                width: zone.cols * _pitch,
                height: zone.rows * _pitch,
                child: IgnorePointer(
                  child: _ZoneFrame(name: zone.name, room: zones.where((z) => z.id == zone.id).firstOrNull?.isRoom == true),
                ),
              ),
            for (final MapEntry(key: key, value: computer) in layout.computers.entries)
              Positioned(
                left: int.parse(key.split('-')[1]) * _pitch + (_pitch - _tile) / 2,
                top: int.parse(key.split('-')[0]) * _pitch + (_pitch - _tile) / 2,
                child: _Pc(
                  computer: computer,
                  state: ComputerMap.stateOf(computer),
                  selected: selected.contains(computer.id),
                  onTap: () => onTap(computer),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ZoneFrame extends StatelessWidget {
  const _ZoneFrame({required this.name, required this.room});

  final String name;
  final bool room;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(border: Border.all(color: _zoneLine, width: 2), borderRadius: BorderRadius.circular(10)),
          ),
        ),
        if (name.isNotEmpty)
          Positioned(
            left: 10,
            right: 10,
            top: -_labelGap,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: _labelGap * 2,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(color: _floorBg, borderRadius: BorderRadius.circular(4)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    if (room) const Icon(Icons.meeting_room_outlined, size: 11, color: AceColors.accent),
                    Flexible(
                      child: Text(
                        name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AceText.style(size: 10, weight: FontWeight.w700, color: _zoneLabel, height: 1).copyWith(letterSpacing: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Pc extends StatelessWidget {
  const _Pc({required this.computer, required this.state, required this.selected, required this.onTap});

  final Computer computer;
  final String state;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = computer.name ?? '';
    final (bg, fg) = switch (computer.staffHold == true ? 'RESERVED' : state) {
      'FREE' => (_freeBg, AceColors.white),
      'IN_USE' => (_busyBg, _busyFg),
      'RESERVED' || 'TECHNICAL_WORK' => (_soonBg, _soonFg),
      _ => (_offBg, _offFg),
    };
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: _tile,
        height: _tile,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AceColors.accent : bg,
          borderRadius: BorderRadius.circular(AceRadius.tile),
          boxShadow: selected ? AceShadows.accent : null,
        ),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: AceText.style(size: name.length > 3 ? 11 : 13, weight: FontWeight.w600, color: selected ? AceColors.white : fg, height: 1),
        ),
      ),
    );
  }
}

class _FloorPainter extends CustomPainter {
  const _FloorPainter({required this.rows, required this.cols});

  final int rows;
  final int cols;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x12FFFFFF)
      ..strokeWidth = 1;
    for (var c = 1; c < cols; c++) {
      canvas.drawLine(Offset(c * _pitch, 0), Offset(c * _pitch, size.height), paint);
    }
    for (var r = 1; r < rows; r++) {
      canvas.drawLine(Offset(0, r * _pitch), Offset(size.width, r * _pitch), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FloorPainter old) => old.rows != rows || old.cols != cols;
}
