import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../payments/widgets/element_row.dart';
import '../data/shop_api.dart';
import '../widgets/product_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AcePage(
      fillHeight: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 32,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                ElementRow(icon: 'shopping-cart-simple', title: l.goingTo, description: l.orderStatus),
                ElementRow(icon: 'coin-vertical', title: '2 500 ₸', description: l.paidViaKaspi),
                ElementRow(icon: 'desktop', title: l.pcNumber('100'), description: l.orderDeliveredToTable),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                Text(l.orderContents, style: AceText.style(size: 20, weight: FontWeight.w600)),
                const ProductCard(item: Product(id: 'sample', description: '123', price: 123), row: true, show: true, disabled: true),
              ],
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            AceButton(label: l.print, style: AceButtonStyle.white),
            AceButton(label: l.sendByEmail),
          ],
        ),
      ],
    );
  }
}
