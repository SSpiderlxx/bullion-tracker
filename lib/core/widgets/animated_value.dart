import 'package:flutter/material.dart';

class AnimatedValue extends StatelessWidget {
  final double value;
  final String Function(double) format;
  final TextStyle? style;
  final Duration duration;

  const AnimatedValue({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: value, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, val, child) {
        return Text(
          format(val),
          style: style,
        );
      },
    );
  }
}
