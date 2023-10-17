import 'package:app_v2/widget/expandablefab.dart';
import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  _CouponPageState({Key? key});

  List<dynamic> _coupons = [];

  void initState(){
    super.initState();
  }

  void didChangeDependencies(){
    setState((){
      _coupons = context.currentBeamLocation.state.data['result'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('쿠폰함'),
        ),
        bottomSheet: Container(
            width: proWidth(340),
            height: proHeight(40),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                side: BorderSide(width: 1, color: Colors.black),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                backgroundColor: Colors.black,
              ),
              onPressed: (){
              },
              child: Text(
                '사용하기',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white
                ),
              ),
            ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "사용 가능한 쿠폰 ()"
                ),
                SizedBox(height: proHeight(10),),
                Column(
                  children: [
                    ...List.generate(
                      _coupons.length,
                            (index) => Container(
                                height: proHeight(80),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(20)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                            "${_coupons[index]['salePrice']}"
                                        ),
                                        SizedBox(width: proWidth(20),),
                                        Column(
                                          children: [
                                            Container(width: 1,height: proHeight(35),),
                                          ],
                                        ),
                                        SizedBox(width: proWidth(35),),
                                        Text(
                                            _coupons[index]['couponName']
                                        ),
                                        SizedBox(width: proWidth(35),),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                    ),
                  ],
                ),
                SizedBox(height: proHeight(20),),
                Text(
                    "만료된 쿠폰 ()"
                ),
                SizedBox(height: proHeight(10),),
                Column(
                  children: [
                    ...List.generate(
                      _coupons.length,
                          (index) => Container(
                          height: proHeight(80),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: proWidth(20),vertical: proHeight(20)),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                      "${_coupons[index]['salePrice']}"
                                  ),
                                  SizedBox(width: proWidth(20),),
                                  Column(
                                    children: [
                                      Container(width: 1,height: proHeight(35),),
                                    ],
                                  ),
                                  SizedBox(width: proWidth(35),),
                                  Text(
                                      _coupons[index]['couponName']
                                  ),
                                  SizedBox(width: proWidth(35),),
                                ],
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
