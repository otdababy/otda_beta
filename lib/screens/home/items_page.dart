import 'dart:convert';
import 'package:app_v2/screens/home/components/homenoti/homebottom.dart';
import 'package:app_v2/screens/home/components/homenoti/homenoti_1.dart';
import 'package:app_v2/screens/home/components/homenoti/homenoti_2.dart';
import 'package:app_v2/screens/home/components/homenoti/homenoti_3.dart';
import 'package:app_v2/screens/home/components/brief_categories/newin.dart';
import 'package:app_v2/screens/home/components/brief_categories/trending.dart';
import 'package:app_v2/widget/bannerslider.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/api/home/category_products_api.dart';

import '../../utils/size_config.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}
class _ItemsPageState extends State<ItemsPage> {
  //_ItemsPageState({Key? key});// : super(key: key);
  //static late double screenWidth;


  @override
  Widget build(BuildContext context) {
    //screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      //return value: list of length 2 -> results from category 19,20
        future: handleCategoryProduct(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if( snapshot.connectionState == ConnectionState.waiting){
          return Center(child: Text(''));
        }else{
          if (snapshot.hasError)
            return Center(child: Text(''));
          else //snapshot.data
            return SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Stack(
                      children: const [
                        BannerSlider(),
                      ],
                    ),
                    SizedBox(height: proHeight(20),),
                    Newin(snapshot.data[0]),
                    Trending(snapshot.data[1]),
                    HomeNoti3(),
                    SizedBox(height: proHeight(40)),
                    HomeBottom(),
                    SizedBox(height: proHeight(10)),
                  ],
                ),
              ),
            );  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      }
    );
  }
  Future<dynamic> handleCategoryProduct() async{
    List<dynamic> categories = [];
    try{
      var a = await CategoryProductGetApi.getCategoryProduct(58);
      final body = json.decode(a.body.toString());
      //result from GET
      final result = body['result'];
      //Get 성공
      if(body['isSuccess']){
        categories.add(result);
      }
    }
    catch(e) {
      print('실패함 카테고리 조회 뉴인');
      print(e.toString());
    }
    try{
      var a = await CategoryProductGetApi.getCategoryProduct(59);
      final body = json.decode(a.body.toString());
      //result from GET
      final result = body['result'];
      //Get 성공
      if(body['isSuccess']){
        categories.add(result);
        return categories;
      }
    }
    catch(e) {
      print('실패함 카테고리조회 트렌딩');
      print(e.toString());
    }
  }
}