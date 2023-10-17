import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:app_v2/utils/size_config.dart';

import '../../api/login/forgot_idpw/forgot_id_api.dart';
import '../../api/login/signup/phone_verification_api.dart';


class FoundIdPage extends StatefulWidget {
  const FoundIdPage({Key? key,
  }) : super(key: key);

  @override
  _FoundIdPageState createState() => _FoundIdPageState();
}


class _FoundIdPageState extends State<FoundIdPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text(
              '아이디 찾기',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: proHeight(10)),
            Text(
              '회원님의 아이디입니다',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xff2E2E2E),
              ),
            ),
            SizedBox(height: proHeight(15),),
            Text(
              context.currentBeamLocation.state.data['loginId'],
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black
              ),
            ),
            SizedBox(height: proHeight(300),),
            Center(
              child: Container(
                width: proWidth(340),
                height: proHeight(50),
                child: TextButton(
                    onPressed: () {
                      //로그인 화면으로 이동
                      context.beamToNamed('/login');
                    },
                    child: Text(
                      '로그인 하기',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      backgroundColor: Colors.black,
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}