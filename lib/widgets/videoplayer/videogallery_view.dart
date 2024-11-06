import 'package:flutter/material.dart';
import 'package:poc_igs/widgets/videoplayer/chewie_widget.dart';
import 'package:poc_igs/widgets/videoplayer/flutter_native_video_widget.dart';
import 'package:poc_igs/widgets/videoplayer/flutter_vlc_player_widget.dart';
import 'package:poc_igs/widgets/videoplayer/videoplayer_widget.dart';


class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const videoUrl = 'assets/video/storyvideo2.mp4';

    return Scaffold(
      appBar: AppBar(title: const Text('Video Players')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Chewie Video Player'),
            ),
           Container(
              height: 300, 
              child: ChewieVideoWidget(videoAsset: videoUrl),
            ),
            const Divider(),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Native Video Player'),
            ),
            Container(
              height: 300, 
              child: NativeVideoWidget(videoUrl: videoUrl),
            ),
            const Divider(),

            
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('VLC Video Player'),
            ),
             Container(
              height: 300, 
              child:VlcVideoWidget(videoUrl: videoUrl),
            ),
            const Divider(),
           
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Basic Video Player'),
            ),
            Container(
              height: 300,
              child:BasicVideoWidget(videoUrl: videoUrl),
            ),
            const Divider(),
            
           ],
        ),
      ),
    );
  }
}
