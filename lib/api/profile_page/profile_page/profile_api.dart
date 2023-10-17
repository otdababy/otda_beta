import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileGetApi {
  static Future<http.Response> getProfile(String? jwt, String? id) async {
    final url = Uri.parse('https://otdabeta.shop/app/user/${id}');
    var a = await http.get(
      url,
      headers: {
        if(jwt != null)
          'x-access-token' : jwt,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}