import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';

class CommentPost {
  final int userId;
  final int boardId;
  final String text;

  const CommentPost({
    required this.userId,
    required this.boardId,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
    'userId':userId,
    'text':text,
    'boardId':boardId,
  };
}


class CommentPostApi {
  static Future<http.Response> postComment(CommentPost commentInfo, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/board-comment');
    var response = await http.post(
        url,
        headers: {
          if(jwt != null)
            'x-access-token' : jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(commentInfo.toJson()));
    return response;
  }
}