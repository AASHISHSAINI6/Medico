import 'dart:convert';
import 'package:http/http.dart' as http;

class InfermedicaService {
  static const String _baseUrl = "https://api.infermedica.com/v3";
  static const Map<String, String> _headers = {
    'App-Id': 'YOUR_APP_ID',
    'App-Key': 'YOUR_APP_KEY',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<List<Map<String, dynamic>>> parseSymptoms(String text) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/parse"),
      headers: _headers,
      body: jsonEncode({
        "text": text,
        "include_tokens": true,
        "context": "initial",
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['mentions']);
    } else {
      throw Exception("Infermedica API error: ${response.body}");
    }
  }
}
