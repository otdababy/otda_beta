import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryProductGet {
  final int categoryId;

  const CategoryProductGet({
    required this.categoryId
  });

  Map<String, dynamic> toJson() => {
    'categoryId' : categoryId
  };
}

class CategoryProductGetApi {
  static Future<http.Response> getCategoryProduct(int id) async {
    final url = Uri.parse('https://otdabeta.shop/app/product-category?categoryId=${id}');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}