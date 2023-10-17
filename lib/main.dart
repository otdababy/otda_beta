import 'dart:convert';

import 'package:app_v2/api/login/jwt_verification_api.dart';
import 'package:app_v2/api/login/login/userIdVerification.dart';
import 'package:app_v2/screens/login/login_page.dart';
import 'package:app_v2/utils/user_secure_storage.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/screens/splash_screen.dart';
import 'package:app_v2/router/location.dart';
import 'package:app_v2/screens/home_screen.dart';
import 'package:app_v2/screens/start_screen.dart';
import 'package:app_v2/states/user_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:flarelane_flutter/flarelane_flutter.dart';


import 'dart:ui' as ui;

bool userState = false;

//비머 전역 선언
final _routerDelegate = BeamerDelegate(
    guards: [BeamGuard(
        pathBlueprints: ['/'],
        check: (context, location) {return userState;},
        showPage: BeamPage(child: LoginPage())
    )],
    locationBuilder: BeamerLocationBuilder(
        beamLocations: [HomeLocation(),InputLocation()]
    )
);

//메인함수 빌드
void main() {
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  KakaoSdk.init(nativeAppKey: '51a289cf1e0dbdef9738ee63ec6561c1');
  WidgetsFlutterBinding.ensureInitialized();
  FlareLane.shared.initialize("478de5c5-e220-486b-a5c0-eba1d7ab7ef8");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ShopApp());
  });
}

class ShopApp extends StatefulWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  State<ShopApp> createState() => _ShopAppState();
}


class _ShopAppState extends State<ShopApp> {

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    //read 함수를 통하여 key값에 맞는 정보를 불러오게 됩니다. 이때 불러오는 결과의 타입은 String 타입임을 기억해야 합니다.
    //(데이터가 없을때는 null을 반환을 합니다.)
    String? userId = await UserSecureStorage.getUserId();
    String? jwt = await UserSecureStorage.getJwt();
    String? earlyToken = await UserSecureStorage.getEarly();
    try{
      var id = await UserIdVeriApi.UserIdVerify(userId!);
      final bod = json.decode(id.body.toString());
      if(bod['isSuccess']){
        //user의 정보가 있다면 바로 로그아웃 페이지로 넝어가게 합니다.
        if (jwt != null && earlyToken != null && userId !=null) {
          //jwt 검증 진행
          try{
            var a = await JwtVerifyApi.jwtVerify(jwt, userId);
            final body1 = json.decode(a.body.toString());
            //save userId and jwt
            if(body1['isSuccess']) {
              //검증되었고, 얼리 토큰 verify함
              try{
                var b = await JwtVerifyApi.jwtVerify(earlyToken, userId);
                final body2 = json.decode(a.body.toString());
                //save userId and jwt
                if(body2['isSuccess']) {
                  //earlyToken과 jwt둘다 verify되었고, 로그인되어있음
                  setState(() {
                    userState = true;
                  });
                  //context.beamToNamed('/home');
                }
              }catch(e){
                print(e);
                context.beamToNamed('/login');
              }
            }
          }catch(e){
            print(e);
            context.beamToNamed('/login');
          }
        }
      }
    }catch(e){
      print(e);
      context.beamToNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        errorColor: Colors.white,
        hintColor: Colors.grey[350],
        fontFamily: 'Suits',
        primarySwatch: Colors.grey,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              primary: Colors.white,
              minimumSize: Size(48,48)
          ),
        ),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w800),
          headline2: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w400),
          subtitle1: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.w700),
          subtitle2: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
          button: TextStyle(fontSize: 16,color: Colors.white, fontWeight: FontWeight.w700),
          bodyText1: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w400),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w700),
          elevation: 2,
          actionsIconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black38,
        ),
      ),
      debugShowCheckedModeBanner: false, //에뮬레이터 디버스 표시 삭제
      routeInformationParser: BeamerParser(),
      routerDelegate: _routerDelegate,
    );
  }
}
