import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class SignGenderPage extends StatefulWidget {
  const SignGenderPage({Key? key}) : super(key: key);

  @override
  _SignGenderPageState createState() => _SignGenderPageState();
}

class _SignGenderPageState extends State<SignGenderPage> {

  int _selected = 0;

  void didChangeDependencies(){
    if(context.currentBeamLocation.state.data['gender'] != null){
      _selected = context.currentBeamLocation.state.data['gender'];
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
              context.beamToNamed('/signup_brand', data: {'name' : context.currentBeamLocation.state.data['name'],'birth' : context.currentBeamLocation.state.data['birth'],
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
                  "회원님의 성별을 입력해주세요",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: proWidth(25),
                  fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(30),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: ((){
                      setState(() {
                        if(_selected == 1)
                          _selected = 0;
                        else
                        _selected = 1;
                      });
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff404040)),
                        color: (_selected == 1) ? Color(0xff404040) :Colors.black,
                      ),
                      width: proWidth(160),
                      height: proHeight(60),
                      child: Center(
                        child: Text(
                          "남성",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: proWidth(18)
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: proWidth(16),),
                  GestureDetector(
                    onTap: ((){
                      setState(() {
                        if(_selected == 2)
                          _selected = 0;
                        else
                          _selected = 2;
                      });
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff404040)),
                        color: (_selected == 2) ? Color(0xff404040) :Colors.black,
                      ),
                      width: proWidth(160),
                      height: proHeight(60),
                      child: Center(
                        child: Text(
                          "여성",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: proWidth(18)
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: proHeight(40),),
              Center(
                child: Container(
                  width: proWidth(110),
                  height: proHeight(55),
                  child: TextButton(
                      onPressed: () {
                        if(_selected != 0)
                        context.beamToNamed('/signup_size', data: {'name' : context.currentBeamLocation.state.data['name'], 'birth' : context.currentBeamLocation.state.data['birth'],
                        'phone' : context.currentBeamLocation.state.data['phone'], 'nickname' :  context.currentBeamLocation.state.data['nickname'], 'pw' : context.currentBeamLocation.state.data['pw'],
                        'gender' : _selected});
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
