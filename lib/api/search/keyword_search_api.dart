import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchGet {
  final String keyword;

  const SearchGet({
    required this.keyword
  });

  Map<String, dynamic> toJson() => {
    'keyword' : keyword
  };
}

class SearchGetApi {
  static Future<http.Response> getSearch(String keyword) async {
    final url = Uri.parse(
        'https://otdabeta.shop/app/search?keyword="${keyword}"');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}