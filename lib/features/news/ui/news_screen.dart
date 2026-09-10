import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/ace_page.dart';
import '../../clubs/widgets/club_card.dart';
import '../data/news_api.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsListProvider).value ?? const <NewsItem>[];
    return AcePage(
      gap: 12,
      children: [
        for (final n in news) ClubCard(title: n.heading, subtitle: n.subtitle, onTap: () => context.push('/news/${n.id}')),
      ],
    );
  }
}
