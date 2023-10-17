import 'dart:convert';
import 'package:app_v2/api/product_page_api.dart';
import 'package:app_v2/screens/clothing/clothing_page.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/classes/product/product.dart';

// import '../../../../api/order/order_cancel_api.dart';
import '../../../../api/receipt/receipt_api.dart';
import '../../../../utils/user_secure_storage.dart';

class DeliveringCard extends StatefulWidget {
  const DeliveringCard({Key? key,
    required this.productId,
    required this.rentalRequestId,
    required this.rentalStatus,
    required this.imageUrl,
    required this.brandName,
    required this.productName,
    required this.size,
    required this.mappingSize,
    required this.rentalDuration,
    required this.orderId,
    required this.payStatus
  }) : super(key: key);

  final int productId;
  final int rentalRequestId;
  final int rentalStatus;
  final String size;
  final String mappingSize;
  final String imageUrl;
  final String productName;
  final String brandName;
  final int rentalDuration;
  final int payStatus;
  final int orderId;

  @override
  _DeliveringCardState createState() => _DeliveringCardState(productId: productId,rentalDuration: rentalDuration,
      rentalStatus: rentalStatus,rentalRequestId: rentalRequestId,imageUrl: imageUrl,brandName: brandName
      ,productName: productName, size: size, mappingSize: mappingSize,payStatus: payStatus,orderId: orderId);
}

class _DeliveringCardState extends State<DeliveringCard> {
  _DeliveringCardState({
    Key? key,
    required this.rentalRequestId,
    required this.productId,
    required this.rentalStatus,
    required this.imageUrl,
    required this.brandName,
    required this.productName,
    required this.size,
    required this.mappingSize,
    required this.rentalDuration,
    required this.orderId,
    required this.payStatus
  }); //: super(key: key);

  final int productId;
  final int rentalRequestId;
  final int rentalStatus;
  final String size;
  final String mappingSize;
  final String imageUrl;
  final String productName;
  final String brandName;
  final int rentalDuration;
  final int payStatus;
  final int orderId;

  List<String> status = ['입금 확인중'];
  List<String> rentStatus = ['배송 준비중', '배송 중'];

  void handleReceipt(int orderId) async{
    try{
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 패치실행
      try{
        var a = await ReceiptGetApi.getReceipt(orderId, jwt );
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //지우는거 성공함 -> 화면 리로드
          context.beamToNamed('/receipt',data: {'result' : result[0],'orderId' : orderId, 'payStatus' : payStatus});
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
    return Padding(
      padding: EdgeInsets.all(proWidth(20)),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration:
                      BoxDecoration(
                        image: DecorationImage(
                          //정사각형 아니더라도 빈공간 없이 차도록
                            fit: BoxFit.cover,
                            image: NetworkImage(imageUrl)
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: proHeight(15)),
            Padding(
              padding: EdgeInsets.only(left: proWidth(5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brandName,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize:12
                    ),
                    maxLines: 2,
                  ),
                  SizedBox(height: proHeight(7)),
                  Text(
                    productName,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    maxLines: 2,
                  ),
                  SizedBox(height: proHeight(7)),
                  Text(
                    (mappingSize == '0') ? "${size}, ${rentalDuration}일 대여"
                        :
                    "${size} (${mappingSize}), ${rentalDuration}일 대여",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                    maxLines: 2,
                  ),
                  SizedBox(height: proHeight(7)),
                  Text(
                    (payStatus == 0) ?
                    "${status[payStatus]}" : "${rentStatus[rentalStatus]}",
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    maxLines: 2,
                  ),
                  SizedBox(height: proHeight(10)),
                ],
              ),
            ),
            SizedBox(height: proHeight(15)),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: proHeight(30),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.black,
                        side: BorderSide(width: 1, color: Colors.black),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: (){
                        handleReceipt(orderId);
                      },
                      child: Text(
                        '주문 확인',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: proHeight(7),),
          ],
        ),
      ),
    );
  }
}
