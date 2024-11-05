import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/material.dart';

class VlcPlayerWidget extends StatefulWidget {
  final String videoUrl; // Tambahkan parameter videoUrl

  VlcPlayerWidget({required this.videoUrl}); // Constructor dengan videoUrl

  @override
  _VlcPlayerWidgetState createState() => _VlcPlayerWidgetState();
}

class _VlcPlayerWidgetState extends State<VlcPlayerWidget> {
  late VlcPlayerController _vlcController;

  @override
  void initState() {
    super.initState();
    _vlcController = VlcPlayerController.asset(
      widget.videoUrl, // Gunakan videoUrl dari widget
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _vlcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VlcPlayer(
      controller: _vlcController,
      aspectRatio: 16 / 9,
      placeholder: Center(child: CircularProgressIndicator()),
    );
  }
}
