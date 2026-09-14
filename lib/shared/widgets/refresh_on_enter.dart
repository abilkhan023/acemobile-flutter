import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshOnEnter extends ConsumerStatefulWidget {
  const RefreshOnEnter({super.key, required this.providers, required this.child});

  final List<Object> providers;
  final Widget child;

  @override
  ConsumerState<RefreshOnEnter> createState() => _RefreshOnEnterState();
}

class _RefreshOnEnterState extends ConsumerState<RefreshOnEnter> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      for (final p in widget.providers) {
        final dynamic provider = p;
        final Object? current = ref.read(provider);
        if (current is AsyncValue && !current.hasValue) continue;
        ref.invalidate(provider);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
