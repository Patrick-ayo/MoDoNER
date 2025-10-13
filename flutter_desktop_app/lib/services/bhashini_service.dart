import 'dart:convert';
import 'package:http/http.dart' as http;

class BhashiniService {
  final String apiKey;
  final String baseUrl;

  BhashiniService({required this.apiKey, this.baseUrl = 'https://api.bhashini.gov.in'}) ;

  /// Translate a piece of text from [source] to [target].
  /// Returns translated text on success or throws an exception.
  Future<String> translate(String text, {String source = 'en', String target = 'hi'}) async {
    final url = Uri.parse('$baseUrl/translate');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = jsonEncode({
      'source': source,
      'target': target,
      'text': text,
    });

    final resp = await http.post(url, headers: headers, body: body).timeout(const Duration(seconds: 15));

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final data = jsonDecode(resp.body);
      // Expected response shape may vary; adapt as needed.
      if (data is Map && data['translatedText'] != null) {
        return data['translatedText'] as String;
      }
      // fallback: try to find 'translation' key
      if (data is Map && data['translation'] != null) {
        return data['translation'] as String;
      }
      throw Exception('Unexpected response from Bhashini: ${resp.body}');
    } else {
      throw Exception('Bhashini API error ${resp.statusCode}: ${resp.body}');
    }
  }
}
