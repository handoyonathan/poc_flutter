import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {}); // Refresh UI when the video is initialized
    });

    _controller.addListener(() {
      setState(() {}); // Refresh UI on state change
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              // Video Player Controls
              VideoControls(controller: _controller),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoControls({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            // Play or pause the video when the button is pressed
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () {
            controller.pause();
            controller.seekTo(Duration.zero);
          },
        ),
        IconButton(
          icon: const Icon(Icons.fast_forward),
          onPressed: () {
            // Skip forward
            final currentPosition = controller.value.position;
            controller.seekTo(currentPosition + Duration(seconds: 10));
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            // Skip backward
            final currentPosition = controller.value.position;
            controller.seekTo(currentPosition - Duration(seconds: 10));
          },
        ),
      ],
    );
  }
}
