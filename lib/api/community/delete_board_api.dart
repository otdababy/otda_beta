import 'package:http/http.dart' as http;
import 'dart:convert';


class DeleteBoardApi {
  static Future<http.Response> deleteBoard(String? jwt, String? userId, int boardId) async {
    final url = Uri.parse('https://otdabeta.shop/app/board-delete/$boardId?userId=$userId');
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