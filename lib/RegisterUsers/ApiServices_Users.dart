import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://back-mascotas.vercel.app/bmpr/users'; // Cambié la URL base

  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<void> addUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add user');
    }
  }
}
