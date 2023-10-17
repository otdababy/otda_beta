import 'package:dio/dio.dart';


class ImageUploadApi{
  static Future<dynamic> postReviewImage(dynamic input, int reviewId, int highCategory) async {
    var dio = new Dio();
    final url = Uri.parse('https://otdabeta.shop/app/image-upload-review?reviewId=$reviewId&highCategory=$highCategory');
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      dio.options.headers = {
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
