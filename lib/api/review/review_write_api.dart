import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';

class ReviewWritePost {
  final int rentalRequestId;
  final double score;
  final String text;

  const ReviewWritePost({
    required this.text,
    required this.rentalRequestId,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
    'score' : score,
    'text' : text,
    'rentalRequestId' : rentalRequestId
  };
}


class ReviewWriteApi {
  static Future<http.Response> postReview(ReviewWritePost reviewInfo, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/review');
    print(reviewInfo);
    var response = await http.post(
        url,
        headers: {
          if(jwt != null)
            'x-access-token' : jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(reviewInfo.toJson()));
    return response;
  }
}