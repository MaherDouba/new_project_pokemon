import 'package:flutter/material.dart';

class SlideAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset begin;
  final Offset end;

  const SlideAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.begin = const Offset(0, 1),
    this.end = Offset.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }
}
