import 'package:http/http.dart' as http;
import 'dart:convert';



class NaverLoginApi {
  static Future<http.Response> postLogin(String token) async {
    final url = Uri.parse('https://otdabeta.shop/app/naver-login');
    var a = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode({
          'token': token
        })
    );
    return a;
  }
}