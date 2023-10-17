import 'package:http/http.dart' as http;
import 'dart:convert';

class DateChangePatch {
  //final int userId;
/*
  const ShoppingCartPatch({
    //required this.userId
  });
*/
  Map<String, dynamic> toJson() => {
    //'userId' : userId
  };
}

class DateChangePatchApi {
  static Future<http.Response> patchDateChange(int keepId, String? userId, String? jwt, int rentalDuration) async {
    final url = Uri.parse('https://otdabeta.shop/app/shopping-cart');
    var a = await http.patch(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'keepId' : keepId,
          'userId': int.parse(userId!),
          'rentalDuration': rentalDuration
        })
    );
    return a;
  }
}