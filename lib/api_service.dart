import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/manga'; // Use localhost for Android emulator

  static Future<List<Map<String, dynamic>>> fetchMangaList() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load manga');
    }
  }

  static Future<void> addManga(Map<String, dynamic> manga) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(manga),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add manga');
    }
  }

  static Future<void> toggleFavorite(String id) async {
    final response = await http.patch(Uri.parse('$baseUrl/favorite/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to update favorite');
    }
  }

  static Future<void> deleteManga(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete manga');
    }
  }
}
