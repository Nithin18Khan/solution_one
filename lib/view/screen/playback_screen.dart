import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlaybackScreen extends StatelessWidget {
  final String videoUrl;

  const VideoPlaybackScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the video is from YouTube or Vimeo
    bool isYouTube = videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be');
    String videoId = isYouTube ? YoutubePlayer.convertUrlToId(videoUrl)! : '';

    return Scaffold(
      appBar: AppBar(title: const Text('Video Playback')),
      body: Center(
        child: isYouTube
            ? YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: const YoutubePlayerFlags(autoPlay: true),
                ),
              )
            : Text('Vimeo Player not implemented yet!'), // Implement Vimeo if needed
      ),
    );
  }
}
