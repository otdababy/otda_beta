import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCartPost {
  final String? userId;
  final int productId;
  final int instanceId;
  final int rentalDuration;

  const AddCartPost({
    required this.userId,
    required this.productId,
    required this.instanceId,
    required this.rentalDuration,
  });

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'productId' : productId,
    'instanceId' : instanceId,
    'rentalDuration' : rentalDuration
  };
}

class AddCartApi {
  static Future<http.Response> postAddCart(AddCartPost rentInfo, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/shopping-cart');
    var a = await http.post(
        url,
        headers: {
          if(jwt != null)
            'x-access-token' : jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(rentInfo.toJson()));
    return a;
  }
}