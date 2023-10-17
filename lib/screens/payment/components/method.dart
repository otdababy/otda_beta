import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter/services.dart';

class Method extends StatefulWidget {
  @override
  _MethodState createState() => _MethodState();
}

class _MethodState extends State<Method> {
  String _gval = 'kakaopay';

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
              '결제 방식',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: proHeight(10)),
            Row(
              children: [
                SizedBox(width: proWidth(30)),
                Text('무통장 입금',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                ),
              ],
            ),
            SizedBox(height: proHeight(15)),
            Row(
              children: [
                SizedBox(width: proWidth(30)),
                RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '계좌번호: ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                          ),
                        ),
                        TextSpan(
                          text: '1005-004-387770 (우리은행)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff0076AB),
                          ),
                          recognizer: TapGestureRecognizer(),
                        ),
                      ]
                    ),
                ),
                //Text('계좌번호: 1005-004-387770 (우리은행)',
                  //style: TextStyle(
                    //fontWeight: FontWeight.w400,
                    //fontSize: 13,
                  //),
                //),
                /*onPressed: () {
                    Clipboard.setData(ClipboardData(text: '01086013488'));
                  },*/
              ],
            ),
            SizedBox(height: proHeight(5)),
            Row(
              children: [
                SizedBox(width: proWidth(30)),
                Text('예금주: 주식회사 로트렉',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            SizedBox(height: proHeight(10)),
          ],
        ),
        /*ExpansionTile(
          title: Text(
            '카카오페이',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15
            ),
          ),
          children: <Widget>[
            ListTile(title: Text('물건정보')),
          ],
        ),
        Row(
            children : [
              SizedBox(width: proWidth(18)),
              Container(
                width: proWidth(460),
                height: 1,
                color: Colors.grey.shade200,
              ),
            ]
        ),*/
      ],
    );
  }
}