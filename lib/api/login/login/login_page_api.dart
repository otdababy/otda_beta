import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';

class LoginPost {
  final String loginId;
  final String password;

  const LoginPost({
    required this.loginId,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'loginId' : loginId,
    'password' : password,
  };
}

class LoginApi {
  static Future<http.Response> postLogin(LoginPost loginInfo) async {
    final url = Uri.parse('https://otdabeta.shop/app/login');
    var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginInfo.toJson()));
    return response;
  }
}