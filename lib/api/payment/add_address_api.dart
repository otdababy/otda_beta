import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';



class AddressPostApi {
  static Future<http.Response> postAddress(String? userId, String? jwt, String name,
      String address, String phoneNumber, String requestText, int isDef) async {
    final url = Uri.parse('https://otdabeta.shop/app/address');
    String isDefault = isDef.toString();

    var a = await http.post(
      url,
      headers: {
        if(jwt != null)
          'x-access-token': jwt,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'userId' : userId,
        'name' : name,
        'address' : address,
        'phoneNumber' : phoneNumber,
        'requestText' : requestText,
        'isDefault' : '$isDefault',
      })
    );
    return a;
  }
}