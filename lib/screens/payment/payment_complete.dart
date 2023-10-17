import 'dart:convert';
import 'package:beamer/src/beamer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import '../../api/order/order_track_api.dart';
import '../../utils/user_secure_storage.dart';


class PaymentComplete extends StatefulWidget {
  const PaymentComplete({Key? key}) : super(key: key);

  @override
  _PaymentCompleteState createState() => _PaymentCompleteState();
}

class _PaymentCompleteState extends State<PaymentComplete> {
  _PaymentCompleteState({Key? key});

  String toUserName = "";
  String toUserPhone = "";
  String destination = "";
  int totalPrice = 0;
  int couponSale = 0;
  int orderId = 0;
  String trackNumber = "";
  List<dynamic> instances = [];

  void initState(){
    super.initState();
  }

  void didChangeDependencies(){
    setState((){
      print(context.currentBeamLocation.state.data['result']);
      toUserName = context.currentBeamLocation.state.data['result']['toUserName'];
      toUserPhone = context.currentBeamLocation.state.data['result']['toUserPhone'];
      destination = context.currentBeamLocation.state.data['result']['destination'];
      totalPrice = context.currentBeamLocation.state.data['result']['totalPrice'];
      couponSale = context.currentBeamLocation.state.data['result']['couponSale'];
      instances = context.currentBeamLocation.state.data['result']['instances'];
      orderId = context.currentBeamLocation.state.data['orderId'];
    });
    trackOrder();

  }

  void trackOrder() async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await TrackGetApi.getTrack(userId, jwt, orderId);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if (body['isSuccess']) {
          setState((){
            if(result[0]['trackingNumber'] == null)
              trackNumber = "아직 배송 준비중 입니다";
            else
              trackNumber = result[0]['trackingNumber'];
          });
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
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('주문 조회'),
            leading: IconButton(onPressed: (){
              context.beamToNamed('/home');
            }, icon: Icon(Icons.west_outlined),),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:EdgeInsets.symmetric(vertical: proHeight(15), horizontal: proWidth(20)),
                  child: Text(
                    '총 ${instances.length}개의 상품',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: proWidth(20)
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(width: proWidth(20)),
                    Expanded(
                      child: Container(height:1,color: Colors.grey.shade200,),
                    ),
                    Container(width: proWidth(20)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: proHeight(10), horizontal: proWidth(20)),
                  child: Column(
                    children: [
                      ...List.generate(
                        instances.length,
                            (index) => Row(
                          children: [
                            //사진
                            Container(
                              height: proWidth(100),
                              width: proWidth(100),
                              decoration:
                              BoxDecoration(
                                image: DecorationImage(
                                  //정사각형 아니더라도 빈공간 없이 차도록
                                  fit: BoxFit.cover,
                                  image: NetworkImage(instances[index]['imageUrl']),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(width: proWidth(20)),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: proHeight(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    instances[index]['brandName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: proWidth(20)
                                    ),
                                  ),
                                  SizedBox(height: proHeight(3),),
                                  Text(
                                    instances[index]['productName'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: proWidth(18)
                                    ),
                                  ),
                                  Text(
                                    (instances[index]['mappingSize'] == '0') ? "${instances[index]['size']}" :
                                    "${instances[index]['size']} (${instances[index]['mappingSize']})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: proWidth(18)
                                    ),
                                  ),
                                  SizedBox(height: proHeight(3),),
                                  Text(
                                    "${instances[index]['rentalDuration']}일 대여",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: proWidth(18)
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child:
                    Container(
                      color: Colors.grey.shade200,
                      height: proHeight(6),
                    ))
                  ],
                ),
                // 배송지 정보
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: proHeight(15),horizontal: proWidth(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          '배송지 정보',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: proWidth(20)
                          )
                      ),
                      Expanded(child: Container()),
                      Text(
                          '트래킹번호: $trackNumber',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: proWidth(15)
                          )
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(width: proWidth(20)),
                    Expanded(
                      child: Container(height:1,color: Colors.grey.shade200,),
                    ),
                    Container(width: proWidth(20)),
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: proHeight(15),horizontal: proWidth(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toUserName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: proWidth(17)
                        ),
                      ),
                      SizedBox(height: proHeight(8)),
                      Text(
                        toUserPhone,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: proWidth(17)
                        ),
                      ),
                      SizedBox(height: proHeight(8)),
                      Text(
                        destination,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: proWidth(17)
                        ),
                      ),
                      SizedBox(height: proHeight(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: Colors.grey.shade200,
                              ),
                              height: proHeight(40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: proWidth(7),),
                                  Icon(Icons.info_outline_rounded, color: Colors.grey.shade600, size: 16,),
                                  SizedBox(width: proWidth(7),),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '배송 소요 기간: 약 2~4일',
                                        style: TextStyle(
                                          fontSize: proWidth(17),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: proHeight(10),)
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(child:
                    Container(
                      color: Colors.grey.shade200,
                      height: proHeight(6),
                    ))
                  ],
                ),
                //결제 내역
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: proWidth(20), vertical: proHeight(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '결제 내역',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: proWidth(20)
                        ),
                      ),
                      SizedBox(height: proHeight(10),),
                      Row(
                        children: [
                          Expanded(
                            child: Container(height:1,color: Colors.grey.shade200,),
                          ),
                        ],
                      ),
                      SizedBox(height: proHeight(15)),
                      Row(
                          children: [
                            Text(
                              '총 상품 금액',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: proWidth(18)
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              "$totalPrice원",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: proWidth(18)
                              ),
                            ),
                          ]
                      ),
                      SizedBox(height: proHeight(12)),
                      Row(
                          children: [
                            Text(
                              '쿠폰 사용',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: proWidth(18)
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              '(-)$couponSale원',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: proWidth(18)
                              ),
                            ),
                          ]
                      ),
                      SizedBox(height: proHeight(12)),
                      Row(
                          children: [
                            Text(
                              '총 상품 금액',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: proWidth(18)
                              ),
                            ),
                            Expanded(child: Container()),
                            Text(
                              '${totalPrice - couponSale}원',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: proWidth(18),
                                color: Color(0xFF15CD5D),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
                SizedBox(height: proHeight(15)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: proWidth(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: proHeight(15)),
                      Text(
                        '결제 방식',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: proWidth(20)
                        ),
                      ),
                      SizedBox(height: proHeight(15)),
                      Row(
                          children : [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ]
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: proHeight(10)),
                          Text('무통장 입금',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: proWidth(18)
                            ),
                          ),
                          SizedBox(height: proHeight(15)),
                          RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '계좌번호: ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                    ),
                                  ),
                                  TextSpan(
                                    text: '1005-004-387770 (우리은행)',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff0076AB),
                                    ),
                                    recognizer: TapGestureRecognizer(),
                                  ),
                                ]
                            ),
                          ),
                          SizedBox(height: proHeight(5)),
                          Text('예금주: 주식회사 로트렉',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: proWidth(18)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: proHeight(15)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: proHeight(35)),
                Center(
                  child: Container(
                    width: proWidth(340),
                    height: proHeight(45),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          primary: Colors.black,
                          side: BorderSide(width: 1, color: Colors.black),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          backgroundColor: Colors.black
                      ),
                      onPressed: (){
                        context.beamToNamed('/home');
                      },
                      child: Text(
                        '홈으로 가기',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: proHeight(35)),
              ],
            ),
          )
      ),
    );
  }
}
