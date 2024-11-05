import 'package:flutter/material.dart';
import 'package:poc_igs/widgets/videoplayer/videogallery_viewmodel.dart';
import 'package:provider/provider.dart';

class VideoGalleryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoGalleryVM(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Video Gallery'),
        ),
        body: Consumer<VideoGalleryVM>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var videoItem in viewModel.videoWidgets)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          videoItem['title']!, // Display title
                          SizedBox(height: 8.0), // Space between title and video
                          Container(
                            height: 200.0, // Set a specific height for the video widget
                            child: videoItem['widget']!, // Display video widget
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
