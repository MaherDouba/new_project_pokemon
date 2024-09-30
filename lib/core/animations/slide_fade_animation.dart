import 'package:flutter/material.dart';

class SlideFadeAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset begin;
  final Offset end;

  const SlideFadeAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.begin = const Offset(0, 0.1),
    this.end = Offset.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: TweenAnimationBuilder<Offset>(
            tween: Tween(begin: begin, end: end),
            duration: duration,
            child: child,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: offset,
                child: child,
              );
            },
          ),
        );
      },
      child: child,
    );
  }
}
