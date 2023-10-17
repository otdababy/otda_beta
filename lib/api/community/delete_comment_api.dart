import 'package:http/http.dart' as http;
import 'dart:convert';


class DeleteCommentApi {
  static Future<http.Response> deleteComment(String? jwt, String? userId, int id) async {
    final url = Uri.parse('https://otdabeta.shop/app/comment-delete/$id?userId=$userId');
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