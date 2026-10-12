import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final layouts = buildZoneLayouts(size, zones, computers, defaultName: l.commonHall);
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
          if (layouts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(l.noComputers, textAlign: TextAlign.center, style: AceText.text),
            )
          else
            for (final zone in layouts)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  if (zone.name.isNotEmpty)
                    AcePill(
                      height: 26,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 6,
                        children: [
                          if (zones.where((z) => z.id == zone.id).firstOrNull?.isRoom == true)
                            const Icon(Icons.meeting_room_outlined, size: 14, color: AceColors.accent),
                          Text(zone.name, style: AceText.style(size: 12, weight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final grid = _ZoneGrid(zone: zone, selected: selected, onTap: onTap);
                      if (zone.cols * _pitch <= constraints.maxWidth) return grid;
                      return ShaderMask(
                        shaderCallback: (rect) => const LinearGradient(
                          colors: [Colors.white, Colors.white, Colors.transparent],
                          stops: [0, 0.9, 1],
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

class _ZoneGrid extends StatelessWidget {
  const _ZoneGrid({required this.zone, required this.selected, required this.onTap});

  final ZoneLayout zone;
  final Set<String> selected;
  final ValueChanged<Computer> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: zone.cols * _pitch,
      height: zone.rows * _pitch,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _FloorPainter(rows: zone.rows, cols: zone.cols))),
          for (var row = 0; row < zone.rows; row++)
            for (var col = 0; col < zone.cols; col++)
              if (zone.computers[cellKey(row, col)] case final computer?)
                Positioned(
                  left: col * _pitch + (_pitch - _tile) / 2,
                  top: row * _pitch + (_pitch - _tile) / 2,
                  child: _Pc(
                    computer: computer,
                    state: ComputerMap.stateOf(computer),
                    selected: selected.contains(computer.id),
                    onTap: () => onTap(computer),
                  ),
                ),
        ],
      ),
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
    final paint = Paint()..color = const Color(0x14FFFFFF);
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        canvas.drawCircle(Offset(c * _pitch + _pitch / 2, r * _pitch + _pitch / 2), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FloorPainter old) => old.rows != rows || old.cols != cols;
}
