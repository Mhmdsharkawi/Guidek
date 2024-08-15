import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> fetchUserInfo(String token) async {
  final response = await http.get(
    Uri.parse('https://your-backend-url/users/current_user_info'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    // Handle the error
    return null;
  }
}
