import 'package:flutter/material.dart';

class AcePage extends StatelessWidget {
  const AcePage({
    super.key,
    required this.children,
    this.gap = 20,
    this.padding = const EdgeInsets.all(16),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.controller,
    this.fillHeight = false,
    this.onRefresh,
  });

  final List<Widget> children;
  final double gap;
  final EdgeInsets padding;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollController? controller;
  final bool fillHeight;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    final pad = padding.copyWith(bottom: padding.bottom + (bottom > 0 ? bottom : 0));
    final column = Column(crossAxisAlignment: crossAxisAlignment, spacing: gap, children: children);
    if (!fillHeight) {
      final physics = onRefresh == null ? null : const AlwaysScrollableScrollPhysics();
      final scroll = SingleChildScrollView(controller: controller, padding: pad, physics: physics, child: column);
      if (onRefresh == null) return scroll;
      return RefreshIndicator(onRefresh: onRefresh!, color: Theme.of(context).colorScheme.primary, child: scroll);
    }
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        controller: controller,
        padding: pad,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - pad.vertical),
          child: IntrinsicHeight(child: column),
        ),
      ),
    );
  }
}
