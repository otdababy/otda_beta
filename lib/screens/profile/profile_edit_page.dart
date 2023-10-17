import 'dart:convert';

import 'package:app_v2/api/profile_page/profile_edit/change_nickname_api.dart';
import 'package:app_v2/api/profile_page/profile_edit/delete_user_api.dart';
import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';


import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;

import '../../api/profile_page/profile_edit/change_num_api.dart';
import '../../api/profile_page/profile_edit/change_pw_api.dart';
import '../../api/profile_page/profile_edit/edit_pic_api.dart';
import '../../utils/user_secure_storage.dart';


class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  _ProfileEditPageState({Key? key});

  //image picker for user upload
  final ImagePicker _picker = ImagePicker();
  //XFile _image;
  //profile image url
  String profileImageUrl = "";
  final List<dio.MultipartFile> _files = [];

  //이미지 선택 함수
  Future<void> _pickImg() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 5);
    if (image != null){
      setState((){
        profile = CircleAvatar(
          backgroundImage: FileImage(File(image.path)),
          maxRadius: proWidth(75),
        );
      });
      handleImageUpload(image);
    }
  }


  void handleImageUpload(XFile image) async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        var formData = dio.FormData.fromMap({
          'img': await dio.MultipartFile.fromFile(image.path),
        });
        var a = await ProfilePicApi.postProfileImage(formData, userId, jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        print(result);
        //patch 성공
        popUp("프로필 이미지가 변경되었습니다");
        if (body['isSuccess']) {
          //프로필 이미지 업로드 성공
          popUp("프로필 이미지가 변경되었습니다");
        }

      }catch(e){
        print(e);
        print("실패함 이미지업로드");
      }
    }catch(e){
      print(e);
    }
  }

  void deleteUser() async {
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
                child: Text('탈퇴하시겠습니까?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //width: proWidth(60),
                    height: proHeight(40),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          delete();
                        },
                        child: const Text('탈퇴하기', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),)
                    ),
                  ),
                  Container(
                    //width: proWidth(60),
                    height: proHeight(40),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('취소', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),)
                    ),
                  ),
                ],
              )
            ],
          );
        }
    );

  }

  void delete() async{
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 대여중, 배송중, 반납 완료 정보 받아옴
      try {
        var a = await DeleteUserApi.deleteUser(userId, jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        print(result);
        //patch 성공
        if (body['isSuccess']) {
          //탈퇴 성공, 로그인 페이지로 인도
          UserSecureStorage.logout();
          context.beamToNamed('/login');
        }
      }catch(e){
        print(e);
        print("실패함 유저 탈퇴");
      }
    }catch(e){
      print(e);
    }
  }


  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _newPwController = TextEditingController();
  final TextEditingController _currentPwController = TextEditingController();
  String _nickname = "";
  String _number = "";
  String _pw = "";
  String _newPw = "";
  String _currentPw = '';
  bool isInit = true;

  //profile image widget
  Widget profile = Text("");

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies(){
    if(isInit) {
      setState((){
        _nicknameController.text = context.currentBeamLocation.state.data['nickName'];
        _numberController.text = context.currentBeamLocation.state.data['number'];
        profileImageUrl = context.currentBeamLocation.state.data['profileImageUrl'];
        _currentPwController.text;
        profile = CircleAvatar(
          backgroundImage: NetworkImage(profileImageUrl,) ,
          maxRadius: proWidth(75),
        );
        _nickname = _nicknameController.text;
        _number = _numberController.text;
      });
      isInit = false;
    }
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
                      fontSize: proWidth(24),
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(24),),)
                ),
              )
            ],
          );
        }
    );
  }

  void changeNickname(nickname) async{
    if(nickname == _nicknameController.text){
      popUp("새로운 닉네임을\n입력해주세요!");
    }
    if(nickname==''){
      popUp("닉네임을 입력해주세요!");
    }
    else{
      try{
        String? userId = await UserSecureStorage.getUserId();
        String? jwt = await UserSecureStorage.getJwt();
        //받아온 유저 아이디로 대여중, 배송중, 반납 완료 정보 받아옴
        try {
          var a = await ChangeNicknameApi.patchNickname(userId,nickname, jwt);
          final body = json.decode(a.body.toString());
          //result from GET
          final result = body['result'];
          print(result);
          //Get 성공
          if (body['isSuccess']) {
            //변경 성공 마이페이지 다시 조회해서 올림
            popUp("변경되었습니다!");
          }
          else{
            if(body['code'] == 10000){
              popUp("이미 존재하는 닉네임입니다!");
            }
          }
        }catch(e){
          print(e);
          popUp("다시 시도해주세요!");
        }
      }catch(e){
        print(e);
      }
    }
  }

  void changeNumber(number) async{
    if(number == _numberController.text){
      popUp("새로운 번호를\n입력해주세요!");
    }
    if(number==""){
      popUp("번호를 입력해주세요!");
    }
    else{
      try{
        String? userId = await UserSecureStorage.getUserId();
        String? jwt = await UserSecureStorage.getJwt();
        //받아온 유저 아이디로 대여중, 배송중, 반납 완료 정보 받아옴
        try {
          String num = number.replaceAll('-',"");
          var a = await ChangeNumApi.patchNum(userId, num, jwt);
          final body = json.decode(a.body.toString());
          //result from GET
          final result = body['result'];
          print(result);
          //Get 성공
          if (body['isSuccess']) {
            //변경 성공 이 다음엔??
            popUp("변경되었습니다");
          }
          else{
            if(body['code'] == 10009){
              popUp("이미 존재하는 닉네임입니다!");
            }
          }
        }catch(e){
          print(e);
          popUp("다시 시도해주세요");
        }
      }catch(e){
        print(e);
      }
    }
  }

  void changePw(String newPw, String currentPw) async{
    print("비번바꾸는중임");
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 대여중, 배송중, 반납 완료 정보 받아옴
      try {
        var a = await ChangePwApi.patchPw(userId, currentPw, newPw, jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        print(result);
        //Get 성공
        if (body['isSuccess']) {
          //변경 성공 이 다음엔??
          popUp("비밀번호가 변경되었습니다!");
        }
        else{
          if(body['code']){
            popUp("현재 비밀번호가 틀렸습니다!");
          }
          else{
            popUp("다시 시도해주세요!");
          }
        }
      }catch(e){
        print(e);
        print("실패함 번호 변경");
      }
    }catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('프로필 관리'),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                context.beamToNamed('/home', data: {'index' : 3});
              },
                icon: Icon(Icons.west_outlined),
              ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.all(proWidth(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: proHeight(15),),
                  Center(
                    child: Stack(
                      children: [
                        profile,
                        Positioned(
                          left: proWidth(100),
                            top: proWidth(100),
                            child: CircleAvatar(
                              maxRadius: proWidth(30),
                              backgroundColor: Colors.white,
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt_rounded,
                                    color: Colors.black,
                                    size: proWidth(40),),
                                  onPressed: (){
                                    setState(() {
                                      _pickImg();
                                    });
                                  },
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: proHeight(25),),
                  Text(
                    '프로필 정보',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: proHeight(30),),
                  Text(
                    '닉네임',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: proHeight(7),),
                  //닉네임 변경 칸
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: proHeight(50),
                          width: proWidth(390),
                          child: TextField(
                            style: TextStyle(fontWeight: FontWeight.w400),
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
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
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
                            //닉네임 변경 함수 호출
                            changeNickname(_nickname);
                          },
                          child: Text(
                            '변경',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(25),),
                  Text(
                    '전화번호',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: proHeight(7),),
                  //번호 변경 칸 (원래 번호뜨고)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: proHeight(50),
                          child: TextField(
                            style: TextStyle(fontWeight: FontWeight.w400),
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true
                            ),
                            keyboardType: TextInputType.text,
                            controller: _numberController,
                            onChanged: (val) {
                              _number = _numberController.text;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
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
                            //번호 변경 함수 호출
                            changeNumber(_number);
                          },
                          child: Text(
                            '변경',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(25),),
                  Text(
                    '현재 비밀번호',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: proHeight(7),),
                  //번호 변경 칸 (원래 번호뜨고)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: proHeight(50),
                          child: TextField(
                            style: TextStyle(fontWeight: FontWeight.w400),
                            obscureText: true,
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true
                            ),
                            keyboardType: TextInputType.text,
                            controller: _currentPwController,
                            onChanged: (val) {
                              _currentPw = _currentPwController.text;
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ) ,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(25),),
                  Text(
                    '새 비밀번호',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: proHeight(7),),
                  //비번 변경 칸
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Container(
                      height: proHeight(50),
                      child: TextFormField(
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
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                          hintText: '영문, 숫자 조합 6-20자',
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
                        controller: _pwController,
                        onChanged: (val) {
                          _pw = _pwController.text;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: proHeight(20),),
                  Text(
                    '새 비밀번호 확인',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12
                    ),
                  ),
                  SizedBox(height: proHeight(7),),
                  //비번 변경 칸
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: proHeight(50),
                          child: Form(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              obscureText: true,
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
                              validator: (val){
                                if(_newPwController.text != _pwController.text){
                                  return '비밀번호가 일치하지 않습니다';
                                }
                                else{
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
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
                      ),
                      SizedBox(width: proWidth(10),),
                      Container(
                        height: proHeight(40),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            backgroundColor: Colors.black,
                          ),
                          onPressed: (){
                            //비번 변경 함수 호출
                            changePw(_newPw,_currentPw,);
                          },
                          child: Text(
                            '변경',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(50),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: proWidth(120),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            ),
                            onPressed: (){
                              deleteUser();
                            },
                            child: Text(
                              '탈퇴하기',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),
                            )
                        ),
                      ),
                      Container(
                        width: proWidth(120),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            ),
                            onPressed: () async {
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
                                      child: Text('로그아웃하시겠습니까?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: proWidth(24),
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          //width: proWidth(60),
                                          height: proHeight(40),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                backgroundColor: Colors.black,
                                              ),
                                              onPressed: () {
                                                UserSecureStorage.logout();
                                                context.beamToNamed('/login');
                                              },
                                              child: Text('로그아웃', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(16),),)
                                          ),
                                        ),
                                        Container(
                                          //width: proWidth(60),
                                          height: proHeight(40),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                backgroundColor: Colors.black,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('취소', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(16),)
                                          ),
                                        )
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }
                              );
                            },
                            child: Text(
                              '로그아웃',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
