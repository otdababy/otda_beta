import 'package:http/http.dart' as http;
import 'dart:convert';


class PwPatchApi {
  static Future<http.Response> patchPw(int userId, String newPw) async {
    final url = Uri.parse('https://otdabeta.shop/app/forgot-password');
    var a = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId' : userId,
          'newPassword': newPw,
        })
    );
    return a;
  }
}