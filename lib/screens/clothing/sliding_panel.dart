import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/router/location.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:app_v2/api/shopping_cart/add_cart_api.dart';

import '../../api/shopping_cart/shoppingcart_api.dart';
import '../../classes/product/product.dart';
import '../../utils/user_secure_storage.dart';
import '../../widget/progress_bar.dart';

class SlidingPanel extends StatefulWidget {
  final Product product;
  SlidingPanel(this.product);
  @override
  _SlidingPanelState createState() => _SlidingPanelState(product);
}
class _SlidingPanelState extends State<SlidingPanel> {
  final Product product;
  _SlidingPanelState(this.product);

  String? selectedItem = null;
  int rentalDuration = 3;
  int option = 0;
  int _count = 0;
  int _date = 3;



  Future<void> handleShoppingCart() async {
    //유저아이디와 jwt를 받아온다
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try{
        var a = await ShoppingCartGetApi.getShoppingCart(userId, jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //쇼핑카트 정보 받아온걸 넘겨주고 띄움
          List<bool> checkedItems = List.filled(result.length, false);
          context.beamToNamed('/shopping_cart', data: {'result' : result, 'checkedItems': checkedItems});
        }
      }catch(e){
        print(e);
        print('실패함 홈');
      }
    }catch(e){
      print(e);
    }
  }

  List<String> availableSize(Product product){
    List<String> items = [];
    List<dynamic> instances = product.availableInstance;
    for(int i=0;i<instances.length;i++){
      if(instances[i]['rentalAvailable'] != 0){
        if(!items.contains(instances[i]['size'])){
          if(instances[i]['mappingSize'] == "0")
            items.add(instances[i]['size']);
          else
            items.add(instances[i]['size'] + " (${instances[i]['mappingSize']})");
        }
      }
    }
    return items;
  }

  //고른 size의 instance id를 리턴한다
  int rentInstance(String size){
    List<String> size1 = size.split(' ');
    int instanceId = 0;
    List<dynamic> instances = product.availableInstance;
    for(int i=0;i<instances.length;i++){
      if(instances[i]['size'] == size1[0]){
        instanceId = instances[i]['instanceId'];
        }
      }
    return instanceId;
  }

  void handleAddCart(int productId, int instanceId, int rentalDuration) async{
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try{
        var a= await AddCartApi.postAddCart(
            AddCartPost(
                userId: userId,
                productId: productId,
                instanceId: instanceId,
                rentalDuration: rentalDuration
            ),
            jwt
        );
        final body = json.decode(a.body.toString());
        print(body);
        if(body['isSuccess']) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset('assets/images/쇼핑카트.png',
                      height: proHeight(100),
                      width: proHeight(100),
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('장바구니에 담았습니다!',
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
                      padding: EdgeInsets.symmetric(vertical: proHeight(5),horizontal: proWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('계속 구경하기',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: proWidth(15),
                              ),
                            ),
                          ),
                          SizedBox(width: proWidth(10),),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              handleShoppingCart();
                            },
                            child: Text('장바구니 확인하기',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: proWidth(15),
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
        }else{
          print("실패함");
        }
      }
      catch(e){
        print(e);
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(proWidth(30),0,proWidth(30),0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: proHeight(5)),
          Row(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    height: 2,
                    width: proWidth(100),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: proHeight(10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사이즈',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: proHeight(10)),
              SizedBox(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonFormField<String>(
                    hint: Text('   사이즈를 선택해주세요', style: TextStyle(color: Color(0xffB4B4B4),fontWeight: FontWeight.w400,fontSize: 16),) ,
                    decoration: InputDecoration(border: InputBorder.none),
                    value: selectedItem,
                    items:
                    availableSize(product).map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text('   $item',style: TextStyle(fontSize: proWidth(20)),)
                    )).toList(),
                    onChanged: (item) => setState(() => selectedItem=item),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: proHeight(20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '대여일',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: proHeight(5),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${_date}일 ',
                        style: TextStyle(
                            color: Color(0xff15CD5D),
                            fontSize: proWidth(22),
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        '대여',
                        style: TextStyle(
                            fontSize: proWidth(22),
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                  // 대여일 수 정하기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: proWidth(50),),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffE7E7E7),
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if(_count > 0) {
                                  _count -= 1;
                                  _date -= 1;
                                }
                              });
                            },
                          ),
                          SizedBox(
                            height: proHeight(30),
                            width: proWidth(30),
                          ),
                          Text(_count.toString()),
                          SizedBox(
                            height: proHeight(30),
                            width: proWidth(30),
                          ),

                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _count += 1;
                                _date += 1;
                              });
                            },
                          ),
                        ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                '${product.defaultPrice+_count*(product.optionPrice)}원',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: proWidth(170),
                height: proHeight(45),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    side: BorderSide(width: 1, color: Colors.black),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if(selectedItem == null){
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
                                  child: Text('사이즈를 선택해주세요!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: proWidth(24),
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ),
                              actions: [
                                Container(
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                        backgroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('확인', style: TextStyle(fontWeight: FontWeight.w700,fontSize: proWidth(20)),)
                                  ),
                                )
                              ],
                            );
                          }
                      );
                    }
                    handleAddCart(product.id, rentInstance(selectedItem!), 3+_count);
                  },
                  child: Text(
                    '장바구니 담기',
                    style: TextStyle(
                        fontSize: proWidth(18),
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(width: proWidth(20)),
              Container(
                width: proWidth(170),
                height: proHeight(45),
                child: TextButton(
                    onPressed: () async {
                      if(selectedItem == null){
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
                                child: Text('사이즈를 선택해주세요!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: proWidth(24),
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              Container(
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                      backgroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child:Text('확인',  style: TextStyle(fontWeight: FontWeight.w700, fontSize: proWidth(20)),)
                                ),
                              )
                            ],
                          );
                        }
                      );
                      }
                      else{
                        context.beamToNamed('/payment',data: {'result' : [{'productName': product.productName, 'brandName':product.brandName
                        ,'size': selectedItem!, 'rentalDuration': 3+_count, 'defaultPrice' : product.defaultPrice, 'optionPrice' :
                        product.optionPrice, 'headimageUrl' : product.images[0]['imageUrl'],'instanceId' : rentInstance(selectedItem!)}]});
                      }
                    },
                    child: Text(
                      '결제하기',
                      style: TextStyle(fontSize: proWidth(18), fontWeight: FontWeight.w700,
                          color: Colors.white )
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(15))),
                      backgroundColor: Colors.black,
                    )
                ),
              )
            ],
          ),
          SizedBox(height: proHeight(20)),
        ],
      ),
    );
  }

}