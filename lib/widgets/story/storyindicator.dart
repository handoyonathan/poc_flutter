import 'package:flutter/material.dart';

class StoryIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final double currentProgress;

  StoryIndicator({
    required this.currentIndex,
    required this.itemCount,
    required this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        itemCount,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: LinearProgressIndicator(
              value: index == currentIndex
                  ? currentProgress
                  : (index < currentIndex ? 1.0 : 0.0),
              backgroundColor: Colors.grey.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
