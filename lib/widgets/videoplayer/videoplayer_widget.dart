import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BasicVideoWidget extends StatefulWidget {
  final String videoUrl;

  const BasicVideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _BasicVideoWidgetState createState() => _BasicVideoWidgetState();
}

class _BasicVideoWidgetState extends State<BasicVideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying ? _controller.pause() : _controller.play();
                  });
                },
              ),
            ],
          )
        : const CircularProgressIndicator();
  }
}
