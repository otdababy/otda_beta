import 'package:http/http.dart' as http;
import 'dart:convert';



class CheckNumApi {
  static Future<http.Response> getDouble(String num) async {
    final url = Uri.parse('https://otdabeta.shop/app/double-check?phoneNumber=$num');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}