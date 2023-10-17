import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class SignPwPage extends StatefulWidget {
  const SignPwPage({Key? key}) : super(key: key);

  @override
  _SignPwPageState createState() => _SignPwPageState();
}

class _SignPwPageState extends State<SignPwPage> {

  final TextEditingController _pwController = TextEditingController();
  String _pw = "";

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
              context.beamToNamed('/signup_nickname', data: {'name' : context.currentBeamLocation.state.data['name'],'birth' : context.currentBeamLocation.state.data['birth'],
                'phone' : context.currentBeamLocation.state.data['phone'], 'nickname' : context.currentBeamLocation.state.data['nickname']});
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
                  "사용하실 비밀번호를 입력해주세요",
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
                      //height: proHeight(55),
                      child: Form(
                        child:  SizedBox(
                          //height: proHeight(60),
                          child: TextFormField(
                            textInputAction: TextInputAction.search,
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true
                            ),
                            controller: _pwController,
                            onChanged: (val) {
                              setState((){
                                _pw = _pwController.text;
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
              SizedBox(height: proHeight(5),),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: proWidth(5)),
                child: Text(
                  "최소 8글자를 입력해주세요",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: proWidth(12),
                      fontWeight: FontWeight.w900
                  ),
                ),
              ),
              SizedBox(height: proHeight(25),),
              Center(
                child: Container(
                  width: proWidth(110),
                  height: proHeight(55),
                  child: TextButton(
                      onPressed: () {
                        if(_pw.length >= 8)
                          context.beamToNamed('/signup_brand', data: {'name' : context.currentBeamLocation.state.data['name'], 'birth' : context.currentBeamLocation.state.data['birth'],
                        'phone' : context.currentBeamLocation.state.data['phone'], 'nickname' :  context.currentBeamLocation.state.data['nickname'], 'pw' : _pw});
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
