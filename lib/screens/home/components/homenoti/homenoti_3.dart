import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:app_v2/widget/section_title.dart';
import 'package:app_v2/classes/product/product_card.dart';

class HomeNoti3 extends StatelessWidget {
  const HomeNoti3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffEFEFEF),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: proHeight(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: proWidth(180),
                width: proWidth(180),
                child: Image.asset(
                    "assets/images/shiningt.png",
                  ),
              ),
              Text(
                  '완벽한 항균, 냄세 제거로\n 항상 새옷처럼 이용해보세요 😊',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: proWidth(25),
                  )
              ),



            ],
          ),
        ),
      ),

    );
  }
}
