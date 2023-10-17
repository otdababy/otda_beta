import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../widget/select_box.dart';




class SellPage extends StatefulWidget {
  const SellPage({Key? key}) : super(key: key);

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  int _gender = 0;
  int _category = 0;
  int _topCategory = 0;
  bool _visible = false;
  bool _visible2 = false;

  void didChangeDependencies(){
    if(context.currentBeamLocation.state.data['birth'] != null){

    }
  }

  GestureDetector select_box(select, selectNum, title) {
    return GestureDetector(
      onTap: ((){
        setState(() {
          if(_gender == selectNum) {
            _gender = 0;
            _visible = false;
            _category = 0;
          }
          else{
            _gender = selectNum;
            if(_gender == 0){
              _visible = false;
            }
            else
              _visible = true;
          }

        });
        //categories loading
      }),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffE3E3E3),width: 2),
          color: (_gender == selectNum) ? Colors.black :Colors.white,
        ),
        width: proWidth(180),
        height: proHeight(60),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: (_gender == selectNum) ? Colors.white : Colors.black,
                fontSize: proWidth(18)
            ),
          ),
        ),
      ),
    );
  }
  GestureDetector select_box2(select, selectNum, title) {
    return GestureDetector(
      onTap: ((){
        setState(() {
          if(_category == selectNum)
            _category = 0;
          else {
            _category = selectNum;
          }
        });
        //categories loading
      }),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffE3E3E3),width: 2),
          color: (_category == selectNum) ? Colors.black :Colors.white,
        ),
        width: proWidth(180),
        height: proHeight(60),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: (_category == selectNum) ? Colors.white : Colors.black,
                fontSize: proWidth(18)
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector select_box3(select, selectNum, title) {
    return GestureDetector(
      onTap: ((){
        setState(() {
          if(_topCategory == selectNum)
            _topCategory = 0;
          else {
            _topCategory = selectNum;
          }
        });
        //categories loading
      }),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffE3E3E3),width: 2),
          color: (_topCategory == selectNum) ? Colors.black :Colors.white,
        ),
        width: proWidth(180),
        height: proHeight(60),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: (_topCategory == selectNum) ? Colors.white : Colors.black,
                fontSize: proWidth(18)
            ),
          ),
        ),
      ),
    );
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
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            shape: Border(
                bottom: BorderSide(
                  color: Colors.black,
                )
            ),
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: proWidth(25), vertical: proHeight(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "성별",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: proWidth(23),
                      fontWeight: FontWeight.w900
                  ),
                ),
                SizedBox(height: proHeight(25),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    select_box(_gender,1,'남성'),
                    SizedBox(width: proWidth(10),),
                    select_box(_gender,2,'여성'),
                  ],
                ),
                SizedBox(height: proHeight(25),),
                AnimatedOpacity(
                  opacity: _visible2 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "카테고리",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: proWidth(23),
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: proHeight(25),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          select_box2(_category,1,'상의'),
                          SizedBox(width: proWidth(10),),
                          select_box2(_category,2,'하의'),
                        ],
                      ),
                      SizedBox(height: proHeight(10),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          select_box2(_category,3,'아우터'),
                          SizedBox(width: proWidth(10),),
                          select_box2(_category,4,'신발'),
                        ],
                      ),
                      SizedBox(height: proHeight(10),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          select_box2(_category,5,'아우터'),
                          SizedBox(width: proWidth(10),),
                          select_box2(_category,6,'악세사리'),
                        ],
                      ),
                      SizedBox(height: proHeight(25),),
                    ],
                  ),
                ),
                SizedBox(height: proHeight(25),),
                AnimatedOpacity(
                  opacity: _visible2 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "세부 카테고리",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: proWidth(23),
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: proHeight(25),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          select_box3(_topCategory,1,'상의'),
                          SizedBox(width: proWidth(10),),
                          select_box3(_topCategory,2,'하의'),
                        ],
                      ),
                      SizedBox(height: proHeight(10),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          select_box3(_topCategory,3,'아우터'),
                          SizedBox(width: proWidth(10),),
                          select_box3(_topCategory,4,'신발'),
                        ],
                      ),
                      SizedBox(height: proHeight(10),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          select_box3(_topCategory,5,'아우터'),
                          SizedBox(width: proWidth(10),),
                          select_box3(_topCategory,6,'악세사리'),
                        ],
                      ),
                      SizedBox(height: proHeight(25),),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
