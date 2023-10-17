import 'dart:convert';

import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../api/login/signup/phone_verification_api.dart';

class SignVeriPage extends StatefulWidget {
  const SignVeriPage({Key? key}) : super(key: key);

  @override
  _SignVeriPageState createState() => _SignVeriPageState();
}

class _SignVeriPageState extends State<SignVeriPage> {

  final TextEditingController _veriController = TextEditingController();
  String _veri = "";
  String _correctPhoneVeri = '';
  final _formKey = GlobalKey<FormState>();

  void didChangeDependencies(){
    sendPhone(context.currentBeamLocation.state.data['phone']);
  }

  void sendPhone(String num) async {
    try{
      var a= await PhoneVeriApi.postPhoneVeri(num);
      final body = json.decode(a.body.toString());
      final result = body['result'];
      if(body['isSuccess']==true){
        setState(() {
          _correctPhoneVeri = result['code'];
        });
      }
    }catch(e){
      print(e);
      print('실패함 폰인증');
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
          elevation: 0,
          leading: IconButton(
            onPressed: (){
                context.beamToNamed('/signup_phone', data: {'name' : context.currentBeamLocation.state.data['name'],'birth' : context.currentBeamLocation.state.data['birth'],
                  'phone' : context.currentBeamLocation.state.data['phone']});
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
                  "인증번호를 입력해주세요",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: proWidth(25),
                  fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(25),),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: proHeight(55),
                      child: Form(
                        child:  SizedBox(
                          height: proHeight(60),
                          child: TextFormField(
                            validator: (value){
                              if(value!.isEmpty)
                                return "인증번호를 입력해주세요";
                              else if(value != _correctPhoneVeri)
                                return "올바른 인증번호를 입력해주세요";
                            },
                            textInputAction: TextInputAction.search,
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true
                            ),
                            controller: _veriController,
                            onChanged: (val) {
                              setState((){
                                _veri = _veriController.text;
                              });
                            },
                            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: proWidth(18)),
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: proWidth(15)),
                                child: GestureDetector(
                                  onTap: ((){

                                  }),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("재전송",
                                        style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontSize: proWidth(14),
                                            color: Colors.white
                                        ),),
                                    ],
                                  ),
                                ),
                              ),
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
                        if( _formKey.currentState!.validate()) {
                          context.beamToNamed(
                              '/signup_nickname', data: {
                            'name': context.currentBeamLocation.state
                                .data['name'],
                            'birth': context.currentBeamLocation.state
                                .data['birth'],
                            'phone': context.currentBeamLocation.state
                                .data['phone']
                          });
                        }
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
