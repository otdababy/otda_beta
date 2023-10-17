import 'package:app_v2/api/login/signup/nickname_check_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:app_v2/api/login/signup/signup_page_api.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

import '../../api/login/signup/email_check_api.dart';
import '../../api/login/signup/email_verification_api.dart';
import '../../api/login/signup/num_check_api.dart';
import '../../api/login/signup/phone_verification_api.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  String _nickname = '';
  String _loginId = '';
  String _password = '';
  String _name = '';
  String _phoneNumber = '';
  String _birthDate = '';
  String _correctEmailVeri = '';
  String _correctPhoneVeri = '';
  String _phoneVeri = '';
  String _emailVeri = '';
  String _repassword = '';

  //회원 가입하려면 true여야 하는 state들
  bool _kakao = false;
  bool _emailVerified = false;
  bool _phoneVerified = false;
  bool _emailDuplicate = false;
  bool _phoneDuplicate = false;
  bool _nicknameDuplicate = false;
  //약관 동의 state
  bool _ischecked1 = false;
  bool _ischecked2 = false;
  bool _ischecked3 = false;

  //controllers
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailVeriController = TextEditingController();
  final TextEditingController _phoneVeriController = TextEditingController();


  //webview states
  late WebViewController _controller1;
  late WebViewController _controller2;

  _loadHtmlFromAssets1() async {
    String fileText = await rootBundle.loadString('assets/htmls/privacy.html');
    _controller1.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

  _loadHtmlFromAssets2() async {
    String fileText = await rootBundle.loadString('assets/htmls/use.html');
    _controller2.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }


  bool isInit = true;
  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies(){
    if(isInit) {
      if(context.currentBeamLocation.state.data['email']!= null) {
        setState((){
          _loginIdController.text = context.currentBeamLocation.state.data['email'];
          _kakao = true;
          _emailVerified = true;
          _loginId = _loginIdController.text;
        });
      }
      isInit = false;
    }
  }

  void popUp(String text) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Padding(
              padding: EdgeInsets.only(top: proHeight(25.0)),
              child: Center(
                child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: proWidth(24),
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                width: proWidth(60),
                child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(15)),)
                ),
              )
            ],
          );
        }
    );
  }

  void sendEmail(String email) async {
    if(email == ""){
      popUp("이메일을 입력해주세요!");
    }
    else{
      try{
        var a= await EmailVeriApi.postEmailVeri(email);
        final body = json.decode(a.body.toString());
        final result = body['result'];
        if(body['isSuccess']==true){
          popUp('인증번호가 전송되었습니다!');
        }
        //인증번호 설정함, 나중에 비교하려고
        setState(() {
          _correctEmailVeri = result['code'];
        });
      }catch(e){
        print(e);
        print('실패함 이메일 인증');
      }
    }
  }

  void sendPhone(String num) async {
    if(num == ""){
      popUp("번호를 입력해주세요!");
    }
    else{
      try{
        var a= await PhoneVeriApi.postPhoneVeri(num);
        final body = json.decode(a.body.toString());
        final result = body['result'];
        if(body['isSuccess']==true){
          popUp("인증번호가 전송되었습니다!");
        }
        //인증번호 설정함, 나중에 비교하려고
        setState(() {
          _correctPhoneVeri = result['code'];
        });
      }catch(e){
        print(e);
        print('실패함 폰인증');
      }
    }
  }

  void handleSignUp() async {
    setState(() {
      _nicknameController.text ;
      _loginIdController.text ;
      _passwordController.text ;
      _rePasswordController.text ;
      _nameController.text ;
      _phoneNumberController.text ;
      _birthDateController.text;
      _emailVeriController.text;
      _phoneVeriController.text;
    });
    if(!_phoneVerified || !_emailVerified || !_nicknameDuplicate ||  _name == "" || _birthDate == "" || _password == '' || _password != _repassword){
      if(!_phoneVerified){
        popUp("번호를 인증해주세요!");
      }
      else if(!_emailVerified){
        popUp("이메일을 인증해주세요!");
      }
      else if(!_nicknameDuplicate){
        popUp("닉네임 중복확인을 해주세요!");
      }
      else if(_password == '' || _repassword == ''){
        popUp("비밀번호를 입력해주세요!");
      }
      else if(_name == ''){
        popUp("실명을 입력해주세요!");
      }
      else if(_birthDate == ''){
        popUp("생년월일을 입력해주세요!");
      }
      else if(_password != _repassword){
        popUp("비밀번호가 일치하지 않습니다!");
      }
      print(_phoneVerified);
      print(_emailVerified);
      print(_nicknameDuplicate);
      print(_password);
      print(_repassword);
      print(_name);
      print(_birthDate);
    }
    else{
      if(_phoneVerified && (_emailVerified || _kakao)){
        //인증번호 일치, 회원가입 진행
        try {
          var a= await SignUpApi.postSignUp(
              SignUpPost(
                nickname: _nickname,
                loginId: _loginId,
                password: _password,
                name: _name,
                phoneNumber: _phoneNumber,
                birthDate: _birthDate,
              )
          );
          final body = json.decode(a.body);
          print(body);
          setState(() {
            _nickname = '';
            _loginId = '';
            _password = '';
            _name = '';
            _phoneNumber = '';
            _birthDate = '';
            _repassword = '';
            _nicknameController.text ='';
            _loginIdController.text ='';
            _passwordController.text ='';
            _rePasswordController.text ='';
            _nameController.text ='';
            _phoneNumberController.text ='';
            _birthDateController.text='';
          });
          if (!mounted) return;
          popUp("회원가입이 완료되었습니다!");
          context.beamToNamed('/login');
        } catch (e) {
          print(e);
          popUp("잠시후 다시 시도해주세요");
        }
      }
      else{
        //인증번호 불일치 팝업띄움
        popUp("모든 인증을 진행해주세요");
      }
    }
  }

  void checkNickname(String name) async{
    if(name == ""){
      popUp("닉네임을 입력해주세요!");
    }
    else{
      try{
        var a= await CheckNicknameApi.getDouble(name);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        //중복확인
        if(result[0]['isExistNickName']==true){
          //중복임, 지우고 다시 입력하라는 창 띄워야함 '이미 사용중인 닉네임입니다!'
          popUp("이미 사용중인\n닉네임입니다.");
          setState(() {
            _nicknameController.text;
            _nickname = _nicknameController.text;
          });
        }
        else{
          popUp("사용 가능한 닉네임입니다!");
          setState(() {
            _nickname = name;
            _nicknameDuplicate = true;
          });
        }
      }catch(e){
        print(e);
        print('실패함 폰인증');
      }
    }
  }

  void checkNum(String num) async{
    if(num==""){
      popUp("번호를 입력해주세요!");
    }
    if(RegExp(r'^010([0-9]{4})([0-9]{4})$').hasMatch(num)){
      try{
        var a= await CheckNumApi.getDouble(num);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        //중복확인
        if(result[0]['isExistPhoneNumber']==true){
          //중복임, 지우고 다시 입력하라는 창 띄워야함
          popUp("이미 사용중인 번호입니다");
          setState(() {
            _phoneNumberController.text;
            _phoneNumber = _phoneNumberController.text;
          });
        }
        else{
          setState(() {
            _phoneNumber = num;
            _phoneDuplicate = true;
          });
        }
      }catch(e){
        print(e);
        print('실패함 폰 중복');
      }
    }
    else{
      popUp("올바른 번호를\n입력해주세요!");
    }
  }

  void checkEmail(String email) async{
    if(email == ""){
      popUp("이메일을 입력해주세요!");
    }
    else{
      if(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email))
      {
        try{
          var a= await CheckEmailApi.getDouble(email);
          final body = json.decode(a.body.toString());
          print(body);
          final result = body['result'];
          //중복확인
          if(result[0]['isExistEmail']==true){
            //중복임, 지우고 다시 입력하라는 창 띄워야함
            popUp("이미 사용중인 이메일입니다");
            setState(() {
              _loginIdController.text;
              _loginId = _loginIdController.text;
            });
          }
          else{
            setState(() {
              _loginId = email;
              _emailDuplicate = true;
            });
          }
        }catch(e){
          print(e);
          print('실패함 폰인증');
        }
      }
      else{
        popUp("올바른 이메일을\n입력해주세요!");
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
          leading: IconButton(
            onPressed: (){
              Beamer.of(context).beamBack();
            },
            icon: Icon(Icons.west_outlined),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: proHeight(50),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/logo_black.png',
                        height: proHeight(45),
                      ),
                    ),
                    SizedBox(height: proHeight(20)),
                    Center(
                      child: Text(
                        '감사합니다!',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    SizedBox(height: proHeight(40)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  enabled: !_kakao,
                                    toolbarOptions: const ToolbarOptions(
                                        copy: true,
                                        cut: true,
                                        paste: true,
                                        selectAll: true
                                    ),
                                    keyboardType: TextInputType.text,
                                    controller: _loginIdController,
                                    onChanged: (val) {
                                      _loginId = _loginIdController.text;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'example@otda.com',
                                      hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                      contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: (){
                                  if(_kakao){
                                    null;
                                  }
                                  else{
                                    checkEmail(_loginId);
                                    if(_emailDuplicate)
                                      sendEmail(_loginId);
                                  }
                                },
                                child: Text(
                                  '인증번호 전송',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(5),),
                        Row( //이메일 인증번호
                          children: [
                            Expanded(
                              child: Container(
                                height: proHeight(50),
                                child: TextField(
                                  enabled: !(_kakao),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '인증번호를 입력해주세요',
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
                                  controller: _emailVeriController,
                                  onChanged: (val) {
                                    _emailVeri = _emailVeriController.text;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: proWidth(10),),
                            Container(
                              height: proHeight(40),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () async {
                                  if(_kakao){
                                    _emailVerified = true;
                                    null;
                                  }
                                  else if(_emailVeri == ""){
                                    popUp("인증번호를 입력해주세요!");
                                  }
                                  else{
                                    if(_correctEmailVeri == _emailVeri){
                                      //인증번호 확인되었음 팝업확인
                                      setState((){
                                        _emailVerified  = true;
                                      });
                                      popUp("인증되었습니다!");
                                    }
                                    else{
                                      popUp("다시 입력해 주세요");
                                    }
                                  }
                                },
                                child: Text(
                                  '인증번호 확인',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(20),),
                        Text(
                          '비밀번호',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(height: proHeight(5),),
                        Row(
                          children: [
                            Expanded(
                              child: Form(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Stack(
                                    children:[
                                      TextFormField(
                                      obscureText: true,
                                      validator: (val){
                                        if (val != null && val.length<6){
                                          return '6자 이상 입력해주세요';
                                        }
                                        else if (val != null && val.length>20){
                                          return '20자 이내로 입력해주세요';
                                        }
                                        else{
                                          return null;
                                        }
                                        /*if(value.length>20){
                                          return '20자 이내로 입력해주세요';
                                        }*/
                                      },
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                        hintText: '6자 이상',
                                        hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                        border: OutlineInputBorder(),
                                        errorBorder: OutlineInputBorder(
                                        ),
                                        /*enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: const BorderSide(width: 1, color: Color(0xff8C8C8C)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                          borderSide: const BorderSide(width: 1, color: Color(0xff4E4E4E)),
                                        ) ,*/
                                      ),
                                      toolbarOptions: const ToolbarOptions(
                                          copy: true,
                                          cut: true,
                                          paste: true,
                                          selectAll: true
                                      ),
                                      keyboardType: TextInputType.text,
                                      controller: _passwordController,
                                      onChanged: (val) {
                                        _password = _passwordController.text;
                                      },
                                    ),
                                    ],
                                  ),
                                ),

                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(5),),
                        Form(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '비밀번호 재입력',
                                    hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400,color: Color(0xff8C8C8C)),
                                    border: OutlineInputBorder(),
                                  ),
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _rePasswordController,
                                  onChanged: (val) {
                                    _repassword = _rePasswordController.text;
                                  },
                                  validator: (val){
                                    if(_rePasswordController.text != _passwordController.text){
                                      return '비밀번호가 일치하지 않습니다';
                                    }
                                    else{
                                      return null;
                                    }
                                  },
                                ),
                              ),

                        SizedBox(height: proHeight(20)),
                        Text(
                          '닉네임',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        SizedBox(height: proHeight(5),),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: proHeight(50),
                                child: TextField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '최대 14자',
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
                                  controller: _nicknameController,
                                  onChanged: (val) {
                                    _nickname = _nicknameController.text;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: proWidth(10),),
                            Container(
                              height: proHeight(40),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: (){
                                  checkNickname(_nickname);
                                },
                                child: Text(
                                  '중복 확인',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(20)),
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
                                  controller: _nameController,
                                  onChanged: (val) {
                                    _name = _nameController.text;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(20),),
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
                                  controller: _phoneNumberController,
                                  onChanged: (val) {
                                    _phoneNumber = _phoneNumberController.text;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '- 제외',
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
                                  checkNum(_phoneNumber);
                                  if(_phoneDuplicate)
                                    sendPhone(_phoneNumber);
                                },
                                child: Text(
                                  '인증번호 전송',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(5),),
                        Row( //폰인증번호
                          children: [
                            Expanded(
                              child: Container(
                                height: proHeight(50),
                                child: TextField(
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
                                  toolbarOptions: const ToolbarOptions(
                                      copy: true,
                                      cut: true,
                                      paste: true,
                                      selectAll: true
                                  ),
                                  keyboardType: TextInputType.text,
                                  controller: _phoneVeriController,
                                  onChanged: (val) {
                                    _phoneVeri = _phoneVeriController.text;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: proWidth(10),),
                            Container(
                              height: proHeight(40),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                                  backgroundColor: Colors.black,
                                ),
                                onPressed: () async {
                                  if(_phoneVeri == ""){
                                    popUp("인증번호를 입력해주세요!");
                                  }
                                  else if(_phoneVeri == _correctPhoneVeri){
                                    //인증번호 확인되었음 팝업 띄움
                                    setState((){
                                      _phoneVerified = true;
                                    });
                                    popUp("인증되었습니다!");
                                  }
                                  else{
                                    popUp("다시 입력해주세요");
                                  }
                                },
                                child: Text(
                                  '인증번호 확인',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(20)),
                        Text(
                          '생년월일',
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
                                    MaskedInputFormatter('####-##-##')
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    hintText: '생년월일을 입력해주세요 ex) 20000119',
                                    hintStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xff8C8C8C)),
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
                                  controller: _birthDateController,
                                  onChanged: (val) {
                                    _birthDate = _birthDateController.text;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: proHeight(20)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: StatefulBuilder(
                              builder: (context, _setState) => CheckboxListTile(
                                title: Text("이용약관 동의", style: Theme.of(context).textTheme.subtitle2,),
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.only(left:proWidth(20),),
                                value: _ischecked1,
                                onChanged: (val){
                                  setState(() {
                                    _ischecked1 = val!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: proWidth(30)),
                            child: GestureDetector(
                              onTap: ((){
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context){
                                      return Scaffold(
                                        appBar: AppBar(
                                          leading: IconButton(
                                            onPressed: (){
                                              Beamer.of(context).beamBack();
                                            },
                                            icon: Icon(Icons.west_outlined),
                                          ),
                                        ),
                                        body: WebView(
                                          initialUrl: 'about:blank',
                                          onWebViewCreated: (WebViewController webViewController) {
                                            _controller2 = webViewController;
                                            _loadHtmlFromAssets2();
                                          },
                                        ),
                                      );
                                    });
                              }),
                              child: Text(
                                "자세히 보기",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          Expanded(
                            child: StatefulBuilder(
                              builder: (context, _setState) =>CheckboxListTile(
                                title: Text("개인정보 취급방침 동의", style: Theme.of(context).textTheme.subtitle2,),
                                dense: true,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.only(left:proWidth(20),),
                                value: _ischecked2,
                                onChanged: (val){
                                  setState(() {
                                    _ischecked2 = val!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: proWidth(30)),
                            child: GestureDetector(
                              onTap: ((){
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context){
                                    return Scaffold(
                                      appBar: AppBar(
                                        leading: IconButton(
                                          onPressed: (){
                                            Beamer.of(context).beamBack();
                                          },
                                          icon: Icon(Icons.west_outlined),
                                        ),
                                      ),
                                      body: WebView(
                                        initialUrl: 'about:blank',
                                        onWebViewCreated: (WebViewController webViewController) {
                                          _controller1 = webViewController;
                                          _loadHtmlFromAssets1();
                                        },
                                      ),
                                    );
                                  });
                              }),
                              child: Text(
                                "자세히 보기",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(5),),
                      StatefulBuilder(
                        builder: (context, _setState) =>CheckboxListTile(
                          title: Text("마케팅 정보 수신 동의", style: Theme.of(context).textTheme.subtitle2,),
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.only(left:proWidth(20),),
                          value: _ischecked3,
                          onChanged: (val){
                            setState(() {
                              _ischecked3 = val!;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: proHeight(20),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(20)),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: proWidth(300),
                      height: proHeight(50),
                      child: TextButton(
                          onPressed: () {
                            if(_ischecked1&&_ischecked2&_ischecked3) {
                              handleSignUp();
                            }
                            else{
                              null;
                            }
                          },
                          child: Text(
                            '회원가입',
                            style: Theme.of(context).textTheme.button,
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            backgroundColor: (_ischecked1&&_ischecked2&_ischecked3) ? Colors.black : Colors.grey,
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: proHeight(60)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}