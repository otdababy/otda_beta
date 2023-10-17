import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api/coupon/coupon_api.dart';
import '../../api/profile_page/borrowing_api.dart';
import '../../api/profile_page/profile_page/delivering_api.dart';
import '../../api/profile_page/profile_page/profile_api.dart';
import '../../api/profile_page/profile_page/returned_api.dart';
import '../../utils/user_secure_storage.dart';
import 'components/profile_pic.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/screens/profile/components/following.dart';
import 'package:app_v2/screens/profile/components/help.dart';
import 'package:app_v2/screens/profile/components/section_title.dart';
import 'package:app_v2/screens/profile/components/borrowing.dart';
import 'package:app_v2/utils/size_config.dart';




class ClosetBody extends StatefulWidget {
  @override
  _ClosetBodyState createState() => _ClosetBodyState();
}

class _ClosetBodyState extends State<ClosetBody> {

  void handleBorrowing() async {
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 대여중, 배송중, 반납 완료 정보 받아옴
      try{
        var a = await BorrowingGetApi.getBorrowing(userId, jwt);
        final body1 = json.decode(a.body.toString());
        //result from GET
        final borrowing = body1['result'];
        //Get 성공
        if(body1['isSuccess']){
          //바로잉은 성공했으니 이제 배송중 정보 받아옴
          try{
            var b = await DeliveringGetApi.getDelivering(userId, jwt);
            final body2 = json.decode(b.body.toString());
            //result from GET
            final delivering = body2['result'];
            //딜리버링 성공
            if(body2['isSuccess']){
              try{
                var c = await ReturningGetApi.getReturning(userId, jwt);
                final body3 = json.decode(c.body.toString());
                //result from GET
                final returning = body3['result'];
                //리터닝 성공
                if(body3['isSuccess']){
                  //세개 다 성공함, 이제 페이지 옮기고 정보 넘기면됌
                  context.beamToNamed('borrowing',data:{'borrowing':borrowing,
                    'delivering':delivering, 'returning':returning});
                }
              }catch(e){
                print(e);
              }
            }
          }catch(e){
            print(e);
          }
        }
        else{
          print("대여중 실패");
        }
      }
      catch(e) {
        print('실패함');
        print(e.toString());
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //return value: list of length 2 -> results from category 19,20
        future: handleProfile(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if( snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Please wait its loading...'));
          }else{
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else //snapshot.data
              return SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: proHeight(30)),
                      ProfilePic(number: snapshot.data[0]['phoneNumber'] ,nickName: snapshot.data[0]['nickName'], profileImageUrl: snapshot.data[0]['profileImageUrl'],),
                      SizedBox(height: proHeight(25)),
                      Following(couponCount: snapshot.data[0]['couponCount'],boardCount: snapshot.data[0]['boardCount'],keepCount: snapshot.data[0]['keepCount']),
                      SizedBox(height: proHeight(30)),
                      Container(
                        color: Colors.grey.shade200,
                        height: proHeight(6),
                      ),
                      SizedBox(height: proHeight(20)),
                      SectionTitle(title: '대여 내역', press: handleBorrowing),
                      SizedBox(height: proHeight(15)),
                      Borrowing(rental_delivery: snapshot.data[0]['rental_delivery'],rental_ing: snapshot.data[0]['rental_ing'],rental_return: snapshot.data[0]['rental_return']),
                      SizedBox(height: proHeight(20)),
                      Container(
                        color: Colors.grey.shade200,
                        height: proHeight(5),
                      ),
                      help(),
                      Container(
                        color: Colors.grey.shade200,
                        height: proHeight(5),
                      ),
                      SizedBox(height: proHeight(20)),
                      Row(
                        children: [
                          SizedBox(width: proWidth(30)),
                          Text(
                            '고객센터',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          SizedBox(width: proWidth(30)),
                          InkWell(
                            onTap: (){Clipboard.setData(ClipboardData(text: "customerservice@otda.co.kr"));},
                            child: RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'customerservice@otda.co.kr',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff0076AB),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: proHeight(15)),
                      Row(
                        children: [
                          SizedBox(width: proWidth(30)),
                          Text(
                            '운영시간 평일 11:00 - 18:00 (토/일, 공휴일휴무)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(5),),
                      Row(
                        children: [
                          SizedBox(width: proWidth(30)),
                          Text(
                            '점심시간 평일 13:00 - 14:00',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                    ],
                  )
              );
          }
        }
    );
  }
  Future<dynamic> handleProfile() async{
    //List<dynamic> categories = [];
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //유저 정보 가지고 프로필 조회 시도
      try{
        var a = await ProfileGetApi.getProfile(jwt, userId);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //마이페이지에 정보 전송
          return result;
        }
      }
      catch(e) {
        print('실패함 카테고리 조회 뉴인');
        print(e.toString());
      }
    }catch(e){
      print(e);
      print("핸들 프로필 아이디조회 실패");
    }
  }
}