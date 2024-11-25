class Video {
  final int id;
  final String title;
  final String description;
  final String videoType;
  final String videoUrl;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoType,
    required this.videoUrl,
  });

  // Factory constructor to create a Module from a map (e.g., for decoding JSON)
  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      videoType: map['video_type'],
      videoUrl: map['video_url'],
    );
  }

  // Method to convert a Module to a map (e.g., for encoding JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'video_type': videoType,
      'video_url': videoUrl,
    };
  }
}