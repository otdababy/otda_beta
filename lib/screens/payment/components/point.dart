import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';

class Point extends StatelessWidget {
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
              '최대 적립 예정 포인트',
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
                '반납 완료',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: proWidth(340)),
              Text(
                '-P',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
        Row(
            children: [
              SizedBox(width: proWidth(30)),
              Text(
                '리뷰 작성',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: proWidth(340)),
              Text(
                '-P',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]
        ),
        SizedBox(height: proHeight(15)),
      ],
    );
  }
}