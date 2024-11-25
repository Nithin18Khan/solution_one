import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:solution_one/model/data/subject.model.dart';

class SubjectService {
  final String _baseUrl = "https://trogon.info/interview/php/api"; // Base API URL

  Future<List<Subject>> fetchSubjects() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/subjects.php"));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData.map((item) => Subject.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load subjects. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching subjects: $e");
    }
  }
}
