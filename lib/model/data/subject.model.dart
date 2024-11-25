// Subject Data Class
class Subject {
  final int id;
  final String title;
  final String description;
  final String image;

  Subject({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  // Factory constructor to parse from JSON
  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
