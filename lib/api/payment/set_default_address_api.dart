import 'dart:ui';

import 'package:http/http.dart' as http;
import 'dart:convert';



class SetDefaultAddressApi {
  static Future<http.Response> setDefaultAddress(String? userId, String? jwt, int addressId) async {
    final url = Uri.parse('https://otdabeta.shop/app/address-default');
    var a = await http.patch(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId' : userId,
          'addressId' : addressId,
        })
    );
    return a;
  }
}