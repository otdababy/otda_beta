import 'dart:convert';

import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../api/login/signup/phone_verification_api.dart';

class SignPhonePage extends StatefulWidget {
  const SignPhonePage({Key? key}) : super(key: key);

  @override
  _SignPhonePageState createState() => _SignPhonePageState();
}

class _SignPhonePageState extends State<SignPhonePage> {

  final TextEditingController _phoneController = TextEditingController();
  String _phone = "";
  final _formKey = GlobalKey<FormState>();
  String regexPattern = r'^([0-9]{11}$';


  void didChangeDependencies(){
    if(context.currentBeamLocation.state.data['phone'] != null)
      setState((){
        _phone = context.currentBeamLocation.state.data['phone'];
        _phoneController.text = context.currentBeamLocation.state.data['phone'];
      });
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
              context.beamToNamed('/signup_birth', data: {'name' : context.currentBeamLocation.state.data['name'],'birth' : context.currentBeamLocation.state.data['birth']});
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
                  "휴대폰번호를 입력해주세요",
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
                    child: Form(
                      key: _formKey,
                      child:  SizedBox(
                        //height: proHeight(60),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                              return "번호를 입력해주세요";
                            else if(!RegExp(r'^010?([0-9]{4})?([0-9]{4})$').hasMatch(value))
                                return "올바른 번호를 입력해주세요";
                          },
                          textInputAction: TextInputAction.search,
                          toolbarOptions: const ToolbarOptions(
                              copy: true,
                              cut: true,
                              paste: true,
                              selectAll: true
                          ),
                          controller: _phoneController,
                          onChanged: (val) {
                            setState((){
                              _phone = _phoneController.text;
                            });
                          },
                          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: proWidth(18)),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(5)),
                            hintText: "01012345678",
                            hintStyle: TextStyle(
                                color: Color(0xffBABABA),
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
                              '/signup_veri', data: {
                            'name': context.currentBeamLocation.state
                                .data['name'],
                            'birth': context.currentBeamLocation.state
                                .data['birth'],
                            'phone': _phone
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
