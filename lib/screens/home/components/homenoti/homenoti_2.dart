import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:app_v2/widget/section_title.dart';
import 'package:app_v2/classes/product/product_card.dart';

class HomeNoti2 extends StatelessWidget {
  const HomeNoti2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.65,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffC9AD8D),
        ),
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                height: proHeight(180),
                width: proWidth(380),
                child: AspectRatio(
                  aspectRatio: 2/1,
                  child: Image.asset(
                    "assets/images/homenoti2clothes.png",
                    ),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Text(
                 '돌아온 멋의 계절, 가을',
                  style: TextStyle(
                    color: Color(0xff3E2424),
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  )
              ),
              Padding(padding: EdgeInsets.all(5)),
              Text(
                  '대여하러가기',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Color(0xff684C4C),
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  )
              ),


            ],
          ),
        ),

      ),
    );
  }
}
