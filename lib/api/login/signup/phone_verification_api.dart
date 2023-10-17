import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';


class PhoneVeriApi {
  static Future<http.Response> postPhoneVeri(String phoneNum) async {
    String num = phoneNum.substring(0,3) + '-' + phoneNum.substring(3,7) + '-' + phoneNum.substring(7);
    final url = Uri.parse('https://otdabeta.shop/app/phone-validation?phoneNumber=$num');
    var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );
    return response;
  }
}