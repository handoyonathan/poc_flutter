import 'package:flutter/material.dart';
import 'package:native_video_player/native_video_player.dart';

class NativeVideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  NativeVideoPlayerWidget({required this.videoPath});

  @override
  _NativeVideoPlayerWidgetState createState() => _NativeVideoPlayerWidgetState();
}

class _NativeVideoPlayerWidgetState extends State<NativeVideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: NativeVideoPlayerView(
        onViewReady: (controller) async {
          try {
            final videoSource = await VideoSource.init(
              path: widget.videoPath,
              type: VideoSourceType.asset,
            );
            await controller.loadVideoSource(videoSource);
          } catch (e) {
            print('Error loading video: $e');
          }
        },
      ),
    );
  }
}
