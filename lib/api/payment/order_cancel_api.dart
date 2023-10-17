import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';



class OrderCancelApi {
  static Future<http.Response> cancelOrder(String? userId, String? jwt, int orderId) async {
    final url = Uri.parse('https://otdabeta.shop/app/rental-cancle');
    var a = await http.patch(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId' : userId,
          'orderId' : orderId,
        })
    );
    return a;
  }
}