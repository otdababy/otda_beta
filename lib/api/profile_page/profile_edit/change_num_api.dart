import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeNumApi {
  static Future<http.Response> patchNum(String? userId, String phoneNumber, String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/user/$userId');
    print(phoneNumber);
    print(userId);
    print(jwt);
    var a = await http.patch(
        url,
        headers: {
          if(jwt != null)
            'x-access-token': jwt,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
        })
    );
    return a;
  }
}
