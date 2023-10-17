import 'dart:convert';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/utils/size_config.dart';
import '../../api/community/specific_article_api.dart';
import '../../api/notification/delete_notification_api.dart';
import '../../api/profile_page/borrowing_api.dart';
import '../../api/profile_page/profile_page/delivering_api.dart';
import '../../api/profile_page/profile_page/returned_api.dart';
import '../../utils/user_secure_storage.dart';

class NotificationBody extends StatefulWidget {
  List<dynamic> result;
  NotificationBody(this.result);

  @override
  _NotificationState createState() => _NotificationState(result);
}

class _NotificationState extends State<NotificationBody> {
  List<dynamic> _result;
  _NotificationState(this._result);


  void handleBorrowing() async {
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      //받아온 유저 아이디로 대여중, 배송중, 반납 완료 정보 받아옴
      try{
        var a = await BorrowingGetApi.getBorrowing(userId, jwt);
        final body1 = json.decode(a.body.toString());
        //result from GET
        final borrowing = body1['result'];
        //Get 성공
        if(body1['isSuccess']){
          //바로잉은 성공했으니 이제 배송중 정보 받아옴
          try{
            var b = await DeliveringGetApi.getDelivering(userId, jwt);
            final body2 = json.decode(b.body.toString());
            //result from GET
            final delivering = body2['result'];
            //딜리버링 성공
            if(body2['isSuccess']){
              try{
                var c = await ReturningGetApi.getReturning(userId, jwt);
                final body3 = json.decode(c.body.toString());
                //result from GET
                final returning = body3['result'];
                //리터닝 성공
                if(body3['isSuccess']){
                  //세개 다 성공함, 이제 페이지 옮기고 정보 넘기면됌
                  context.beamToNamed('borrowing',data:{'borrowing':borrowing,
                    'delivering':delivering, 'returning':returning});
                }
              }catch(e){
                print(e);
              }
            }
          }catch(e){
            print(e);
          }
        }
        else{
          print("대여중 실패");
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

  void handleArticle(int id) async {
    //GET request
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        var a = await ArticleGetApi.getArticle(id, int.parse(userId!), jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        //Get 성공
        if(body['isSuccess']){
          //서버에서 board info 따와서 설정 후 화면 로드
          //빔으로 아티클 페이지로 넘김d
          context.beamToNamed('/article_page', data: {'result': result});
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

  void deleteNotification(int noticeId) async{
    try{
      //PATCH request
      try{
        String? userId = await UserSecureStorage.getUserId();
        String? jwt = await UserSecureStorage.getJwt();
        //받아온 유저 아이디로 패치실행
        try{
          var a = await NotificationDeleteApi.deleteNotification(jwt, userId, noticeId);
          final body = json.decode(a.body.toString());
          //result from GET
          final result = body['result'];
          //Get 성공
          if(body['isSuccess']){
            //지우는거 성공함 -> 화면 리로드
            setState((){
              _result.removeWhere((item)=> item['noticeId'] == noticeId);
              //이게있어도 왜되는거지
              //_result = context.currentBeamLocation.state.data['cart'];
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
    }catch(e){
      print(e);
    }
  }

  Widget alarm = Icon(Icons.brightness_1_rounded);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: proHeight(20),),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: _result.length,
                itemBuilder: (context, index) {
                    final text = _result[index]['text'];
                    return Dismissible(key: UniqueKey(), child:
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: proHeight(8),),
                      child: Column(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: ((){
                                if(_result[index]['highCategory'] == 1 || _result[index]['highCategory'] == 2)
                                  handleBorrowing();
                                else if(_result[index]['highCategory'] == 3 || _result[index]['highCategory'] == 4)
                                  handleArticle(_result[index]['subId']);
                              }),
                              child: Container(
                                  child: ListTile(
                                    leading: Icon(Icons.brightness_1_rounded, size: 15,),
                                    title: Text(_result[index]['text'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13
                                    )),
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: proHeight(12),),
                          Row(
                            children: [
                              Expanded(child: Container(height: 1,color: Colors.grey.shade300,))
                            ],
                          ),
                        ],
                      ),
                    ),
                      onDismissed: (direction){
                        setState(() {
                          deleteNotification(_result[index]['noticeId']);
                        });
                      },
                    );
                }),
          ),
        ],
      ),
    );
      
      
      
      /*
      Column(
      children: [
        Column(
          children: [
            SizedBox(height: proHeight(20),),
            ...List.generate(
              _result.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: proWidth(5), vertical: proHeight(10)),
                    child: Container(
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        children: [
                          Text(
                            _result[index]['text'],
                            style: TextStyle(
                              fontSize: 12,
                            ),
                            maxLines: 5,
                          ),
                          Expanded(child: Container()),
                          IconButton(onPressed: (){
                            deleteNotification(_result[index]['noticeId']);
                          }, icon: Icon(Icons.delete))
                        ],
                      ),
                    ),
                  )
            ),
          ],
        ),
      ],
    );*/
  }
}