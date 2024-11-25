import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solution_one/model/data/video.model.dart';

class VideoService {
  static const String baseUrl = 'https://trogon.info/interview/php/api/videos.php';

 
  Future<List<Video>> fetchVideosByModuleId(int moduleId) async {
    final response = await http.get(Uri.parse('$baseUrl?module_id=$moduleId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      return data.map((videoData) => Video.fromMap(videoData)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
