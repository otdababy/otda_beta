import 'package:app_v2/screens/login/login_body.dart';
import 'package:flutter/material.dart';
import 'login_body.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
        backgroundColor: Color(0xff1B1A1A),
        resizeToAvoidBottomInset: false,
        body: LoginBody(),
      ),
    );
  }
}
