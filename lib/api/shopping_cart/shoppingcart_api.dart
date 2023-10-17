import 'package:http/http.dart' as http;
import 'dart:convert';

class ShoppingCartGet {
  final int userId;

  const ShoppingCartGet({
    required this.userId
  });

  Map<String, dynamic> toJson() => {
    'userId' : userId
  };
}

class ShoppingCartGetApi {
  static Future<http.Response> getShoppingCart(String? id,String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/shopping-cart?userId=${int.parse(id!)}');
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