import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AceIcon extends StatelessWidget {
  const AceIcon(this.name, {super.key, this.size = 20, this.color, this.quarterTurns = 0});

  final String name;
  final double size;
  final Color? color;
  final int quarterTurns;

  @override
  Widget build(BuildContext context) {
    final c = color ?? IconTheme.of(context).color ?? Colors.white;
    Widget icon = SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
    );
    if (quarterTurns != 0) {
      icon = Transform.rotate(angle: quarterTurns * math.pi / 2, child: icon);
    }
    return SizedBox(width: size, height: size, child: icon);
  }
}

class AceSpinner extends StatefulWidget {
  const AceSpinner({super.key, this.size = 20, this.color, this.icon = 'loader'});

  final double size;
  final Color? color;
  final String icon;

  @override
  State<AceSpinner> createState() => _AceSpinnerState();
}

class _AceSpinnerState extends State<AceSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: AceIcon(widget.icon, size: widget.size, color: widget.color),
    );
  }
}
