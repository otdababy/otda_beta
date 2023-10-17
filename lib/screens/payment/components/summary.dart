import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';

class Summary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: proHeight(15)),
        Row(
          children: [
            SizedBox(width: proWidth(30)),
            Text(
              '결제 금액',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: proHeight(15)),
        Row(
            children : [
              SizedBox(width: proWidth(18)),
              Container(
                width: proWidth(460),
                height: 1,
                color: Colors.grey.shade200,
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '총 상품 금액',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: proWidth(320)),
              Text(
                '35,000원',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '총 배송비',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: proWidth(342)),
              Text(
                '2,500원',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '쿠폰 사용',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: proWidth(328)),
              Text(
                '(-) 3,000원',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
        /*Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '포인트 사용',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: proWidth(340)),
              Text(
                '(-)0원',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)), */
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '총 결제 금액',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: proWidth(297)),
              Text(
                '34,500원',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff15CD5D)
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
      ],
    );
  }
}