import 'package:http/http.dart' as http;
import 'dart:convert';



class CheckEmailApi {
  static Future<http.Response> getDouble(String email) async {
    final url = Uri.parse('https://otdabeta.shop/app/double-check?email=$email');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}