import 'package:dio/dio.dart';


class ProfilePicApi{
  static Future<dynamic> postProfileImage(dynamic input, String? userId, String? jwt) async {
    var dio = new Dio();
    final url = Uri.parse('https://otdabeta.shop/app/image-upload-profile?userId=$userId');
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      dio.options.headers = {
        if(jwt != null)
          'x-access-token': jwt,
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var response = await dio.post(
        url.toString(),
        data: input,
      );
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
