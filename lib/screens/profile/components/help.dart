import 'dart:convert';

import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/src/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class help extends StatefulWidget {

  @override
  _helpState createState() => _helpState();
}

class _helpState extends State<help> {


  void popUp(String title, String text, String image, String next) async {
    await showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(image,
                height: proHeight(100),
                width: proHeight(100),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: proHeight(5),),
                  Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4E4E4E),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        await showDialog(
                            context: context,
                            builder: (BuildContext context)
                            {
                              return AlertDialog(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Image.asset('assets/images/문앞택배.png',
                                    height: proHeight(100),
                                    width: proHeight(100),
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('반납일 전날 밤, 문 앞에 둬주세요!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(height: proHeight(5),),
                                      Text('배송됐던 박스에 큰 글씨로\n"옷다"를 적은 후 문 앞에 둬주세요',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff4E4E4E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(),
                                        OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            shape: StadiumBorder(),
                                            backgroundColor: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);

                                          },
                                          child: Text('완료',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Text(next,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                height: proHeight(45),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextButton(
                  onPressed: (){
                    context.beamToNamed('/policy');
                  },
                  child: Text(
                    '이용약관',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    backgroundColor: Colors.white,
                  )
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: proHeight(45),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextButton(
                    onPressed: (){
                      popUp('따로 세탁은 하지 말아주세요!', '세탁으로 인한 손상 시 손상액이 청구 될 수 있습니다', 'assets/images/세탁금지.png', '다음');
                    },
                    child: Text(
                      '반납 안내',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      backgroundColor: Colors.white,
                    )
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                height: proHeight(45),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextButton(
                    onPressed: (){
                      context.beamToNamed('/penalty');
                    },
                    child: Text(
                      '페널티 정책',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      backgroundColor: Colors.white,
                    )
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: proHeight(45),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextButton(
                    onPressed: (){
                      context.beamToNamed('/return');
                    },
                    child: Text(
                      '교환 / 반품 정책',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      backgroundColor: Colors.white,
                    )
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}