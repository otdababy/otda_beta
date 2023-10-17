import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';



class UseCouponApi {
  static Future<http.Response> useCoupon(String? userId, String? jwt, int connectionId) async {
    final url = Uri.parse('https://otdabeta.shop/app/address-delete');
    var a = await http.patch(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId' : userId,
          'connectionId' : connectionId,
        })
    );
    return a;
  }
}