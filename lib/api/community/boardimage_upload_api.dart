import 'package:dio/dio.dart';


class BoardImageUploadApi{
  static Future<dynamic> postBoardImage(dynamic input, int boardId, int highCategory) async {
    var dio = new Dio();
    final url = Uri.parse('https://otdabeta.shop/app/image-upload-board?boardId=$boardId&highCategory=$highCategory');
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

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
