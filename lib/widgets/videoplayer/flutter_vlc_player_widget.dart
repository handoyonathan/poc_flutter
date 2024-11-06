import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VlcVideoWidget extends StatefulWidget {
  final String videoUrl;

  const VlcVideoWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VlcVideoWidgetState createState() => _VlcVideoWidgetState();
}

class _VlcVideoWidgetState extends State<VlcVideoWidget> {
  late VlcPlayerController _vlcController;

  @override
  void initState() {
    super.initState();
    _vlcController = VlcPlayerController.asset(
      widget.videoUrl,
      autoPlay: false,
    );
  }

  @override
  void dispose() {
    _vlcController.stop();
    _vlcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VlcPlayer(
          controller: _vlcController,
          aspectRatio: 16 / 9,
          placeholder: const CircularProgressIndicator(),
        ),
        IconButton(
          icon: Icon(
            _vlcController.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            setState(() {
              _vlcController.value.isPlaying ? _vlcController.pause() : _vlcController.play();
            });
          },
        ),
      ],
    );
  }
}
