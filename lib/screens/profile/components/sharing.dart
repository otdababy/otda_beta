import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';


class sharing extends StatelessWidget {

  const sharing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: proHeight(75),
        width: proWidth(440),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Row(
            children: [
              SizedBox(width: proWidth(60)),
              Column(
                children: [
                  SizedBox(height: proHeight(19)),
                  Text(
                    '공유중',
                    style: TextStyle(
                      fontSize: proWidth(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: proHeight(7),
                  ),
                  Text(
                    '3',
                    style: TextStyle(
                        fontSize: proWidth(15),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: proWidth(55)
              ),
              Container(
                width: 1,
                height: proHeight(60),
                decoration: BoxDecoration(
                    color: Colors.grey.shade400
                ),
              ),
              SizedBox(
                width: proWidth(55),
              ),
              Column(
                children: [
                  SizedBox(height: proHeight(19)),
                  Text(
                    '배송중',
                    style: TextStyle(
                      fontSize: proWidth(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: proHeight(7),
                  ),
                  Text(
                    '3',
                    style: TextStyle(
                        fontSize: proWidth(15),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
              SizedBox(
                  width: proWidth(55)
              ),
              Container(
                width: 1,
                height: proHeight(60),
                decoration: BoxDecoration(
                    color: Colors.grey.shade400
                ),
              ),
              SizedBox(
                width: proWidth(55),
              ),
              Column(
                children: [
                  SizedBox(height: proHeight(19)),
                  Text(
                    '공유 종료',
                    style: TextStyle(
                      fontSize: proWidth(12),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: proHeight(7),
                  ),
                  Text(
                    '3',
                    style: TextStyle(
                        fontSize: proWidth(15),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ]
        )
    );
  }
}