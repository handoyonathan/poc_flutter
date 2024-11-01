import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';

import 'package:video_player/video_player.dart';
import 'storygesturedetector.dart';
import 'storyindicator.dart';
import 'storyviewmodel.dart';

class StoryView extends StatefulWidget {
  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> with TickerProviderStateMixin {
  late final StoryViewModel _viewModel;
  late List<VideoPlayerController> _videoControllers;

@override
void initState() {
  super.initState();
  _viewModel = StoryViewModel(
    onStoryChanged: (index) => setState(() {}),
    vsync: this,
  );

  _videoControllers = _viewModel.storyUrls.map((url) {
    VideoPlayerController controller;
    if (url.startsWith('http')) {
      controller = VideoPlayerController.network(url);
    } else {
      controller = VideoPlayerController.asset(url);
    }
    
    controller.addListener(() {
      if (controller.value.isInitialized && controller.value.position >= controller.value.duration) {
        _viewModel.onTapRight(); 
      }
    });

    return controller;
  }).toList();
}


  @override
  void dispose() {
    _viewModel.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildStoryContent(int index) {
  String storyUrl = _viewModel.storyUrls[index];
  if (storyUrl.endsWith('.mp4')) {
    return StoryGestureDetector(
      onBack: _viewModel.onTapLeft,
      onNext: _viewModel.onTapRight,
      onPause: _viewModel.pauseAutoPlay,
      onResume: _viewModel.resumeAutoPlay,
      child: Chewie(
        controller: ChewieController(
          videoPlayerController: _videoControllers[_viewModel.storyUrls.indexOf(storyUrl)],
          autoPlay: true,
          looping: false,
          showControls: false, 
        ),
      ),
    );
  } else {
    return Image.asset(
      storyUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryGestureDetector(
        onBack: _viewModel.onTapLeft,
        onNext: _viewModel.onTapRight,
        onPause: _viewModel.pauseAutoPlay,
        onResume: _viewModel.resumeAutoPlay,
        child: Stack(
          children: [
            PageView.builder(
              controller: _viewModel.pageController,
              itemCount: _viewModel.storyUrls.length,
              itemBuilder: (context, index) {
                return _buildStoryContent(index);
              },
              onPageChanged: _viewModel.onPageChanged,
            ),
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: StoryIndicator(
                currentIndex: _viewModel.currentIndex,
                itemCount: _viewModel.storyUrls.length,
                currentProgress: _viewModel.progress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
