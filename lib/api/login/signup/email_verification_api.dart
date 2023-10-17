import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';


class EmailVeriApi {
  static Future<http.Response> postEmailVeri(String email) async {
    final url = Uri.parse('https://otdabeta.shop/app/email-validation?email=${email}');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}