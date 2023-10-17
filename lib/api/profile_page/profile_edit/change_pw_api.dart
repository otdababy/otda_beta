import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePwApi {
  static Future<http.Response> patchPw(String? userId, String password, String newPassword, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/user-password');
    var a = await http.patch(
      url,
      headers: {
        if(jwt != null)
          'x-access-token': jwt,
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode({
          'userId' : userId,
          'password': password,
          'newPassword': newPassword
        })
    );
    return a;
  }
}
