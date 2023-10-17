import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingCollapsed extends StatefulWidget {
  const SlidingCollapsed({Key? key}) : super(key: key);

  @override
  _SlidingCollapsedState createState() => _SlidingCollapsedState();
}

class _SlidingCollapsedState extends State<SlidingCollapsed> {
  List<String> items = ['XS','S','M','L','XL'];
  String? selectedItem = null;
  int rentDay = 3;
  int price = 35000;
  int optionalPrice = 8000;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(proWidth(50),0,proWidth(50),0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: proHeight(5)),
          Row(
            children: [
              SizedBox(width: proWidth(150)),
              Container(
                height: 2,
                width: proWidth(100),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: proWidth(10)),
              Container(
                width: proWidth(180),
                height: proHeight(40),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    side: BorderSide(width: 1, color: Colors.black),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: (){
                    context.beamToNamed('/signup');
                  },
                  child: Text(
                    '장바구니 담기',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(width: proWidth(20)),
              Container(
                width: proWidth(180),
                height: proHeight(40),
                child: TextButton(
                    onPressed: (){},
                    child: Text(
                      '결제하기',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      backgroundColor: Colors.black,
                    )
                ),
              )
            ],
          ),
          SizedBox(height: proHeight(20)),
        ],
      ),
    );
  }
}