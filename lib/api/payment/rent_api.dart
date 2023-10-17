import 'package:http/http.dart' as http;
import 'dart:convert';

class RentApi {
  static Future<http.Response> postRent(String? userId, String? jwt, int instanceCount, int couponUserid,
      int totalPrice, int deliveryPrice, int payStatus, int payMethod, String requestText, String toUserName,
      String toUserPhone, String destination, String returnAddress, List<int> instanceId, List<int> rentalDuration) async {
    final url = Uri.parse('https://otdabeta.shop/app/rental');
    var a = await http.post(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId' : userId,
          'instanceCount' : instanceCount,
          'couponUserid': couponUserid,
          'requestText' : requestText,
          'toUserName': toUserName,
          'toUserPhone' : toUserPhone,
          'returnAddress' : returnAddress,
          'destination' : destination,
          'instanceId' : instanceId,
          'rentalDuration' : rentalDuration,
          'deliveryPrice' : '0',
          'totalPrice' : totalPrice,
          'payStatus' : '0',
          'payMethod' : '0',
        })
    );
    return a;
  }
}