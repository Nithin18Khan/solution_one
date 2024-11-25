import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String videoType;

  VideoPlayerWidget({required this.videoUrl, required this.videoType});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  late YoutubePlayerController _youtubeController;
  double _volume = 1.0; // Default volume is 100%
  bool _isMuted = false; // Track mute state

  @override
  void initState() {
    super.initState();
    if (widget.videoType == "YouTube") {
      _youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
        flags: YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    } else if (widget.videoType == "Vimeo") {
      _videoController = VideoPlayerController.network(widget.videoUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoType == "YouTube") {
      return YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        onReady: () {
          print('Player is ready.');
        },
      );
    } else if (widget.videoType == "Vimeo") {
      if (_videoController.value.isInitialized) {
        return Column(
          children: [
            VideoPlayer(_videoController),
            VideoProgressIndicator(_videoController, allowScrubbing: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    _videoController.play();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: () {
                    _videoController.pause();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fast_rewind),
                  onPressed: () {
                    _videoController.seekTo(Duration(seconds: 0));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fast_forward),
                  onPressed: () {
                    _videoController.seekTo(
                        Duration(seconds: _videoController.value.duration.inSeconds - 10));
                  },
                ),
                IconButton(
                  icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                  onPressed: () {
                    if (_isMuted) {
                      _videoController.setVolume(_volume);
                    } else {
                      _videoController.setVolume(0.0); // Mute
                    }
                    setState(() {
                      _isMuted = !_isMuted;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_down),
                  onPressed: () {
                    // Decrease the volume
                    if (_volume > 0.0) {
                      _volume -= 0.1;
                      _videoController.setVolume(_volume);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: () {
                    // Increase the volume
                    if (_volume < 1.0) {
                      _volume += 0.1;
                      _videoController.setVolume(_volume);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    } else {
      return Center(child: Text("Invalid video type"));
    }
  }

  @override
  void dispose() {
    if (widget.videoType == "YouTube") {
      _youtubeController.dispose();
    } else if (widget.videoType == "Vimeo") {
      _videoController.dispose();
    }
    super.dispose();
  }
}
