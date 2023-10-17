import 'package:app_v2/api/login/login/naver_login_api.dart';
import 'package:app_v2/router/location.dart';
import 'package:app_v2/screens/home/items_page.dart';
import 'package:app_v2/screens/home_screen.dart';
import 'package:app_v2/widget/popup/emailerror.dart';
import 'package:app_v2/widget/popup/pwerror.dart';
import 'package:app_v2/screens/mainpopups/networkerror.dart';
import 'package:app_v2/utils/user_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:app_v2/api/login/login/login_page_api.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import '../../api/login/login/kakao_login_api.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';


class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginBody> {
  String _loginId = '';
  String _password = '';
  bool _shouldAlertError = false;
  bool isPosting = false;

  //controllers
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void handleNaver() async {
    try{
      NaverLoginResult res = await FlutterNaverLogin.logIn();
      final NaverLoginResult result2 = await FlutterNaverLogin.logIn();
      NaverAccessToken resT = await FlutterNaverLogin.currentAccessToken;
      print(resT.accessToken);
      print(" access TOken!!");
      try{
        var a= await NaverLoginApi.postLogin(resT.accessToken);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if(body['isSuccess']) {
          //이미 가입되어 있는지 확인
          if(result[0]['isSignIn']){
            //가입되어있음 -> 로그링 진행함
            try {
              await UserSecureStorage.setUserId(result[0]['userId'].toString());
            } catch(e) {
              print('실패함');
              print(e.toString());
            }
            try {
              await UserSecureStorage.setJwt(result[0]['jwt'].toString());
            } catch(e) {
              print('실패함');
              print(e.toString());
            }
            try {
              await UserSecureStorage.setEarly(result[0]['earlyToken'].toString());
            } catch(e) {
              print('실패함');
              print(e.toString());
            }
            context.beamToNamed('/home');
          }
          else{
            //가입 진행해아햠, 회원가입 페이지로 이메일 데이터 전송
            context.beamToNamed('/signup', data: {'email': result[0]['email']});
          }
        }
      }catch(e){
        print(e);
      }


    }catch(e){
      print(e);
    }
  }

  void handleKakao() async {
    try{
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공 ${token.accessToken}');
      try{
        var a= await KakaoLoginApi.postLogin(token.accessToken);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if(body['isSuccess']) {
          //이미 가입되어 있는지 확인
          if(result[0]['isSignIn']){
            //가입되어있음 -> 로그링 진행함
            try {
              await UserSecureStorage.setUserId(result[0]['userId'].toString());
            } catch(e) {
              print('실패함');
              print(e.toString());
            }
            try {
              await UserSecureStorage.setJwt(result[0]['jwt'].toString());
            } catch(e) {
              print('실패함');
              print(e.toString());
            }
            try {
              await UserSecureStorage.setEarly(result[0]['earlyToken'].toString());
            } catch(e) {
              print('실패함');
              print(e.toString());
            }
            context.beamToNamed('/home');
          }
          else{
            //가입 진행해아햠, 회원가입 페이지로 이메일 데이터 전송
            context.beamToNamed('/signup', data: {'email': result[0]['email']});
          }
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print('카카오계정으로 로그인 실패 $e');
    }
  }


  void handleLogin(String loginId, String password) async {
    setState(() {
      isPosting = true;
      _shouldAlertError = false;
      _loginIdController.text ;
      _passwordController.text ;
    });
    //POST request
    try {
      var a= await LoginApi.postLogin(
          LoginPost(
              loginId: loginId,
              password: password
          )
      );
      final body = json.decode(a.body.toString());
      print(body);
      final result = body['result'];
      //save userId and jwt
      if(body['isSuccess']) {
        print('성공함');
        try {
          await UserSecureStorage.setUserId(result['userId'].toString());
        } catch(e) {
          print('실패함');
          print(e.toString());
        }
        try {
          await UserSecureStorage.setJwt(result['jwt'].toString());
        } catch(e) {
          print('실패함');
          print(e.toString());
        }
        try {
          await UserSecureStorage.setEarly(result['earlyToken'].toString());
        } catch(e) {
          print('실패함');
          print(e.toString());
        }
        context.beamToNamed('/home');
      }
      else{
        //wrong id
        if(body['code'] == 10101){
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return EmailError();
              }
          );
        }
        //wrong pw
        else if(body['code'] == 10102){
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return PwError();
              }
          );
        }
        //database error
        else if(body['code'] == 4000){
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return NetworkError();
              }
          );
        }
      }
      setState(() {
        isPosting = false;
        _loginId = '';
        _password = '';
        _loginIdController.text ='';
        _passwordController.text ='';
      });
      if (!mounted) return;
    }
    catch (e) {
      setState(() {
        isPosting = false;
      });
      print(e);
      final body = json.decode(e.toString());
      print(body);
      final result = body['result'];
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return NetworkError();
          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, proHeight(400), 0,0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      child: Image.asset(
                        'assets/images/wordmark_white.png',
                        height: proHeight(41),
                      ),
                    ),
                  ),
                  Container(height: proHeight(40)),
                  Center(
                    child: Text(
                      '취향을 아는 세컨핸드',
                      style: TextStyle(
                        fontSize: proWidth(23),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(height: proHeight(5)),
                  Center(
                    child: Text(
                      '패션 플랫폼',
                      style: TextStyle(
                          fontSize: proWidth(23),
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: proHeight(38),),
            Column(
              children: [
                Center(
                  child: Container(
                    width: proWidth(380),
                    height: proHeight(55),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        side: BorderSide(width: 1, color: Colors.black),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: (){
                        context.beamToNamed('/signup_name');
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(fontSize: proWidth(18),color: Colors.black, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: proHeight(17)),
                Center(
                  child: Container(
                    width: proWidth(380),
                    height: proHeight(55),
                    child: TextButton(
                        onPressed: (){
                          handleLogin(_loginId, _password);
                        },
                        child: Text(
                          '카카오 로그인',
                          style: TextStyle(fontSize: proWidth(18),color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          backgroundColor: Colors.black,
                        )
                    ),
                  ),
                ),
                SizedBox(height: proHeight(35),),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      context.beamToNamed('/log');
                    },
                    child: Text(
                      '로그인',
                      style: TextStyle(fontFamily: "DoHyeon",fontSize: proWidth(18),color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                SizedBox(height: proHeight(15),),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      context.beamToNamed('/forgot_id');
                    },
                    child: Text(
                      '   아이디 찾기       |     비밀번호 찾기',
                      style: TextStyle(fontSize: proWidth(13),color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                SizedBox(height: proHeight(25),),
                Container(height: proHeight(10),),
              ],
            ),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}