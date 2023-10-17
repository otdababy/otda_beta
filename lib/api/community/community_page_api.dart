import 'package:http/http.dart' as http;
import 'dart:convert';


class CommunityGetApi {
  static Future<http.Response> getCommunity(int id, int userId, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/board-category?categoryId=$id&userId=$userId');
    var a = await http.get(
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