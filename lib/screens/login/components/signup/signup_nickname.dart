import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class SignNicknamePage extends StatefulWidget {
  const SignNicknamePage({Key? key}) : super(key: key);

  @override
  _SignNicknamePageState createState() => _SignNicknamePageState();
}

class _SignNicknamePageState extends State<SignNicknamePage> {

  final TextEditingController _nicknameController = TextEditingController();
  String _nickname = "";
  final _formKey = GlobalKey<FormState>();

  void didChangeDependencies(){
    if(context.currentBeamLocation.state.data['nickname'] != null)
      setState((){
        _nickname = context.currentBeamLocation.state.data['nickname'];
        _nicknameController.text = context.currentBeamLocation.state.data['nickname'];
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
                  "사용하실 닉네임을 입력해주세요",
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
                              return "닉네임을 입력해주세요";
                            if(value.length < 3)
                              return "4글자 이상 입력해주세요";
                            if(value.length > 14)
                              return "15글자 이하로 입력해주세요";
                          },
                          textInputAction: TextInputAction.search,
                          toolbarOptions: const ToolbarOptions(
                              copy: true,
                              cut: true,
                              paste: true,
                              selectAll: true
                          ),
                          controller: _nicknameController,
                          onChanged: (val) {
                            setState((){
                              _nickname = _nicknameController.text;
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
                                      Text("중복확인",
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
                ],
              ),
              SizedBox(height: proHeight(25),),
              Center(
                child: Container(
                  width: proWidth(110),
                  height: proHeight(55),
                  child: TextButton(
                      onPressed: () {
                        if( _formKey.currentState!.validate())
                          context.beamToNamed('/signup_pw', data: {'name' : context.currentBeamLocation.state.data['name'], 'birth' : context.currentBeamLocation.state.data['birth'],
                          'phone' : context.currentBeamLocation.state.data['phone'],'nickname' : _nickname});
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
