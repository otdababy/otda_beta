import 'package:http/http.dart' as http;
import 'dart:convert';

class BorrowingGet {
  final int userId;

  const BorrowingGet({
    required this.userId
  });

  Map<String, dynamic> toJson() => {
    'userId' : userId
  };
}

class BorrowingGetApi {
  static Future<http.Response> getBorrowing(String? id,String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/rental-ing/${id}');
    var a = await http.get(
      url,
      headers: {
        if(jwt != null)
          'x-access-token': jwt,
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return a;
  }
}