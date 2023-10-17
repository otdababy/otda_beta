import 'package:http/http.dart' as http;
import 'dart:convert';

class ShoppingCartPatch {
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

class ShoppingCartPatchApi {
  static Future<http.Response> patchShoppingCart(int keepId, String? userId, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/shopping-cart?type="delete"}');
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
        })
    );
    return a;
  }
}