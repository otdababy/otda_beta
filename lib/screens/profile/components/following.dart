import 'dart:convert';

import 'package:app_v2/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../api/coupon/coupon_api.dart';
import '../../../utils/user_secure_storage.dart';

class Following extends StatefulWidget {
    Following({
    Key? key,
    required this.boardCount,
    required this.keepCount,
    required this.couponCount,
  });

  final int boardCount;
  final int keepCount;
  final int couponCount;

  @override
  _FollowingState createState() => _FollowingState(boardCount: boardCount, keepCount: keepCount, couponCount: couponCount);
}

class _FollowingState extends State<Following> {

  _FollowingState({
    Key? key,
    required this.boardCount,
    required this.keepCount,
    required this.couponCount,
  });

  final int boardCount;
  final int keepCount;
  final int couponCount;


  List<dynamic> _usableCoupon = [];
  List<dynamic> _expiredCoupon = [];


  void didChangeDependencies(){
    setState((){
      getCoupons();
    });
  }

  void getCoupons() async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await CouponGetApi.getCoupon(userId, jwt);
        final body = json.decode(a.body.toString());
        final result = body['result'];
        if (body['isSuccess']) {
          //현재 날짜 받아와서 날짜 비교 후 각각 list에 넣음
          var _toDay = DateTime.now();
          for(int i=0; i<result.length; i++){
            String expiryDate = result[i]['expiryDate'].replaceAll('/','-');
            int difference = int.parse(
                _toDay.difference(DateTime.parse(expiryDate)).inDays.toString());
            if(difference > 0){
              setState(() {
                _expiredCoupon.add(result[i]);
              });
            }
            else{
              setState(() {
                _usableCoupon.add(result[i]);
              });
            }
          }
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: proWidth(70)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                '게시물',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: proHeight(3),),
              Text(
                boardCount.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '장바구니',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: proHeight(3),),
              Text(
                keepCount.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      builder: (context){
                        return Scaffold(
                            backgroundColor: Colors.white,
                            appBar: AppBar(
                              title: Text('쿠폰함'),
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
                                        "사용 가능한 쿠폰 (${_usableCoupon.length})"
                                    ),
                                    SizedBox(height: proHeight(10),),
                                    Column(
                                      children: <Widget>[
                                        ...List.generate(
                                          _usableCoupon.length,
                                              (index) => Padding(
                                            padding: EdgeInsets.symmetric(vertical: proHeight(5)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: proWidth(10)),
                                                Expanded(
                                                  child: Container(
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
                                                                  "${_usableCoupon[index]['salePrice']}"
                                                              ),
                                                              SizedBox(width: proWidth(20),),
                                                              Column(
                                                                children: [
                                                                  Container(width: 1,height: proHeight(35),),
                                                                ],
                                                              ),
                                                              SizedBox(width: proWidth(35),),
                                                              Text(
                                                                  _usableCoupon[index]['couponName']
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
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: proHeight(20),),
                                    Text(
                                        "만료된 쿠폰 (${_expiredCoupon.length})"
                                    ),
                                    SizedBox(height: proHeight(10),),
                                    Column(
                                      children: <Widget>[
                                        ...List.generate(
                                          _expiredCoupon.length,
                                              (index) => Padding(
                                            padding: EdgeInsets.symmetric(vertical: proHeight(5)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(width: proWidth(10)),
                                                Expanded(
                                                  child: Container(
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
                                                                  "${_expiredCoupon[index]['salePrice']}"
                                                              ),
                                                              SizedBox(width: proWidth(20),),
                                                              Column(
                                                                children: [
                                                                  Container(width: 1,height: proHeight(35),),
                                                                ],
                                                              ),
                                                              SizedBox(width: proWidth(35),),
                                                              Text(
                                                                  _expiredCoupon[index]['couponName']
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
                  );
                },
                child: Text(
                  '내 쿠폰함',
                 style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
              SizedBox(height: proHeight(3),),
              Text(
                couponCount.toString(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}