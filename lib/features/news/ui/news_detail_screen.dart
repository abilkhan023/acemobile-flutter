import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/env.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../data/news_api.dart';

const _newsBanner = 'https://hyperpc.ru/images/project/gaming-club/hyperpc-gaming-club-banner.jpg';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.id});

  final String id;

  Future<void> _share(BuildContext context) async {
    final l = context.l10n;
    try {
      await SharePlus.instance.share(ShareParams(
        text: '${l.shareNewsText} https://${Env.deepLinkHost}/news/$id',
        subject: l.shareTitle,
        title: l.shareTitle,
      ));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsItemProvider(id)).value;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(imageUrl: _newsBanner, height: 250, width: double.infinity, fit: BoxFit.cover, errorWidget: (_, _, _) => const SizedBox(height: 250)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(news?.title ?? news?.name ?? '', style: AceText.style(size: 18))),
                    GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _share(context), child: const AceIcon('arrow-up-from-bracket', size: 24)),
                  ],
                ),
                const SizedBox(height: 0),
                Text(news?.content ?? '', style: AceText.style(size: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
