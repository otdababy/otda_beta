import 'package:http/http.dart' as http;
import 'dart:convert';


class ReceiptGetApi {
  static Future<http.Response> getReceipt(int id, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/receipt?orderId=$id');
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