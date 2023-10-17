import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeNicknameApi {
  static Future<http.Response> patchNickname(String? userId, String nickname, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/user/$userId');
    var a = await http.patch(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'nickname': nickname,
        })
    );
    return a;
  }
}
