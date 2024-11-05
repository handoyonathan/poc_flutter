import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryViewModel {
  final PageController pageController = PageController();
  int currentIndex = 0;
  Timer? _timer;
  bool isPlaying = true;

  final List<String> storyUrls = [
    'assets/image/story1.png',
    'assets/image/story2.png',
    'assets/video/storyvideo.mp4',
  ];

  final Function(int) onStoryChanged;
  final TickerProvider vsync;
  late AnimationController _progressController;
  late Animation<double> progressAnimation;

  Map<int, VideoPlayerController> _videoControllers = {};

  StoryViewModel({required this.onStoryChanged, required this.vsync}) {
    _progressController = AnimationController(vsync: vsync)
      ..addListener(() {
        onStoryChanged(currentIndex);
      });
    progressAnimation = Tween(begin: 0.0, end: 1.0).animate(_progressController);

    _initializeVideoControllers();
    startAutoPlay();
  }

  double get progress => progressAnimation.value;

  void _initializeVideoControllers() {
    for (int i = 0; i < storyUrls.length; i++) {
      if (isVideo(i)) {
        _videoControllers[i] = VideoPlayerController.asset(storyUrls[i])
          ..initialize().then((_) {
            if (currentIndex == i && isVideo(i)) {
              _progressController.duration = _videoControllers[i]!.value.duration;
              startAutoPlay();
            }
          });
      }
    }
  }

  void startAutoPlay() {
    _timer?.cancel();
    if (isVideo(currentIndex)) {
      final videoController = _videoControllers[currentIndex]!;
      videoController.play();
      _progressController.duration = videoController.value.duration;
    } else {
      _progressController.duration = Duration(seconds: 5);
      _timer = Timer(Duration(seconds: 5), onTapRight);
    }
    _progressController.forward(from: 0.0);
    isPlaying = true;
  }

  void onTapLeft() {
    if (currentIndex > 0) {
      currentIndex--;
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      onStoryChanged(currentIndex);
      _progressController.reset();
      startAutoPlay();
    }
  }

  void onTapRight() {
    if (currentIndex < storyUrls.length - 1) {
      currentIndex++;
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      onStoryChanged(currentIndex);
      _progressController.reset();
      startAutoPlay();
    }
  }

  void pauseAutoPlay() {
    _timer?.cancel();
    _progressController.stop();
    if (isVideo(currentIndex)) {
      _videoControllers[currentIndex]?.pause();
    }
    isPlaying = false;
  }

  void resumeAutoPlay() {
    isPlaying = true;
    if (isVideo(currentIndex)) {
      _videoControllers[currentIndex]?.play();
    } else {
      startAutoPlay();
    }
    _progressController.forward();
  }

  bool isVideo(int index) {
    return storyUrls[index].endsWith('.mp4');
  }

  void onPageChanged(int index) {
    currentIndex = index;
    onStoryChanged(currentIndex);
    _progressController.reset();
    startAutoPlay();
  }

  void dispose() {
    pageController.dispose();
    _timer?.cancel();
    _progressController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
  }
}