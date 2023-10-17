import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';


class point extends StatelessWidget {

  const point({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: proWidth(145),
        ),
        Column(
          children: [
            Text(
              '포인트',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: proHeight(5),
            ),
            Text(
              '5999P',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
        SizedBox(
          width: proWidth(145),
        ),
        Column(
          children: [
            Text(
              '장바구니',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: proHeight(5),
            ),
            Text(
              '20',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
      ],
    );
  }
}