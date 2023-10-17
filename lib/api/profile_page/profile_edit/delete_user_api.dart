import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteUserApi {
  static Future<http.Response> deleteUser(String? userId, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/user-delete/$userId');
    var a = await http.patch(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );
    return a;
  }
}