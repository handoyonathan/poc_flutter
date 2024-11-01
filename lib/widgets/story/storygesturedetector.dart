import 'package:flutter/material.dart';

class StoryGestureDetector extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final Widget child;

  StoryGestureDetector({
    required this.onBack,
    required this.onNext,
    required this.onPause,
    required this.onResume,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final screenWidth = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx < screenWidth / 2) {
          onBack();
        } else {
          onNext();
        }
      },
      onLongPress: onPause,
      onLongPressEnd: (_) => onResume(),
      onTapUp: (_) => onResume(),
      child: child,
    );
  }
}
