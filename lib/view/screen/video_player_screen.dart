import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solution_one/view/screen/playback_screen.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int moduleId;
  const VideoPlayerScreen({Key? key, required this.moduleId}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  List<dynamic> videos = [];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    final response = await http.get(Uri.parse('https://trogon.info/interview/php/api/videos.php?module_id=${widget.moduleId}'));
    if (response.statusCode == 200) {
      setState(() {
        videos = json.decode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load videos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videos')),
      body: videos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return ListTile(
                  title: Text(video['title']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlaybackScreen(videoUrl: video['url']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
