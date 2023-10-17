import 'package:http/http.dart' as http;


class UserIdVeriApi {
  static Future<http.Response>UserIdVerify(String userId) async {
    final url = Uri.parse('https://otdabeta.shop/app/is-valid-user?userId=$userId');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}