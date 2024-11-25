class Module {
  final int id;
  final String name;
  final String description;

  Module({
    required this.id,
    required this.name,
    required this.description,
  });


  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'] ?? 0,  
      name: json['name'] ?? 'Unknown',  
      description: json['description'] ?? 'No description provided',  
    );
  }
}
