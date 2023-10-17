import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpPost {
  final String nickname;
  final String loginId;
  final String password;
  final String name;
  final String phoneNumber;
  final String birthDate;

  const SignUpPost({
    required this.nickname,
    required this.loginId,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.birthDate,
  });

  Map<String, dynamic> toJson() => {
    'nickname' : nickname,
    'loginId' : loginId,
    'password' : password,
    'name' : name,
    'phoneNumber': phoneNumber,
    'birthDate' : birthDate
  };
}

class SignUpApi {
   static Future<http.Response> postSignUp(SignUpPost signupInfo) async {
    final url = Uri.parse('https://otdabeta.shop/app/user');
    var a = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(signupInfo.toJson()));
    return a;
  }
}