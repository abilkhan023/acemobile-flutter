import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../data/booking_models.dart';
import '../logic/map_layout.dart';

const _pitch = 56.0;
const _tile = 46.0;
const _lineColor = Color(0xFF262626);
const _freeColor = Color(0xFF34C77B);
const _busyColor = Color(0xFFEA4B4B);
const _busySoonColor = Color(0xFFF2A33A);
const _offColor = Color(0xFF3A3A3A);
const _gridBg = Color(0xFF0F0F0F);

class ComputerMap extends StatelessWidget {
  const ComputerMap({super.key, required this.size, required this.zones, required this.computers, required this.selected, required this.onSelect});

  final MapSize size;
  final List<Zone> zones;
  final List<Computer> computers;
  final Computer? selected;
  final ValueChanged<Computer?> onSelect;

  String _stateOf(Computer c) => (c.state ?? '').toUpperCase();

  Color _bg(String state) => switch (state) {
        'FREE' => _freeColor,
        'IN_USE' => _busyColor,
        'RESERVED' || 'TECHNICAL_WORK' => _busySoonColor,
        _ => _offColor,
      };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final layout = buildLayout(size, zones, computers);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            _Legend(color: _freeColor, label: l.legendFree),
            _Legend(color: _busySoonColor, label: l.legendBusySoon),
            _Legend(color: _busyColor, label: l.legendBusy),
            _Legend(color: _offColor, label: l.legendOff, border: true),
          ],
        ),
        if (layout == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(l.noComputers, textAlign: TextAlign.center, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: _Grid(layout: layout, selected: selected, onSelect: onSelect, stateOf: _stateOf, bg: _bg),
              ),
            ),
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label, this.border = false});

  final Color color;
  final String label;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: border ? Border.all(color: const Color(0xFF5A5A5A)) : null),
        ),
        Text(label, style: AceText.style(size: 13, weight: FontWeight.w500, color: AceColors.muted)),
      ],
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.layout, required this.selected, required this.onSelect, required this.stateOf, required this.bg});

  final MapLayout layout;
  final Computer? selected;
  final ValueChanged<Computer?> onSelect;
  final String Function(Computer) stateOf;
  final Color Function(String) bg;

  @override
  Widget build(BuildContext context) {
    final width = layout.cols * _pitch;
    final height = layout.rows * _pitch;
    return SizedBox(
      width: width + 1,
      height: height + 1,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridPainter(rows: layout.rows, cols: layout.cols))),
          for (var row = 0; row < layout.rows; row++)
            for (var col = 0; col < layout.cols; col++)
              if (layout.computers[cellKey(row, col)] case final computer?)
                Positioned(
                  left: col * _pitch + (_pitch - _tile) / 2,
                  top: row * _pitch + (_pitch - _tile) / 2,
                  child: _Pc(
                    computer: computer,
                    state: stateOf(computer),
                    color: bg(stateOf(computer)),
                    selected: selected?.id == computer.id,
                    onTap: () {
                      if (stateOf(computer) == 'RESERVED') return;
                      onSelect(selected?.id == computer.id ? null : computer);
                    },
                  ),
                ),
          for (final zone in layout.zones)
            Positioned(
              left: zone.col * _pitch,
              top: zone.row * _pitch,
              width: zone.cols * _pitch,
              height: zone.rows * _pitch,
              child: IgnorePointer(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF4A4A4A), width: 2), borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Positioned(
                      top: -9,
                      left: 10,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: zone.cols * _pitch - 20),
                        child: Container(
                          height: 12,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(color: _gridBg, borderRadius: BorderRadius.circular(3)),
                          child: Text(
                            zone.name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AceText.style(size: 10, weight: FontWeight.w700, color: const Color(0xFF8A8A8A), height: 1.2).copyWith(letterSpacing: 1.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pc extends StatelessWidget {
  const _Pc({required this.computer, required this.state, required this.color, required this.selected, required this.onTap});

  final Computer computer;
  final String state;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = computer.name ?? '';
    final onColored = color != _offColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _tile,
        height: _tile,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: AceColors.white, width: 3) : null,
        ),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: AceText.style(size: name.length > 3 ? 11 : 14, weight: FontWeight.w700, color: onColored ? AceColors.bg : AceColors.white, height: 1),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.rows, required this.cols});

  final int rows;
  final int cols;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = _gridBg;
    canvas.drawRect(Offset.zero & size, bg);
    final line = Paint()
      ..color = _lineColor
      ..strokeWidth = 1;
    for (var c = 0; c <= cols; c++) {
      final x = c * _pitch + 0.5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (var r = 0; r <= rows; r++) {
      final y = r * _pitch + 0.5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.rows != rows || old.cols != cols;
}
