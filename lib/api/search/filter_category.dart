import 'package:http/http.dart' as http;
import 'dart:convert';


class CategoryGetApi {
  static Future<http.Response> getCategory() async {
    final url = Uri.parse(
        'https://otdabeta.shop/app/category');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}