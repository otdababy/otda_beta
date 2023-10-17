import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

import '../../api/login/forgot_idpw/forgot_id_api.dart';
import '../../api/login/forgot_idpw/forgot_pw_api.dart';
import '../../api/login/signup/phone_verification_api.dart';


class ForgotIdPage extends StatefulWidget {
  const ForgotIdPage({Key? key,
  }) : super(key: key);

  @override
  _ForgotIdPageState createState() => _ForgotIdPageState();
}


class _ForgotIdPageState extends State<ForgotIdPage> with TickerProviderStateMixin{

  late TabController _tabController;
  final TextEditingController _idNameController = TextEditingController();
  final TextEditingController _pwIdController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _pwNumberController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _idVeriController = TextEditingController();
  final TextEditingController _pwVeriController = TextEditingController();

  String _idName = '';
  String _pwId = '';
  String _idNumber = '';
  String _pwNumber = '';
  String _id = '';
  String _idVeri = '';
  String _pwVeri = '';
  String _correctVeri = '';
  bool _idVerified = false;
  bool _pwVerified = true;


  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  void popUp(String text) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            title: Padding(
              padding: EdgeInsets.only(top: proHeight(25.0)),
              child: Center(
                child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: proWidth(22),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                width: proWidth(60),
                height: proHeight(30),
                child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(15),),)
                ),
              )
            ],
          );
        }
    );
  }

  void verifyPhone(String num) async {
    print(num);
    if(num==''){
      popUp("번호를 입력해 주세요!");
    }
    else{
      String number = num.replaceAll("-","");
      bool _isPhnNumValid = RegExp(r'^[0-9]{11}$').hasMatch(number);
      //if phonenumber is a number
      if(_isPhnNumValid) {
        try {
          var a = await PhoneVeriApi.postPhoneVeri(number);
          final body = json.decode(a.body.toString());
          print(body);
          final result = body['result'];
          //인증번호 설정함, 나중에 비교하려고
          setState(() {
            _correctVeri = result['code'];
          });
        } catch (e) {
          print(e);
          print('실패함 폰인증');
        }
      }
      else{
        //숫자아니니까 다른거 입력해라
        print("enter a number");
      }
    }
  }

  void verifyId(String veri, String num, String name, String correctVeri) async {
    setState(() {
      _idNameController.text;
      _idNumberController.text;
      _idVeriController.text;
    });

    if(name==""){
      popUp("이메일을 입력해 주세요!");
    }
    else {
      if (_idVerified) {
        try {
          var a = await ForgotIdGetApi.getId(name, num);
          final body = json.decode(a.body.toString());
          print(body);
          final result = body['result'];
          if (body['isSuccess']) {
            //아이디 잘 받아왔고, 아이디 알려주는 화면으로 빔, result['loginId']를 데이터로 보내준다
            context.beamToNamed(
                '/found_id', data: {'loginId': result['loginId']});
          }
        } catch (e) {
          print(e);
          print("실패함 아이디찾기 api");
        }
      }
    }

  }

  void verifyPw(String id, String num, String veri, String correctVeri) async {
    setState(() {
      _pwIdController.text;
      _pwNumberController.text;
      _pwVeriController.text;
    });
    if(id==''){
      popUp("이메일을 입력해주세요!");
    }
    else{
      if(_pwVerified){
        try{
          //비밀번호 찾기 api 호출
          var a= await ForgotPwGetApi.getPw(id, num);
          final body = json.decode(a.body.toString());
          print(body);
          final result = body['result'];
          if(body['isSuccess']){
            //비밀번호 찾았고, 알려줘야한다
            context.beamToNamed('/new_pw',data: {'userId': result['userId']});
          }
        }catch(e){
          print(e);
          print("실패함 아이디찾기 api");
        }
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
          bottom: TabBar(
            tabs: [
              Column(
                children: [
                  SizedBox(
                    height: proHeight(15),
                  ),
                  Center(
                    child: Text(
                      '아이디 찾기',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: proHeight(15),
                  ),
                ],
              ),
              Column(
                children: [

                  SizedBox(
                    height: proHeight(15),
                  ),
                  Center(
                    child: Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: proHeight(15),
                  ),
                ],
              ),
            ],
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            //아이디찾기 화면
            Padding(
              padding: EdgeInsets.symmetric(horizontal: proWidth(50),vertical: proHeight(20)),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: proHeight(50),),
                      Text(
                        '이름',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: proHeight(50),
                              child: TextField(
                                style: TextStyle(fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: '실명',
                                  hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: const BorderSide(width: 1, color: Color(0xff8C8C8C)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: const BorderSide(width: 1, color: Color(0xff4E4E4E)),
                                  ) ,
                                ),
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _idNameController,
                                  onChanged: (val) {
                                    _idName = _idNameController.text;
                                  },
                                ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(10)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '휴대폰번호',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: proHeight(50),
                              child: TextField(
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _idNumberController,
                                  onChanged: (val) {
                                    _idNumber = _idNumberController.text;
                                  },
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '- 없이 작성해주세요',
                                    hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: const BorderSide(width: 1, color: Color(0xff8C8C8C)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: const BorderSide(width: 1, color: Color(0xff4E4E4E)),
                                    ) ,
                                  ),

                                ),
                            ),
                          ),
                          SizedBox(width: proWidth(10),),
                          Container(
                              height: proHeight(40),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: (){
                                  verifyPhone(_idNumber);
                                },
                                child: Center(
                                  child: Text(
                                    '인증번호 전송',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: proHeight(10)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인증번호',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: proHeight(50),
                              child: TextField(
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '전송된 번호를 입력해주세요',
                                    hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: const BorderSide(width: 1, color: Color(0xff8C8C8C)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: const BorderSide(width: 1, color: Color(0xff4E4E4E)),
                                    ) ,
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _idVeriController,
                                  onChanged: (val) {
                                    _idVeri = _idVeriController.text;
                                  },
                                ),
                            ),
                          ),
                          SizedBox(width: proWidth(10),),
                          Container(
                            height: proHeight(40),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: (){
                                if(_correctVeri==_idVeri){
                                  if(_idVeri == ''){
                                    popUp("인증번호를 입력해주세요!");
                                  }
                                  else{
                                    //인증되었다는 팝업 띄움
                                    popUp("인증되었습니다.");
                                    setState((){
                                      _idVerified = true;
                                    });
                                  }
                                }
                                else{
                                  //인증번호 틀림 팝업띄움
                                  popUp("인증번호를 다시 입력해주세요");
                                }
                              },
                              child: Center(
                                child: Text(
                                  '인증번호 확인',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(40)),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: proWidth(300),
                      height: proHeight(50),
                      child: TextButton(
                          onPressed: () {
                            verifyId(_idName,_idNumber,_idVeri,_correctVeri);
                          },
                          child: Text(
                            '인증하기',
                            style: Theme.of(context).textTheme.button,
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
            //비밀번호 찾기 화면
            Padding(
              padding: EdgeInsets.symmetric(vertical: proHeight(20),horizontal: proWidth(50)),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: proHeight(50),),
                      Text(
                        '이메일',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: proHeight(50),
                              child: TextField(
                                style: TextStyle(fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: '이메일을 입력해주세요',
                                  hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: const BorderSide(width: 1, color: Color(0xff8C8C8C)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: const BorderSide(width: 1, color: Color(0xff4E4E4E)),
                                  ) ,
                                ),
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _pwIdController,
                                  onChanged: (val) {
                                    _pwId = _pwIdController.text;
                                  },
                                ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(10)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '휴대폰번호',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: proHeight(50),
                              child: TextField(
                                  inputFormatters: [
                                    MaskedInputFormatter('###########')
                                  ],
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _pwNumberController,
                                  onChanged: (val) {
                                    _pwNumber = _pwNumberController.text;
                                  },
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '- 없이 작성해주세요',
                                    hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: const BorderSide(width: 1, color: Color(0xff8C8C8C)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      borderSide: const BorderSide(width: 1, color: Color(0xff4E4E4E)),
                                    ),
                                  ),
                                ),
                            ),
                          ),
                          SizedBox(width: proWidth(10),),
                          Container(
                              height: proHeight(40),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: (){
                                  verifyPhone(_pwNumber);
                                },
                                child: Center(
                                  child: Text(
                                    '인증번호 전송',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: proHeight(10)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '인증번호',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: proHeight(50),
                              child: TextField(
                                style: TextStyle(fontWeight: FontWeight.w400),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  hintText: '전송된 번호를 입력해주세요',
                                  hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: const BorderSide(width: 1, color: Color(0xff8C8C8C)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    borderSide: const BorderSide(width: 1, color: Color(0xff4E4E4E)),
                                  ),
                                ),
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _pwVeriController,
                                  onChanged: (val) {
                                    _pwVeri = _pwVeriController.text;
                                  },

                                ),
                            ),
                          ),
                          SizedBox(width: proWidth(10),),
                          Container(
                            height: proHeight(40),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: (){
                                if(_correctVeri == _pwVeri){
                                  if(_pwVeri==''){
                                    popUp("인증번호를 입력해주세요!");
                                  }
                                  else{
                                    popUp("인증되었습니다!");
                                    setState((){
                                      _pwVerified = true;
                                    });
                                  }
                                }
                                else
                                  popUp("인증번호를 다시 입력해주세요!");
                              },
                              child: Center(
                                child: Text(
                                  '인증번호 확인',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(40)),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: proWidth(300),
                      height: proHeight(50),
                      child: TextButton(
                          onPressed: () {
                            verifyPw(_pwId,_pwNumber,_pwVeri,_correctVeri);
                          },
                          child: Text(
                            '인증하기',
                            style: Theme.of(context).textTheme.button,
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
          ],
        ),
      ),
    );
  }
}