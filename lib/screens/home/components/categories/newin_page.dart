import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:app_v2/utils/size_config.dart';

import '../../../../api/product_page_api.dart';
import '../../../../classes/product/product.dart';
import '../../../../classes/product/product_card.dart';
import '../../../../classes/product/product_card_home.dart';



class NewInPage extends StatefulWidget {
  const NewInPage({Key? key,
  }) : super(key: key);

  @override
  _NewInPageState createState() => _NewInPageState();
}


class _NewInPageState extends State<NewInPage> {


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
          result['avg_score'] = 0;
        }
        if(result['reviewCount'] == null){
          result['reviewCount'] = 0;
        }

        //서버에서 product info 따와서 설정 후 화면 로드
        final product = Product(id: result['id'], images: result['images'], productName: result['productName'],
            defaultPrice: result['defaultPrice'], brandName: result['brandName'], availableInstance: result['availableInstance'],
            relatedProducts: result['relatedProducts'], optionPrice: result['optionPrice'], reviewCount: result['reviewCount'],
            reviews: result['reviews'], optionName: result['optionName'],information: result['information'], avg_score: result['avg_score'].toDouble());

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
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: (){
                context.beamToNamed('/home',data: {'index':0});
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Column(
          children: [
            SizedBox(height: 30,),
            Text(
              'New In',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 5,),
            Text(
              '새로 추가된 상품',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: context.currentBeamLocation.state.data['result'].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (0.7),
                  ),
                  itemBuilder: (BuildContext ctx, index){
                    return GestureDetector(
                      onTap: ()=>{
                        handleProduct(context.currentBeamLocation.state.data['result'][index]['productId']),
                      },
                      child: Padding(
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
                                              image: NetworkImage(context.currentBeamLocation.state.data['result'][index]['imageUrl'])
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
                                      context.currentBeamLocation.state.data['result'][index]['brandName'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize:12
                                      ),
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: proHeight(7)),
                                    Text(
                                      context.currentBeamLocation.state.data['result'][index]['productName'],
                                      style: TextStyle(color: Colors.black, fontSize: 12),
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: proHeight(7)),
                                    Text(
                                      "Rent ${context.currentBeamLocation.state.data['result'][index]['defaultPrice']}원~",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 14,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}