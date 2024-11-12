import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedEntry extends StatelessWidget {
  final Widget child;
  final int delay;

  const AnimatedEntry({
    super.key,
    required this.child,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(delay: Duration(milliseconds: delay * 100))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }
}
