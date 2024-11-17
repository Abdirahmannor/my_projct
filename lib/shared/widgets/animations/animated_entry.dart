import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedEntry extends StatelessWidget {
  final Widget child;
  final int delay;
  final bool slideIn;
  final bool fadeIn;

  const AnimatedEntry({
    super.key,
    required this.child,
    this.delay = 0,
    this.slideIn = true,
    this.fadeIn = true,
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 100 * delay),
        )
        .slideX(
          begin: 0.1,
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: 100 * delay),
          curve: Curves.easeOutCubic,
        );
  }
}
