import 'package:http/http.dart' as http;
import 'dart:convert';

class WriteArticlePost {
  final String? userId;
  final String text;
  final String title;
  final int categoryId;

  const WriteArticlePost({
    required this.userId,
    required this.text,
    required this.title,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'text': text,
    'title' : title,
    'categoryId' : categoryId
  };
}

class WriteArticleApi {
  static Future<http.Response> postArticle(WriteArticlePost articleInfo, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/board');
    var a = await http.post(
        url,
        headers: {
          if(jwt != null)
            'x-access-token' : jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(articleInfo.toJson()));
    return a;
  }
}