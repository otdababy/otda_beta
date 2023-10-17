import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class SignNamePage extends StatefulWidget {
  const SignNamePage({Key? key}) : super(key: key);

  @override
  _SignNamePageState createState() => _SignNamePageState();
}

class _SignNamePageState extends State<SignNamePage> {

  final TextEditingController _nameController = TextEditingController();
  String _name = "";

  void didChangeDependencies(){
    if(context.currentBeamLocation.state.data['name'] != null){
      _name = context.currentBeamLocation.state.data['name'];
      _nameController.text = context.currentBeamLocation.state.data['name'];}
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
              context.beamToNamed('/login');
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
                  "이름을 입력해주세요",
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
                          child: TextField(
                            autofocus: true,
                            textInputAction: TextInputAction.search,
                            toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: true,
                                selectAll: true
                            ),
                            controller: _nameController,
                            onChanged: (val) {
                              setState((){
                                _name = _nameController.text;
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
                  "실명을 입력해주세요",
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
                        if(_name.length != 0)
                          context.beamToNamed('/signup_birth', data: {'name' : _name});
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
