import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductGet {
  final int id;

  const ProductGet({
    required this.id
  });

  Map<String, dynamic> toJson() => {
    'id' : id
  };
}

class ProductGetApi {
  static Future<http.Response> getProduct(int id) async {
    final url = Uri.parse('https://otdabeta.shop/app/product/${id}');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}