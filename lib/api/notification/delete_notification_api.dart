import 'package:http/http.dart' as http;
import 'dart:convert';


class NotificationDeleteApi {
  static Future<http.Response> deleteNotification(String? jwt, String? id, int noticeId) async {
    final url = Uri.parse('https://otdabeta.shop/app/notice-delete?userId=$id&noticeId=$noticeId');
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