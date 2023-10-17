import 'package:http/http.dart' as http;
import 'dart:convert';



class CheckNicknameApi {
  static Future<http.Response> getDouble(String nickname) async {
    final url = Uri.parse('https://otdabeta.shop/app/double-check?nickname=$nickname');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}