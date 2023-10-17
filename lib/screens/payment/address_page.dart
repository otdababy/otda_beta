import 'dart:convert';

import 'package:app_v2/classes/product/product.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:app_v2/utils/size_config.dart';

import '../../api/payment/add_address_api.dart';
import '../../api/payment/address_page_api.dart';
import '../../api/payment/delete_address_api.dart';
import '../../utils/user_secure_storage.dart';

class AddressPage extends StatefulWidget {

  @override
  _AddressPageState createState() => _AddressPageState();
}


class _AddressPageState extends State<AddressPage> {

  @override
  void initState(){
    print("이닛스테이트 시작함");
    super.initState();
  }

  //states update
  List<dynamic> _address = [];

  void didChangeDependencies(){
    getAddress();
  }

  void getAddress() async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await AddressGetApi.getAddress(userId, jwt);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if (body['isSuccess']) {
          _address = result[0]['address'];
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print(e);
    }
  }

  void addAddress(String name, String address, String phoneNumber, String requestText, int isDefault) async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await AddressPostApi.postAddress(userId, jwt, name, address, phoneNumber, requestText, isDefault);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if (body['isSuccess']) {
          //추가된 주소 업데이트
          setState((){
            getAddress();
          });
        }
      }catch(e){
        print(e);
      }
    }catch(e){
      print(e);
    }
  }

  void deleteAddress(int addressId) async {
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try {
        var a = await AddressDeleteApi.deleteAddress(userId, jwt, addressId);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if (body['isSuccess']) {
          //삭제된 주소록 업데이트
          setState((){
            getAddress();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('배송지 목록',style: TextStyle(fontWeight: FontWeight.w800),),
        leading: IconButton(
          onPressed: (){},
          icon: Icon(Icons.west_outlined),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: proHeight(20), horizontal: proWidth(20)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...List.generate(
                  _address.length,
                      (index) => Padding(
                    padding: EdgeInsets.fromLTRB(0, proHeight(20), 0, proHeight(50)),
                    child: GestureDetector(
                      onTap: ()=>{
                        //배송지 선택된 상태로 이동
                      },
                      child: Container(
                        height: proHeight(180),
                        decoration: BoxDecoration(
                          //border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: proWidth(30),
                                ),
                                Text(
                                    '배송지 정보',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13
                                    )
                                ),
                                Container(
                                  height: proHeight(22),
                                  width: proWidth(50),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(width: 1, color: Colors.black),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: (){
                                      //addAddress();
                                    },
                                    child: Center(
                                      child: Text(
                                        '수정',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: proHeight(22),
                                  width: proWidth(50),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(width: 1, color: Colors.black),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(proWidth(20))),
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: (){
                                      deleteAddress(_address[index]['addressId']);
                                    },
                                    child: Center(
                                      child: Text(
                                        '삭제',
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: proHeight(10)),
                            Row(
                                children : [
                                  SizedBox(width: proWidth(18)),
                                  Container(
                                    width: proWidth(460),
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                ]
                            ),
                            SizedBox(height: proHeight(10)),
                            Row(
                                children: [
                                  SizedBox(width: proWidth(30)),
                                  Text(
                                    _address[index]['name'],
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(height: proHeight(4)),
                            Row(
                                children: [
                                  SizedBox(width: proWidth(30)),
                                  Text(
                                    _address[index]['phoneNumber'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(height: proHeight(4)),
                            Row(
                                children: [
                                  SizedBox(width: proWidth(30)),
                                  Text(
                                    _address[index]['address'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(height: proHeight(15)),
                            Row(
                                children: [
                                  SizedBox(width: proWidth(25)),
                                  Container(
                                    width: proWidth(440),
                                    height: proHeight(30),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: " 배송메모를 남겨주세요",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: proHeight(12)
                                        ),
                                        fillColor: Colors.grey.shade200,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            SizedBox(
                              height: proHeight(15),
                            ),
                            Container(
                              height: 6,
                              width: proWidth(500),
                              color: Colors.grey.shade200,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
