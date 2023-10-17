import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';

class Discount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: proHeight(15),
        ),
        Row(
          children: [
            SizedBox(width: proWidth(30)),
            Text(
              '할인 적용',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
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
                '쿠폰 사용',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: proWidth(265)),
              Text(
                '3000원',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: proWidth(20)),
              Container(
                height: proHeight(25),
                width: proWidth(80),
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
                      '쿠폰 조회',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(10)),
      ],
    );
  }
}

/* 포인트 사용 UI Row(
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
              SizedBox(width: proWidth(40)),
              Column(
                children: [
                  SizedBox(height: proHeight(5)),
                  Container(
                    width: proWidth(260),
                    height: 30,
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
              SizedBox(width: proWidth(15)),
              Container(
                height: proHeight(25),
                width: proWidth(80),
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
                      '전액 사용',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ),
            ]
        ),
        SizedBox(
          height: proHeight(15),
        )
        */