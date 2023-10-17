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


class LogBody extends StatefulWidget {
  const LogBody({Key? key}) : super(key: key);

  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<LogBody> {
  String _loginId = '';
  String _password = '';
  //controllers
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void handleLogin(String loginId, String password) async {
    setState(() {
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
        _loginId = '';
        _password = '';
        _loginIdController.text ='';
        _passwordController.text ='';
      });
      if (!mounted) return;
    }
    catch (e) {
      print(e);
      final body = json.decode(e.toString());
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
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: (){
                context.beamToNamed('/login');
              },
              icon: Icon(Icons.west_outlined),
              color: Colors.white,
            ),
            backgroundColor: Color(0xff1B1A1A),
            shape: Border(
                bottom: BorderSide(
                  color: Color(0xff1B1A1A),
                )
            ),
          ),
          backgroundColor: Color(0xff1B1A1A),
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: proWidth(40), vertical: proHeight(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "로그인 정보를 입력해주세요",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: proWidth(25),
                      fontWeight: FontWeight.w900
                  ),
                ),
                SizedBox(height: proHeight(25),),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: proWidth(5)),
                  child: Text(
                    "아이디를 입력해주세요",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: proWidth(12),
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),
                SizedBox(height: proHeight(5),),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: proHeight(55),
                        child: Form(
                          child:  SizedBox(
                            height: proHeight(60),
                            child: TextField(
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              toolbarOptions: const ToolbarOptions(
                                  copy: true,
                                  cut: true,
                                  paste: true,
                                  selectAll: true
                              ),
                              controller: _loginIdController,
                              onChanged: (val) {
                                setState((){
                                  _loginId = _loginIdController.text;
                                });
                              },
                              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: proWidth(18)),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(5)),
                                hintText: "",
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: proWidth(18)
                                ),
                                fillColor: Color(0xff404040),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: proHeight(25),),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: proWidth(5)),
                  child: Text(
                    "비밀번호를 입력해주세요",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: proWidth(12),
                        fontWeight: FontWeight.w900
                    ),
                  ),
                ),
                SizedBox(height: proHeight(5),),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: proHeight(55),
                        child: Form(
                          child:  SizedBox(
                            height: proHeight(60),
                            child: TextField(
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              toolbarOptions: const ToolbarOptions(
                                  copy: true,
                                  cut: true,
                                  paste: true,
                                  selectAll: true
                              ),
                              controller: _passwordController,
                              onChanged: (val) {
                                setState((){
                                  _password = _passwordController.text;
                                });
                              },
                              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: proWidth(18)),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(5)),
                                hintText: "",
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: proWidth(18)
                                ),
                                fillColor: Color(0xff404040),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(90.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: proHeight(25),),
                Center(
                  child: Container(
                    width: proWidth(110),
                    height: proHeight(55),
                    child: TextButton(
                        onPressed: () {
                          handleLogin(_loginId, _password);
                        },
                        child: Text(
                            '다음',
                            style: TextStyle(fontWeight: FontWeight.w900,fontSize: proWidth(18),color: Colors.black)
                        ),
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            backgroundColor: Color(0xffFFFFFF)
                        )
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}