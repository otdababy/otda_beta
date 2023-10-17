import 'package:http/http.dart' as http;
import 'dart:convert';



class ForgotIdGetApi {
  static Future<http.Response> getId(String name, String num) async {
    final url = Uri.parse('https://otdabeta.shop/app/forgot-loginId?phoneNumber=$num&name=$name');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}