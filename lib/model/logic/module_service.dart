import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:solution_one/model/data/module.dart';

class ModuleService {
  // Base URL without the query parameter
  static const String baseUrl = 'https://trogon.info/interview/php/api/modules.php';

  Future<List<Module>> fetchModules(int subjectId) async {
    // Correct URL construction with query parameter
    final response = await http.get(Uri.parse('$baseUrl?subject_id=$subjectId'));

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Module.fromJson(json)).toList();
    } else {
      // If the request fails, print an error and return an empty list
      print('Failed with status code: ${response.statusCode}');
      return [];  // Return an empty list in case of failure
    }
  }
}
