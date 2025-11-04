import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> extractArticleText(String url) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/extract'), // Replace with your backend IP
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'url': url}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['content'];
  } else {
    print('Error: ${response.body}');
    return null;
  }
}
