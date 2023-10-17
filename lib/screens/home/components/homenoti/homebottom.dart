import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:app_v2/widget/section_title.dart';
import 'package:app_v2/classes/product/product_card.dart';

class HomeBottom extends StatelessWidget {
  const HomeBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            SizedBox(
              height: proHeight(20),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  '고객센터',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  )
              ),
            ),
            SizedBox(
              height: proHeight(10),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  '평일 9:00 - 18:00 (주말, 공휴일 휴무)\n점심 12:00 - 13:00',
                  style: TextStyle(
                    color: Color(0xffB4B4B4),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )
              ),
            ),
            SizedBox(
              height: proHeight(20),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  '사업자정보',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  )
              ),
            ),
            SizedBox(
              height: proHeight(10),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                      '주식회사 로트렉      Lautrec Corp.\n'
                      '대표이사                 박우진, 장채민\n'
                      '사업자등록번호       631-81-02908\n'
                      '사업장소재지          서울\n'
                      '호스팅 서비스         AWS',
                  style: TextStyle(
                    color: Color(0xffB4B4B4),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  )
              ),
            ),
            SizedBox(
              height: proHeight(30),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                  '일부 상품의 경우 주식회사 로트렉은 통신판매중개자이며 통신판매의 당사자가 아닙니다.\n'
                      '따라서 상품정보 및 거래에 대한 책임을 지지 않으므로, 각 상품 페이지에서 구체적인 내용을 확인하시기 바랍니다.',
                  style: TextStyle(
                    color: Color(0xffB4B4B4),
                    fontWeight: FontWeight.w400,
                    fontSize: 9,
                  )
              ),
            ),
            SizedBox(
              height: proHeight(10),
            ),
          ],
        ),
      ),
    );
  }
}
