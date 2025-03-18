import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseService {
  static const String _baseUrl = 'https://your-backend.com/api/courses';

  static Future<List<Course>> searchCourses(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?search=${Uri.encodeQueryComponent(query)}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Course.fromJson(json)).toList();
      }
      throw Exception('Server responded with ${response.statusCode}');
    } catch (e) {
      throw Exception('Failed to search courses: ${e.toString()}');
    }
  }
}
