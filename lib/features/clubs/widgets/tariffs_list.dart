import 'package:flutter/material.dart';

import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../data/booking_models.dart';

String tariffTimeToBuy(Tariff tariff, DateTime? serverTime) {
  final availabilities = tariff.property?.availabilities?.toBuy ?? const [];
  if (serverTime == null) return '---';
  final time = '${serverTime.hour.toString().padLeft(2, '0')}:${serverTime.minute.toString().padLeft(2, '0')}:${serverTime.second.toString().padLeft(2, '0')}';
  for (final a in availabilities) {
    final from = a.availableFrom;
    final to = a.availableTo;
    if (from == null || to == null) continue;
    if (time.compareTo(from) >= 0 && time.compareTo(to) <= 0) {
      String hm(String v) {
        final p = v.split(':');
        return p.length >= 2 ? '${p[0]}:${p[1]}' : v;
      }
      return '${hm(from)} - ${hm(to)}';
    }
  }
  return '---';
}

class TariffsList extends StatelessWidget {
  const TariffsList({super.key, required this.tariffs, required this.selected, required this.onSelect, required this.serverTime});

  final List<Tariff> tariffs;
  final String? selected;
  final ValueChanged<String?> onSelect;
  final DateTime? serverTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        for (final t in tariffs)
          GestureDetector(
            onTap: () => onSelect(selected == t.id ? null : t.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              decoration: BoxDecoration(
                color: AceColors.cardAlt,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected == t.id ? AceColors.white : Colors.transparent, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text('${t.basePrice ?? ''} ₸', style: AceText.style(size: 16, weight: FontWeight.w700)),
                        Text('${t.name ?? ''} (${tariffTimeToBuy(t, serverTime)})', style: AceText.style(size: 12, weight: FontWeight.w500, color: AceColors.muted)),
                      ],
                    ),
                  ),
                  if (selected == t.id) const AceIcon('check-circle', size: 24),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
