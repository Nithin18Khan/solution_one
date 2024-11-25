import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/provider/video.provider.dart';
import 'package:solution_one/view/screen/widget/video_player_widget.dart';

class VideoListScreen extends ConsumerWidget {
  final int moduleId;

  VideoListScreen({required this.moduleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the video list using the videoProvider
    final videoAsyncValue = ref.watch(videoProvider(moduleId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
        backgroundColor: Colors.deepPurple,
        elevation: 5.0, // Adding elevation to the app bar for a clean look
      ),
      body: videoAsyncValue.when(
        data: (videos) {
          if (videos.isEmpty) {
            return Center(
              child: FadeTransition(
                opacity: AlwaysStoppedAnimation(1.0),
                child: Text(
                  'No videos found.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            );
          }
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500), // Smooth transition
            child: ListView.builder(
              key: ValueKey<int>(videos.length), // Trigger list item transition
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return _buildVideoTile(context, video);
              },
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: FadeTransition(
            opacity: AlwaysStoppedAnimation(1.0),
            child: Text(
              'Error: $error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoTile(BuildContext context, dynamic video) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300), // Smooth transition for each item
      child: GestureDetector(
        key: ValueKey<int>(video.id), // Unique key for each item to trigger transition
        onTap: () {
          // Navigate to the video player screen with smooth animation
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return FadeTransition(
                  opacity: animation,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(video.title),
                      elevation: 5.0, // Adding elevation to the app bar for a clean look
                    ),
                    body: VideoPlayerWidget(
                      videoUrl: video.videoUrl,
                      videoType: video.videoType,
                    ),
                  ),
                );
              },
            ),
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.video_library, color: Colors.blueAccent),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        video.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
