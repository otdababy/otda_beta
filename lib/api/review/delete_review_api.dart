import 'package:http/http.dart' as http;
import 'dart:convert';


class DeleteReviewApi {
  static Future<http.Response> deleteReview(String? jwt, String? userId, int reviewId) async {
    final url = Uri.parse('https://otdabeta.shop/app/review-delete/$reviewId?userId=$userId');
    var a = await http.patch(
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