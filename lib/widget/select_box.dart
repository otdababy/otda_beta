import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/size_config.dart';

class SelectBox extends StatefulWidget {
  int select;
  final int selectNum;
  final String title;

  SelectBox(this.select, this.selectNum, this.title);

  @override
  SelectBoxState createState() => SelectBoxState();
}

class SelectBoxState extends State<SelectBox> {
  @override
  Widget build(BuildContext context) {
    // Here you direct access using widget
    return select_box();
  }

  GestureDetector select_box() {
    return GestureDetector(
    onTap: ((){
      setState(() {
        if(widget.select == widget.selectNum)
          widget.select = 0;
        else
          widget.select = widget.selectNum;
      });
    }),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffE3E3E3),width: 2),
        color: (widget.select == widget.selectNum) ? Colors.black :Colors.white,
      ),
      width: proWidth(180),
      height: proHeight(60),
      child: Center(
        child: Text(
        widget.title,
          style: TextStyle(
              color: (widget.select == widget.selectNum) ? Colors.white : Colors.black,
              fontSize: proWidth(18)
          ),
        ),
      ),
    ),
  );
  }
}