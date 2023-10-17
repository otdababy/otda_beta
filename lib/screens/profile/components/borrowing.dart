import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';


class Borrowing extends StatelessWidget {

  const Borrowing({
    Key? key,
    required this.rental_ing,
    required this.rental_delivery,
    required this.rental_return,
  }) : super(key: key);

  final int rental_ing;
  final int rental_delivery;
  final int rental_return;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ((){

      }),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
        child: Container(
          height: proHeight(75),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '배송중',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: proHeight(7),
                  ),
                  Text(
                    rental_delivery.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: proHeight(50),
                decoration: BoxDecoration(
                    color: Colors.grey.shade400
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '대여중',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF15CD5D),
                    ),
                  ),
                  SizedBox(
                    height: proHeight(7),
                  ),
                  Text(
                    rental_ing.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: proHeight(50),
                decoration: BoxDecoration(
                    color: Colors.grey.shade400
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '반납 완료',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: proHeight(7),
                  ),
                  Text(
                    rental_return.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
              Container(),
            ]
          )
        ),
      ),
    );
  }
}