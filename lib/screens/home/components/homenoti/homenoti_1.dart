import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:app_v2/widget/section_title.dart';
import 'package:app_v2/classes/product/product_card.dart';

class HomeNoti1 extends StatelessWidget {
  const HomeNoti1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.65,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13.0),
                      ),
                      Text('트렌디한 아이템을 빌려주고,\n돈을 벌어보세요.\n\n(수수료 0%)',
                          style: TextStyle(
                              color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          )
                      ),
                      Padding(padding: EdgeInsets.all(10)),

                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: proHeight(180),
                          width: proWidth(180),
                          child: AspectRatio(
                            aspectRatio: 150/159.3,
                              child: Image.asset("assets/images/handwithcash.png",)
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(15)),
                  Center(
                    child: SizedBox(
                      width: proWidth(200),
                      height: proHeight(50),
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(shape: StadiumBorder(),),
                        child: Text('지금 시작하기'),
                      ),
                    ),
                  )
                ],
              ),
        ),
    );
  }
}
