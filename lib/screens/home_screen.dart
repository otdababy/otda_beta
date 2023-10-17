import 'dart:convert';

import 'package:app_v2/api/notification/new_notification_api.dart';
import 'package:app_v2/screens/community/community_page.dart';
import 'package:app_v2/screens/community/components/article/write_article_page.dart';
import 'package:app_v2/screens/login/login_page.dart';
import 'package:app_v2/screens/login/signup_body.dart';
import 'package:app_v2/screens/payment/receipt_page.dart';
import 'package:app_v2/screens/profile/closet_body.dart';
import 'package:app_v2/screens/profile/coupon/coupon_page.dart';
import 'package:app_v2/screens/profile/profile_edit_page.dart';
import 'package:app_v2/screens/reviews/review_write_page.dart';
import 'package:app_v2/screens/search/components/item.dart';
import 'package:app_v2/screens/search/search_screen.dart';
import 'package:app_v2/screens/shoppingcart/shopping_cart_page.dart';
import 'package:app_v2/states/user_provider.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_v2/screens/home/items_page.dart';
import 'package:app_v2/screens/login/login_page.dart';
import 'package:app_v2/screens/profile/closet_page.dart';
import 'package:app_v2/screens/payment/payment_page.dart';
import 'package:app_v2/screens/clothing/clothing_page.dart';
import 'package:app_v2/widget/expandablefab.dart';
import 'package:extended_image/extended_image.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:app_v2/screens/home/items_page.dart';
import '../api/home/category_products_api.dart';
import '../api/notification/notice_look_api.dart';
import '../api/notification/notification_page_api.dart';
import '../api/shopping_cart/shoppingcart_api.dart';
import '../utils/user_secure_storage.dart';
import 'community/community_body.dart';
import 'shoppingcart/shopping_cart_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  int _bottomSelectedIndex = 0;
  Widget noti = Icon(Icons.notifications_none_outlined);

  void initState(){
    newNoti();
    super.initState();
  }

  void newNoti() async {
      try {
        String? userId = await UserSecureStorage.getUserId();
        String? jwt = await UserSecureStorage.getJwt();
        try{
          //게시글들 조회 API
          var a = await NewNotificationApi.getNewNoti(jwt,userId);
          final body = json.decode(a.body.toString());
          //result from GET
          final result = body['result'];
          //Get 성공
          if(body['isSuccess']){
            // 새로운 알람이 있는지 확인
            if(result[0]['isNew']){
              setState((){
                noti = Image.asset('assets/images/noti_on.png',width: 22,height: 22,);
              });
            }
            else{
              noti = Image.asset('assets/images/noti_off.png',width: 22,height: 22,);
            }
          }
        }
        catch(e) {
          print(e.toString());
        }
      }catch(e){
        print(e);
      }
  }

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

  Future<void> handleNotification() async {
    //유저아이디와 jwt를 받아온다
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온
      try{
        var a = await NotificationGetApi.getNotification(jwt, userId);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //쇼핑카트 정보 받아온걸 넘겨주고 띄움
          context.beamToNamed('/notification', data: {'result' : result});
        }
      }catch(e){
        print(e);
        print('실패함 노티피케이션 조회');
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async { return false; },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actionsIconTheme: IconThemeData(
              size: 30,
            ),
            centerTitle: true,
            title: Image.asset(
              'assets/images/wordmark_black.jpg',
              height: proHeight(22),
            ),
            leading:
                IconButton(
                  onPressed: (){
                    handleNotification();
                  },
                  icon: noti,
                ),


            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: IconButton(
                      onPressed: (){
                        handleShoppingCart();
                      },
                      icon: Image.asset('assets/images/appbar_cart.png', width: 22, height: 22,),
                  ),

              )
            ],
          ),
          body: IndexedStack(
            index: _bottomSelectedIndex,
            /*GridView.count
            crossAxisCount: 2,
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6.0,*/
            children: [
              ItemsPage(),
              SearchPage(),
              CommunityPage(),
              ClosetPage(),

            ],
          ),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomSelectedIndex,
            onTap: (index){
              setState(() {
                _bottomSelectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: SizedBox(
                    height: proHeight(28),
                  width: proWidth(28),
                  child: Image.asset('assets/images/bottomnavi_home.png')),
                  label: '홈',
                  activeIcon: SizedBox(
                    width: proWidth(28),
                      height: proHeight(28),
                      child: Image.asset('assets/images/bottomnavi_home.png'))),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      height: proHeight(25),
                      width: proWidth(25),
                      child: Image.asset('assets/images/bottomnavi_search.png')),
                  label: '검색',
                  activeIcon: SizedBox(
                      width: proWidth(25),
                      height: proHeight(25),
                      child: Image.asset('assets/images/bottomnavi_search.png'))),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      height: proHeight(25),
                      width: proWidth(25),
                      child: Image.asset('assets/images/bottomnavi_community.png')),
                  label: '커뮤니티',
                  activeIcon: SizedBox(
                      width: proWidth(25),
                      height: proHeight(25),
                      child: Image.asset('assets/images/bottomnavi_community.png'))),
              BottomNavigationBarItem(
                  icon: SizedBox(
                      height: proHeight(25),
                      width: proWidth(25),
                      child: Image.asset('assets/images/bottomnavi_profile.png')),
                  label: '프로필',
                  activeIcon: SizedBox(
                      width: proWidth(25),
                      height: proHeight(25),
                      child: Image.asset('assets/images/bottomnavi_profile.png'))),



            ],
          ),
        ),
      ),
    );
  }
}
/*onPressed: (){
context.read<UserProvider>().SetUserAuth(false);
},
icon: Icon(Icons.logout), -> 로그아웃할때 실행하는 함수*/