import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';

class Address extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: proWidth(30),
            ),
            Text(
                '배송지 정보',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                )
            ),
            SizedBox(
              width: proWidth(330),
            ),
            Container(
              height: proHeight(22),
              width: proWidth(50),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.black),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                  backgroundColor: Colors.white,
                ),
                onPressed: (){
                },
                child: Center(
                  child: Text(
                    '수정',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: proHeight(10)),
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
        SizedBox(height: proHeight(10)),
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '000',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(4)),
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '000 / 010-6216-2522',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(4)),
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '서울 마포구 0000000000 [04201]',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
        Row(
            children: [
              SizedBox(width: proWidth(25)),
              Container(
                width: proWidth(440),
                height: proHeight(30),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: " 배송메모를 남겨주세요",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: proHeight(12)
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ]
        ),
        SizedBox(
          height: proHeight(15),
        ),
        Container(
          height: 6,
          width: proWidth(500),
          color: Colors.grey.shade200,
        ),
      ],
    );
  }
}