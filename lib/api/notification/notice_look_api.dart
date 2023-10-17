import 'package:http/http.dart' as http;
import 'dart:convert';


class NotificationLookApi {
  static Future<http.Response> lookNotification(String? jwt, String? id) async {
    final url = Uri.parse('https://otdabeta.shop/app/notice-look?userId=$id');
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