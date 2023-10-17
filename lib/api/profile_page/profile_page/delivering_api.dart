import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveringGet {
  final int userId;

  const DeliveringGet({
    required this.userId
  });

  Map<String, dynamic> toJson() => {
    'userId' : userId
  };
}

class DeliveringGetApi {
  static Future<http.Response> getDelivering(String? id,String? jwt) async {
    final url = Uri.parse('https://otdabeta.shop/app/rental-delivery/${id}');
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