import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_one/model/data/video.model.dart';
import 'package:solution_one/model/logic/video.service.dart';

final videoProvider = FutureProvider.family<List<Video>, int>((ref, moduleId) async {
  final videoService = VideoService(); // Create an instance of the VideoService
  return await videoService.fetchVideosByModuleId(moduleId); // Fetch videos by moduleId
});
