import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/ace_icon.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  static const _stories = ['assets/images/ace.png', 'assets/images/ace.png'];
  final int _active = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: Image.asset(_stories[_active])),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Row(
            spacing: 3,
            children: [
              for (var i = 0; i < _stories.length; i++)
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(border: Border.all(color: const Color(0x80FFFFFF), width: 2), borderRadius: BorderRadius.circular(6)),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          top: 25,
          right: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => context.canPop() ? context.pop() : context.go('/'),
            child: const Padding(padding: EdgeInsets.all(8), child: AceIcon('xmark')),
          ),
        ),
      ],
    );
  }
}
