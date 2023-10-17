import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/utils/size_config.dart';
import '../../api/login/forgot_idpw/new_pw_api.dart';


class NewPwPage extends StatefulWidget {
  const NewPwPage({Key? key,
  }) : super(key: key);

  @override
  _NewPwPageState createState() => _NewPwPageState();
}


class _NewPwPageState extends State<NewPwPage> {

  //context.currentBeamLocation.state.data['product']

  String _newPw = '';
  String _newPwConfirm = '';
  final TextEditingController _newPwController = TextEditingController();
  final TextEditingController _newPwConfirmController = TextEditingController();


  void setPw(String pw, String pwC, int userId) async{
    setState(() {
      _newPwController.text;
      _newPwConfirmController.text;
    });
    if(pw == pwC){
      //비밀번호 두개 일치함
      try{
        var a= await PwPatchApi.patchPw(userId, pw);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if(body['isSuccess']){
          //비번바뀐거고 다시 로그인 화면으로 보내면된다
          context.beamToNamed('/login');
        }
      }
      catch(e){
        print(e);
        print('실패함 비번바꾸기');
      }
    }

  }

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
              '비밀번호 재설정',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: proHeight(30)),
            Column(
              children: [
                Row(
                    children: [
                      SizedBox(width: proWidth(100)),
                      Text(
                        '새로운 비밀번호',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                ),
                SizedBox(height: proHeight(5)),
                Padding(
                  padding: EdgeInsets.fromLTRB(proWidth(60), 0, proWidth(60), 0),
                  child: TextField(
                    toolbarOptions: const ToolbarOptions(
                        copy: true,
                        cut: true,
                        paste: true,
                        selectAll: true
                    ),
                    keyboardType: TextInputType.text,
                    controller: _newPwController,
                    onChanged: (val) {
                      _newPw = _newPwController.text;
                    },

                  ),
                ),
                SizedBox(height: proHeight(20)),
              ],
            ),
            Column(
              children: [
                Row(
                    children: [
                      SizedBox(width: proWidth(100)),
                      Text(
                        '새로운 비밀번호',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                ),
                SizedBox(height: proHeight(5)),
                Padding(
                  padding: EdgeInsets.fromLTRB(proWidth(60), 0, proWidth(60), 0),
                  child: TextField(
                    toolbarOptions: const ToolbarOptions(
                        copy: true,
                        cut: true,
                        paste: true,
                        selectAll: true
                    ),
                    keyboardType: TextInputType.text,
                    controller: _newPwConfirmController,
                    onChanged: (val) {
                      _newPwConfirm = _newPwConfirmController.text;
                    },

                  ),
                ),
                SizedBox(height: proHeight(20)),
              ],
            ),
            SizedBox(height: proHeight(300),),
            Center(
              child: Container(
                width: proWidth(340),
                height: proHeight(50),
                child: TextButton(
                    onPressed: () {
                      setPw(_newPw, _newPwConfirm, context.currentBeamLocation.state.data['userId']);
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