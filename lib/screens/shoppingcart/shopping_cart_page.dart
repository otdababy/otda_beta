import 'dart:convert';

import 'package:app_v2/classes/product/product.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:app_v2/utils/size_config.dart';

import '../../api/product_page_api.dart';
import '../../api/shopping_cart/date_change_api.dart';
import '../../api/shopping_cart/shoppingcart_delete_api.dart';
import '../../utils/user_secure_storage.dart';

class ShoppingCartPage extends StatefulWidget {

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}



class _ShoppingCartPageState extends State<ShoppingCartPage> {

  @override
  void initState(){ 
    super.initState();
  }

  //states update
  List<dynamic> _result = [];
  List<bool> _checkedItems= [];
  //체크누른 상품 수
  List<bool> _pay = [];

  void didChangeDependencies(){
    setState((){
        _result = context.currentBeamLocation.state.data['result'];
        _checkedItems = context.currentBeamLocation.state.data['checkedItems'];
    });
  }

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
        //print(product.reviews[0]['images'][0]['reviewImageId']);

        //product를 navigator을 통해 clothing page로 넘긴다
        context.beamToNamed('/clothing_page', data: {'product': product});
      }
    }
    catch(e) {
      print('실패함');
      print(e.toString());
    }
  }

  void deleteProduct(int keepId) async {
    //삭제하고싶냐고 팝업 띄움
    //PATCH request
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 패치실행
      try{
        var a = await ShoppingCartPatchApi.patchShoppingCart(keepId, userId, jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //지우는거 성공함 -> 화면 리로드
          setState((){
            _result.removeWhere((item)=> item['keepId'] == keepId);
          });
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

  void changeDate(int rentalDuration, int keepId) async {
    //PATCH request
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 패치실행
      try{
        var a = await DateChangePatchApi.patchDateChange(keepId, userId, jwt,rentalDuration);
        final body = json.decode(a.body.toString());
        //result from PATCH
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
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

  void handlePayment () async {
    List<dynamic> payItems = [];
    for(int i=0; i<_result.length; i++){
      if(_checkedItems[i]){
        payItems.add(_result[i]);
      }
    }
    if(payItems.length == 0){
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
              title: Padding(
                padding: EdgeInsets.only(top: proHeight(25.0)),
                child: Center(
                  child: Text('결제할 상품을\n선택해주세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: proWidth(20),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  width: proWidth(80),
                  //height: proHeight(30),
                  child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(15)),)
                  ),
                )
              ],
            );
          }
      );
    }
    else
      context.beamToNamed('/payment',data: {'result' : payItems});
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        return Future(() => false); //뒤로가기 막음
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('장바구니',style: TextStyle(fontWeight: FontWeight.w800),),
            leading: IconButton(
              onPressed: (){
                context.beamToNamed('/home',data: {'index' : 0});
              },
              icon: Icon(Icons.west_outlined),
            ),
          ),
          bottomSheet: Padding(
            padding: EdgeInsets.symmetric(vertical: proHeight(20), horizontal: proWidth(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "총 ${_pay.length}개의 상품",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  width: proWidth(180),
                  height: proHeight(50),
                  child: TextButton(
                      onPressed: (){
                        handlePayment();
                      },
                      child: Text(
                        '결제하기',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        backgroundColor: Colors.black,
                      )
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(0,proHeight(10),proWidth(20),proHeight(20)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...List.generate(
                      _result.length,
                          (index) => Padding(
                        padding: EdgeInsets.fromLTRB(0, proHeight(10), 0, proHeight(10)),
                        child: Container(
                          decoration: BoxDecoration(
                            //border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  StatefulBuilder(
                                    builder: (context, _setState) => Checkbox(
                                      value: _checkedItems[index],
                                      onChanged: (value) {
                                        if(_result[index]['rentAvailable']!=0){
                                          _setState(() {
                                            _checkedItems[index] = value!;
                                          });
                                          setState((){
                                            if(value!)
                                              _pay.add(true);
                                            else
                                              _pay.remove(true);
                                          });
                                        }
                                        else{
                                          null;
                                        }
                                      },
                                      //tristate: i == 1,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: ()=>{
                                      handleProduct(_result[index]['productId']),
                                    },
                                    child: Container(
                                      width: proWidth(140),
                                      height: proWidth(140),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          //정사각형 아니더라도 빈공간 없이 차도록
                                            fit: BoxFit.cover,
                                            image: NetworkImage(_result[index]['headimageUrl'])
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: proWidth(10),),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_result[index]['brandName']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: proWidth(15)
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          '${_result[index]['productName']}',
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: proWidth(15)
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          (_result[index]['mappingSize'] == '0') ?
                                          '${_result[index]['size']}' : '${_result[index]['size']} (${_result[index]['mappingSize']})',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: proWidth(15)
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        //Widget for selecting date
                                        Container(
                                          height: proHeight(35),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                width: 1,
                                                color: const Color(0xffE7E7E7),
                                              ),
                                              borderRadius: BorderRadius.circular(5)),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if(_result[index]['rentalDuration'] > 3) {
                                                      _result[index]['rentalDuration'] -= 1;
                                                    }
                                                  });
                                                  //장바구니 날짜변환 API 요청
                                                  changeDate(_result[index]['rentalDuration'], _result[index]['keepId']);
                                                },
                                              ),
                                              Center(child: Text((_result[index]['rentalDuration']-3).toString(), style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: proWidth(15)
                                              ),)),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  setState(() {
                                                    _result[index]['rentalDuration'] += 1;
                                                  },);
                                                  //장바구니 날짜변환 API 요청
                                                  changeDate(_result[index]['rentalDuration'], _result[index]['keepId']);
                                                },
                                              ),
                                            ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Padding(
                                              padding: const EdgeInsets.only(top: 20),
                                              child: Image.asset('assets/images/warning.png',
                                                height: proHeight(100),
                                                width: proHeight(100),
                                              ),
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text('이 상품을 삭제하시겠습니까?',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: proWidth(20),
                                                    ) ,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    OutlinedButton(
                                                      style: OutlinedButton.styleFrom(
                                                        shape: StadiumBorder(),
                                                        backgroundColor: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        deleteProduct(_result[index]['keepId']);
                                                      },
                                                      child: Text('삭제하기',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black,
                                                          fontSize: proWidth(12)
                                                        ),
                                                      ),
                                                    ),
                                                    OutlinedButton(
                                                      style: OutlinedButton.styleFrom(
                                                        shape: StadiumBorder(),
                                                        backgroundColor: Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('취소',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
                                                            fontSize: proWidth(12)
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          );
                                        }
                                        );
                                      }, icon: Icon(Icons.delete)),
                                    ],
                                  )
                                ],
                              ),
                              Container(height: proHeight(10),),
                              Row(
                                children: [
                                  Expanded(child: Container()),
                                  (_result[index]['rentAvailable'] != 0) ?
                                  Row(
                                    children: [
                                      Text(
                                        '${_result[index]['rentalDuration']}일',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: proWidth(16),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        ' 대여',
                                        style: TextStyle(
                                            fontSize: proWidth(16),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(width: proWidth(15),),
                                      Text(
                                        '${_result[index]['defaultPrice'] + _result[index]['optionPrice']*(_result[index]['rentalDuration']-3)}원',
                                        style: TextStyle(
                                            fontSize: proWidth(16),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ) : Text("SOLD OUT", style: TextStyle(
                                      fontSize: proWidth(18),
                                      fontWeight: FontWeight.bold,
                                  ),),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(height: proHeight(70),),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
