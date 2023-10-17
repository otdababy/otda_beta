import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class SignBirthPage extends StatefulWidget {
  const SignBirthPage({Key? key}) : super(key: key);

  @override
  _SignBirthPageState createState() => _SignBirthPageState();
}

class _SignBirthPageState extends State<SignBirthPage> {

  final TextEditingController _birthController = TextEditingController();
  String _birth = "";
  int _valid = 0;
  final _formKey = GlobalKey<FormState>();

  void didChangeDependencies(){
    if(context.currentBeamLocation.state.data['birth'] != null){
        _birth = context.currentBeamLocation.state.data['birth'];
        _birthController.text = context.currentBeamLocation.state.data['birth'];}
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
              context.beamToNamed('/signup_name', data: {'name' : context.currentBeamLocation.state.data['name']});
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
                  "생년월일을 입력해주세요",
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
                        //height: proHeight(55),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty)
                              return "생년월일을 입력해주세요";
                            else if(value.length != 6)
                              return "6자리로 입력패주세요";
                          },
                          textInputAction: TextInputAction.search,
                          toolbarOptions: const ToolbarOptions(
                              copy: true,
                              cut: true,
                              paste: true,
                              selectAll: true
                          ),
                          controller: _birthController,
                          onChanged: (val) {
                            _birth = _birthController.text;
                          },
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: proWidth(18),color: Colors.white),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(5)),
                            hintText: "예시: 000119",
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
                        if( _formKey.currentState!.validate())
                          context.beamToNamed('/signup_phone',data: {'name' : context.currentBeamLocation.state.data['name'], 'birth' : _birth});
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
