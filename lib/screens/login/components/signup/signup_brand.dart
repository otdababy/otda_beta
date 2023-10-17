import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class SignBrandPage extends StatefulWidget {
  const SignBrandPage({Key? key}) : super(key: key);

  @override
  _SignBrandPageState createState() => _SignBrandPageState();
}

class _SignBrandPageState extends State<SignBrandPage> {


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
              context.beamToNamed('/signup_pw', data: {'name' : context.currentBeamLocation.state.data['name'],'birth' : context.currentBeamLocation.state.data['birth'],
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
                  "이제, 좋아하는 브랜드를",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: proWidth(25),
                  fontWeight: FontWeight.w900
                ),
              ),
              Text(
                "선택해보세요",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: proWidth(25),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(20),),
              Text(
                "회원님의 취향을 파악하는데 도움이 됩니다!",
                style: TextStyle(
                    color: Color(0xffA1A1A1),
                    fontSize: proWidth(12),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(25),),
              Center(
                child: Container(
                  width: proWidth(110),
                  height: proHeight(55),
                  child: TextButton(
                      onPressed: () {
                        context.beamToNamed('/signup_gender', data: {'name' : context.currentBeamLocation.state.data['name'], 'birth' : context.currentBeamLocation.state.data['birth'],
                        'phone' : context.currentBeamLocation.state.data['phone'], 'nickname' :  context.currentBeamLocation.state.data['nickname'], 'pw' : context.currentBeamLocation.state.data['pw'],
                        });
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
