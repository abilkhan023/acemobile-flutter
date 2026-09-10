import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../balance/providers/balance_providers.dart';
import '../../balance/widgets/choice_card.dart';
import '../data/shop_api.dart';
import '../providers/basket.dart';
import '../widgets/product_card.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  PaymentMethod? _method;
  final String _confirm = 'da';

  void _openBasket(List<Product> products) {
    final l = context.l10n;
    showAceSheet(
      context,
      title: l.basket,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final total = ref.watch(basketTotalProvider);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              for (final p in products) ProductCard(item: p, row: true),
              AceButton(
                label: l.goToPayment(formatMoney(total)),
                style: AceButtonStyle.white,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _openConfirmation(products);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _openConfirmation(List<Product> products) {
    final l = context.l10n;
    final total = ref.read(basketTotalProvider);
    final confirm = _confirm;
    showAceSheet(
      context,
      title: confirm.isEmpty ? l.confirmPayment : null,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            if (confirm.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  SvgPicture.asset(confirm == 'net' ? 'assets/images/CheckCircle.svg' : 'assets/images/CheckCircleGreen.svg', width: 48, height: 48),
                  Text(confirm == 'net' ? l.oopsSomethingWentWrong : l.paymentAccepted, style: AceText.style(size: 24, weight: FontWeight.w600)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(confirm == 'net' ? l.tryAgain : l.yourOrderWillBeDeliveredToYourTable, style: AceText.style(size: 20, weight: FontWeight.w600)),
                      if (confirm == 'da') Text(l.thankYouForChoosingOurServiceWeWishYouBonAppetit, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
                      if (confirm == 'da')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(color: AceColors.gray7, borderRadius: BorderRadius.circular(8)),
                          child: Text(l.goingTo, style: AceText.style(size: 12, weight: FontWeight.w600, color: const Color(0xFFFCFCFC))),
                        ),
                    ],
                  ),
                ],
              ),
            if (confirm != 'da') ...[
              ChoiceCard(value: _method, onChanged: (m) => setSheet(() => _method = m)),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: AceColors.cardAlt), bottom: BorderSide(color: AceColors.cardAlt))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l.totalPayable, style: AceText.style(size: 16, weight: FontWeight.w500, color: AceColors.muted)),
                    Text('$total', style: AceText.style(size: 20, weight: FontWeight.w600)),
                  ],
                ),
              ),
              AceButton(label: '${l.pay} ($total) ₸', style: AceButtonStyle.white, onPressed: () {}),
            ],
            if (confirm == 'da') ...[
              for (final p in products) ProductCard(item: p, row: true, disabled: true),
              AceButton(
                label: l.goToDetails,
                style: AceButtonStyle.white,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.push('/shop/order_details/1');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final products = ref.watch(warehousesProvider).value ?? const <Product>[];
    final basket = ref.watch(basketProvider);
    final width = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        AcePage(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.62,
              children: [for (final p in products) ProductCard(item: p)],
            ),
          ],
        ),
        if (basket.isNotEmpty)
          Positioned(
            left: width * 0.1,
            width: width * 0.8,
            bottom: 70,
            child: AceButton(label: l.goToBasket('${basket.length}'), style: AceButtonStyle.white, onPressed: () => _openBasket(products)),
          ),
      ],
    );
  }
}
