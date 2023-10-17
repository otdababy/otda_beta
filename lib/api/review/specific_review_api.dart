import 'package:http/http.dart' as http;
import 'dart:convert';


class SpecificReviewGetApi {
  static Future<http.Response> getSpecificReview(int reviewId) async {
    final url = Uri.parse('https://otdabeta.shop/app/review/${reviewId}');
    var a = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}