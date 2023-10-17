import 'package:http/http.dart' as http;
import 'dart:convert';


class NotificationGetApi {
  static Future<http.Response> getNotification(String? jwt, String? id) async {
    final url = Uri.parse('https://otdabeta.shop/app/notice?userId=$id');
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