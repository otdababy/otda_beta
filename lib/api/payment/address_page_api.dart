import 'package:http/http.dart' as http;
import 'dart:convert';


class AddressGetApi {
  static Future<http.Response> getAddress(String? userId, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/address?userId=$userId');
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