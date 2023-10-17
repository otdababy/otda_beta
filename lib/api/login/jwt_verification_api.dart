import 'package:http/http.dart' as http;
import 'dart:convert';


class JwtVerifyApi {
  static Future<http.Response> jwtVerify(String jwt, String userId) async {
    final url = Uri.parse('https://otdabeta.shop/app/jwt-validation?userId=$userId');
    var response = await http.get(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },);
    return response;
  }
}