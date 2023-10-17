import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../api/product_page_api.dart';
import 'package:app_v2/classes/product/product.dart';
import 'package:app_v2/classes/product/product_card.dart';
import 'package:app_v2/classes/review/review_card.dart';

class ClothingBody extends StatefulWidget {
  Product product;
  ClothingBody({Key? key, required this.product}) : super(key: key);

  @override
  _ClothingBodyState createState() => _ClothingBodyState(product);
}

class _ClothingBodyState extends State<ClothingBody> {
  Product product;
  _ClothingBodyState(this.product);
  void handleProduct(int id) async {
    //GET request
    try{
      var a = await ProductGetApi.getProduct(id);
      final body = json.decode(a.body.toString());
      //result from GET
      final result = body['result'];
      print(result);
      //Get 성공
      if(body['isSuccess']){
        if(result['avg_score'] == null){
          result['avg_score'] = 0;
        }
        if(result['reviewCount'] == null){
          result['reviewCount'] = 0;
        }

        //서버에서 product info 따와서 설정 후 화면 로드
        final item = Product(id: result['id'], images: result['images'], productName: result['productName'],
            defaultPrice: result['defaultPrice'], brandName: result['brandName'], availableInstance: result['availableInstance'],
            relatedProducts: result['relatedProducts'], optionPrice: result['optionPrice'],
            reviews: result['reviews'], optionName: result['optionName'],information: result['information'], avg_score: result['avg_score'].toDouble(), reviewCount: result['reviewCount'] );

        Navigator.pop(context);
        context.beamToNamed('/clothing_page', data: {'product' : item});
      }
    }
    catch(e) {
      print('실패함');
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: proWidth(0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(proHeight(8.0)),
              child: CarouselSlider(
                items: product.images
                    .map((item) => Container(
                  child: Center(
                    child: Image.network(
                      item['imageUrl'],
                      fit: BoxFit.cover,
                      width: 1000,
                      height: 1000,
                    ),
                  ),
                ))
                    .toList(),
                options: CarouselOptions(
                  autoPlay: false,
                  aspectRatio: 1.0,
                  viewportFraction: 1,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: proWidth(32)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: proHeight(10)),
                  Text(
                    '${product.brandName}',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: proWidth(23)),
                  ),
                  SizedBox(height: proHeight(5)),
                  Text(
                    '${product.productName}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(20)),
                  ),
                  SizedBox(height: proHeight(20)),
                  Text(
                    '색상: ${product.optionName}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(14), color: Colors.grey),
                  ),
                  SizedBox(height: proHeight(30)),
                  SizedBox(height: proHeight(5)),
                  Text(
                    '${product.defaultPrice}원/3일',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(23)),
                  ),
                  SizedBox(height: proHeight(5)),
                  Text(
                    '${(product.optionPrice)}원/일',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(23)),
                  ),
                  SizedBox(height: proHeight(30)),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: proHeight(20)),
                  Text(
                    '상세 설명',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: proWidth(23)),
                  ),
                  SizedBox(height: proHeight(15)),
                  SizedBox(height: proHeight(5)),
                  Text(
                    '배송비: 무료',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: proWidth(14)),
                  ),
                  SizedBox(height: proHeight(5)),
                  Text(
                    '배송 소요 기간: 주문 후 평균 2~4일 내 도착 예정',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: proWidth(14)),
                  ),
                  SizedBox(height: proHeight(10)),
                  Text(
                    '${product.information}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: proWidth(14)),
                  ),
                  Text(
                    '상품 설명: ',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: proWidth(14)),
                  ),
                  SizedBox(height: proHeight(30)),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: proHeight(20)),
                  Text(
                    '실측',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: proWidth(23)),
                  ),
                  SizedBox(height: proHeight(15)),
                  Text(
                    'OTDA팀이 직접 측정한 자료입니다.',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: proWidth(12),color: Color(0xff707070)),
                  ),
                  SizedBox(height: proHeight(25)),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: proHeight(30)),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: proWidth(32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '리뷰(${product.reviewCount})',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: proWidth(20)),
                      ),
                      GestureDetector(
                        onTap: (){
                          context.beamToNamed('/reviews',data: {'reviews': product.reviews,
                            'productName':product.productName,'avg_score':product.avg_score,'reviewCount':product.reviewCount});
                        },
                        child: Icon(Icons.east_outlined),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          //height: proHeight(80),
                          decoration: BoxDecoration(
                            color: Color(0xffF6F6F6),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: proHeight(5),horizontal: proWidth(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Text('평균평점',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: proWidth(20)),
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: product.avg_score.toDouble(),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.black,
                                      ),
                                      itemCount: 5,
                                      itemSize: proHeight(30),
                                      direction: Axis.horizontal,
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      '(${product.avg_score.toStringAsFixed(2)})',
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: proWidth(20)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: proHeight(10)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        //product.reviews에 있는 review를 review card형태로 나타낸 리스트
                        ...List.generate(
                          product.reviews.length,
                              (index) => ReviewCard(
                              reviewId: product.reviews[index]['reviewId'],
                              score: product.reviews[index]['score'],
                              size: product.reviews[index]['size'],
                              rentalDuration: product.reviews[index]['rentalDuration'],
                              text: product.reviews[index]['text'],
                              images: (product.reviews[index]['images'].length == 0) ? [{'imageUrl' : product.images[0]['imageUrl']}] : product.reviews[index]['images']
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: proHeight(40)),
                  Text(
                    '추천 상품',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: proWidth(20)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  //product.related에 있는 아이템을 productCard형태로 나타낸 리스트
                  ...List.generate(
                      product.relatedProducts.length,
                          (index) => GestureDetector(
                        onTap: ()=>{
                          handleProduct(product.relatedProducts[index]['productId']),
                        },
                        child: Padding(
                          padding: EdgeInsets.all(proWidth(10)),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: proWidth(180),
                                      height: proWidth(180),
                                      decoration:
                                      BoxDecoration(
                                        image: DecorationImage(
                                          //정사각형 아니더라도 빈공간 없이 차도록
                                            fit: BoxFit.cover,
                                            image: NetworkImage(product.relatedProducts[index]['imageUrl'])
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: proHeight(15)),
                                Padding(
                                  padding: EdgeInsets.only(left: proWidth(5)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.relatedProducts[index]['brandName'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize:12
                                        ),
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: proHeight(7)),
                                      Text(
                                        product.relatedProducts[index]['productName'],
                                        style: TextStyle(color: Colors.black, fontSize: 12),
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: proHeight(7)),
                                      Text(
                                        "Rent ${product.relatedProducts[index]['defaultPrice']}원~",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            SizedBox(height: proHeight(290)),
          ],
        ),
      )
    );
  }
}