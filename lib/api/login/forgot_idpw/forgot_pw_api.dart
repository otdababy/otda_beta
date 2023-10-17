import 'package:http/http.dart' as http;
import 'dart:convert';



class ForgotPwGetApi {
  static Future<http.Response> getPw(String id, String num) async {
    final url = Uri.parse('https://otdabeta.shop/app/forgot-password?loginId=$id&phoneNumber=$num');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}