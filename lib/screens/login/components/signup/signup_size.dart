import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class SignSizePage extends StatefulWidget {
  const SignSizePage({Key? key}) : super(key: key);

  @override
  _SignSizePageState createState() => _SignSizePageState();
}

class _SignSizePageState extends State<SignSizePage> {

  int _selected = 0;
  final _formKey = GlobalKey<FormState>();

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
              context.beamToNamed('/signup_gender', data: {'name' : context.currentBeamLocation.state.data['name'],'birth' : context.currentBeamLocation.state.data['birth'],
                'phone' : context.currentBeamLocation.state.data['phone'], 'nickname' : context.currentBeamLocation.state.data['nickname'], 'pw' : context.currentBeamLocation.state.data['pw'],
              'gender' : context.currentBeamLocation.state.data['gender']});
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
                  "평소 입으시는 사이즈를",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: proWidth(25),
                  fontWeight: FontWeight.w900
                ),
              ),
              Text(
                "선택해주세요",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: proWidth(25),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(20),),
              Text(
                "중복 선택 가능합니다!",
                style: TextStyle(
                    color: Color(0xffA1A1A1),
                    fontSize: proWidth(12),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(50),),
              Text(
                "상의",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: proWidth(18),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(25),),
              Row(
                children: [
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
                      width: proWidth(70),
                      height: proHeight(70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "XXS",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: proWidth(18)
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              "40",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: proWidth(18)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: proHeight(20),),
              Text(
                "하의",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: proWidth(18),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(20),),
              Text(
                "신발",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: proWidth(18),
                    fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: proHeight(30),),
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
