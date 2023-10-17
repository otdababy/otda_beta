import 'dart:convert';
import 'package:app_v2/api/product_page_api.dart';
import 'package:app_v2/screens/clothing/clothing_page.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/classes/product/product.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key,
    required this.productId,
    required this.imageUrl,
    required this.defaultPrice,
    required this.productName,
    required this.brandName,
  }) : super(key: key);

  final int productId;
  final String imageUrl;
  final int defaultPrice;
  final String productName;
  final String brandName;

  @override
  _ProductCardState createState() => _ProductCardState(productId: productId, productName: productName,
      defaultPrice: defaultPrice, imageUrl: imageUrl, brandName: brandName );
}

class _ProductCardState extends State<ProductCard> {
  _ProductCardState({
    Key? key,
    required this.productId,
    required this.imageUrl,
    required this.defaultPrice,
    required this.productName,
    required this.brandName,
  }); //: super(key: key);

  final int productId;
  final String imageUrl;
  final int defaultPrice;
  final String productName;
  final String brandName;

  void handleProduct(int id) async {
    //GET request
    try{
      var a = await ProductGetApi.getProduct(id);
      final body = json.decode(a.body.toString());
      //result from GET
      final result = body['result'];
      //Get 성공
      if(body['isSuccess']){
        if(result['avg_score'] == null){
          result['avg_score'] = 0.0;
        }
        if(result['reviewCount'] == null){
          result['reviewCount'] = 0;
        }

        //서버에서 product info 따와서 설정 후 화면 로드
        final product = Product(id: result['id'], images: result['images'], productName: result['productName'],
            defaultPrice: result['defaultPrice'], brandName: result['brandName'], availableInstance: result['availableInstance'],
            relatedProducts: result['relatedProducts'], optionPrice: result['optionPrice'],
            reviews: result['reviews'], optionName: result['optionName'],information: result['information'], avg_score: result['avg_score'].toDouble(), reviewCount: result['reviewCount'] );//

        //product를 navigator을 통해 clothing page로 넘긴다
        context.beamToNamed('/clothing_page', data: {'product': product});
      }
    }
    catch(e) {
      print('실패함');
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{
        handleProduct(productId),
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
                          image: NetworkImage(imageUrl)
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
                      brandName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize:12
                      ),
                      //maxLines: 2,
                    ),
                    SizedBox(height: proHeight(5)),
                    Text(
                      productName,
                      style: TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.w400),
                      maxLines: 2,
                    ),
                    SizedBox(height: proHeight(5)),
                    Text(
                      "Rent ${defaultPrice}원~",
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
    );
  }
}
