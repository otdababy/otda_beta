import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import '../../api/notification/notice_look_api.dart';
import '../../utils/user_secure_storage.dart';
import 'notification_body.dart';

class NotificationPage extends StatefulWidget {

  @override
  _NotificationPageState createState() => _NotificationPageState();
}



class _NotificationPageState extends State<NotificationPage> {

  @override
  void initState(){
    lookNoti();
    super.initState();
  }

  void lookNoti() async{
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        var a = await NotificationLookApi.lookNotification(jwt, userId);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //쇼핑카트 정보 받아온걸 넘겨주고 띄움
          print("노티 봤다");
        }
      }catch(e){
        print(e);
        print('실패함 노티피케이션 봤다');
      }
    }catch(e){
      print(e);
    }
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
              title: Text("알림"),
              leading: IconButton(
                onPressed: (){
                  context.beamToNamed('/home',data: {'index' : 0});
                },
                icon: Icon(Icons.west_outlined),
              ),
            ),
            body: NotificationBody(context.currentBeamLocation.state.data['result'])
        ),
      ),
    );
  }
}
