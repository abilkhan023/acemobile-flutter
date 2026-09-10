import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../data/shop_api.dart';
import '../providers/basket.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.item, this.row = false, this.big = false, this.disabled = false, this.show = false});

  final Product item;
  final bool row;
  final bool big;
  final bool disabled;
  final bool show;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(basketProvider.select((b) => b.where((i) => i.product.id == item.id).firstOrNull?.total ?? 0));
    if (row && total == 0 && !show) return const SizedBox.shrink();
    final thumb = item.thumbnailUrl;
    final url = thumb == null || thumb.isEmpty ? null : ref.watch(productImageProvider(thumb)).value;
    final basket = ref.read(basketProvider.notifier);

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: row ? 64 : double.infinity,
        height: row ? 64 : 150,
        child: url == null ? const ColoredBox(color: AceColors.card) : CachedNetworkImage(imageUrl: url, fit: BoxFit.contain, errorWidget: (_, _, _) => const ColoredBox(color: AceColors.card)),
      ),
    );
    final info = Padding(
      padding: EdgeInsets.symmetric(vertical: row ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(item.description ?? '', style: AceText.titleMini),
          Text(formatMoney(item.price ?? 0), style: AceText.text),
        ],
      ),
    );
    final actions = disabled
        ? null
        : total == 0
            ? AceButton(icon: 'plus', style: AceButtonStyle.black, padding: EdgeInsets.all(row ? 6 : 14.5), onPressed: () => basket.add(item))
            : _IncButton(value: total, small: row, onDec: () => total == 1 ? basket.remove(item) : basket.decrement(item), onInc: () => basket.increment(item));

    if (row) {
      return Row(
        spacing: 16,
        children: [
          image,
          Expanded(child: info),
          if (actions != null) SizedBox(width: 100, child: actions),
          if (big && total > 0) Text(formatMoney(total * (item.price ?? 0)), style: AceText.style(size: 16, weight: FontWeight.w600)),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: big ? Colors.transparent : AceColors.cardAlt, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [image, info, ?actions],
      ),
    );
  }
}

class _IncButton extends StatelessWidget {
  const _IncButton({required this.value, required this.onDec, required this.onInc, this.small = false});

  final int value;
  final VoidCallback onDec;
  final VoidCallback onInc;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: small ? 6 : 14.5),
      decoration: BoxDecoration(color: const Color(0xFFEDEDED), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(behavior: HitTestBehavior.opaque, onTap: onDec, child: const AceIcon('minus', size: 25, color: AceColors.card)),
          Text('$value', style: AceText.style(size: 16, weight: FontWeight.w600, color: AceColors.card)),
          GestureDetector(behavior: HitTestBehavior.opaque, onTap: onInc, child: const AceIcon('plus', size: 25, color: AceColors.card)),
        ],
      ),
    );
  }
}
