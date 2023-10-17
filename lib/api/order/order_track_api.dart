import 'package:http/http.dart' as http;
import 'dart:convert';


class TrackGetApi {
  static Future<http.Response> getTrack(String? userId, String? jwt, int orderId) async {
    final url = Uri.parse('https://otdabeta.shop/app/trackingNumber?userId=$userId&orderId=$orderId');
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