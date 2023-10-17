import 'package:http/http.dart' as http;
import 'dart:convert';


class LikeApi {
  static Future<http.Response> like(String? jwt, String? userId, int boardId) async {
    final url = Uri.parse('https://otdabeta.shop/app/like');
    var a = await http.patch(
      url,
      headers: {
        if(jwt != null)
          'x-access-token': jwt,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:  jsonEncode(
        {
          'userId':userId,
          'boardId':boardId
        }
      ));
    return a;
  }
}