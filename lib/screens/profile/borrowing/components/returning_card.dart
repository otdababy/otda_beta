import 'dart:convert';
import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../../../../api/receipt/receipt_api.dart';
import '../../../../api/review/specific_review_api.dart';
import '../../../../utils/user_secure_storage.dart';

class ReturningCard extends StatefulWidget {
  const ReturningCard({Key? key,
    required this.productId,
    required this.rentalRequestId,
    required this.rentalStatus,
    required this.imageUrl,
    required this.brandName,
    required this.productName,
    required this.size,
    required this.mappingSize,
    required this.rentalDuration,
    required this.returnDate,
    required this.reviewId,
    required this.orderId,
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
  final String returnDate;
  final int reviewId;
  final int orderId;

  @override
  _ReturningCardState createState() => _ReturningCardState(reviewId: reviewId,productId: productId,rentalDuration: rentalDuration,
      rentalStatus: rentalStatus,rentalRequestId: rentalRequestId,imageUrl: imageUrl,brandName: brandName
      ,productName: productName, size: size, mappingSize: mappingSize, returnDate: returnDate, orderId: orderId);
}

class _ReturningCardState extends State<ReturningCard> {
  _ReturningCardState({
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
    required this.returnDate,
    required this.reviewId,
    required this.orderId,
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
  final String returnDate;
  final int reviewId;
  final int orderId;


  String reviewText = "리뷰 작성하기";

  void didChangeDependencies(){
    if(reviewId != 0){
      setState(() {
        reviewText = "리뷰 보기";
      });
    }
  }

  void handleSpecificReview(int reviewId) async {
    try{
      print(reviewId);
      var a = await SpecificReviewGetApi.getSpecificReview(reviewId);
      final body = json.decode(a.body.toString());
      print(body);
      final result = body['result'];
      if(body['isSuccess']){
        //정보 넣고 상세 리뷰페이지로 빔
        context.beamToNamed('/specific_review',data:{'result':result, 'reviewId' : reviewId});
      }
      else{
        print("실패함 리뷰상세페이지");
      }

    }catch(e){
      print(e);
    }
  }

  void handleReceipt(int orderId) async{
    try{
      try{
        String? jwt = await UserSecureStorage.getJwt();
        try{
          var a = await ReceiptGetApi.getReceipt(orderId, jwt );
          final body = json.decode(a.body.toString());
          final result = body['result'];
          print(result);
          print("receipt안에 있음");
          //Get 성공
          if(body['isSuccess']){
            //영수증 조회 페이지로 이동
            context.beamToNamed('/receipt',data: {'result' : result[0], 'orderId' : orderId});
          }
        }
        catch(e) {
          print('실패함');
          print(e.toString());
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
                  SizedBox(height: proHeight(10)),
                  Text(
                    "${returnDate} 반납 완료",
                    style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
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
                        '영수증 조회',
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
                        backgroundColor: Colors.black,
                      ),
                      onPressed: (){
                        if(reviewText == "리뷰 보기"){
                          handleSpecificReview(reviewId);
                        }
                        else{
                          context.beamToNamed('/write_review', data: {'productName':productName,'rentalRequestId':rentalRequestId});
                        }
                        },
                      child: Text(
                        reviewText,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
