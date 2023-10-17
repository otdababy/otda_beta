import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/src/beamer.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../api/review/delete_review_api.dart';
import '../../utils/user_secure_storage.dart';



class SpecificReviewPage extends StatefulWidget {
  const SpecificReviewPage({Key? key,
  }) : super(key: key);

  @override
  _SpecificReviewPageState createState() => _SpecificReviewPageState();
}


class _SpecificReviewPageState extends State<SpecificReviewPage> {

  void delete() async {
    try{
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      // IFF not null,
      try {
        print(jwt);
        print(userId);
        print(context.currentBeamLocation.state.data['reviewId']);
        var a = await DeleteReviewApi.deleteReview(jwt,userId,context.currentBeamLocation.state.data['reviewId']);
        final body = json.decode(a.body.toString());
        print(body);
        final result = body['result'];
        if(body['isSuccess']) {
          print("성공함 리뷰 지우기");
          //리뷰 지우고 마이페이지로 이동
          context.beamToNamed('/home', data: {'index' : 3 });
        }
        else{
        }
        if(!mounted) return;
      }
      catch(e){
        print(e);
        print("게시글 삭제 실패");
      }
    }catch(e){
      print(e);
      print("글삭제 실패");
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
            title: Text(
              '내가 쓴 리뷰',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20
              ),
            ),
            leading: IconButton(
              onPressed: (){
                if(context.currentBeamLocation.state.data['isNew'] != null)
                  context.beamToNamed('/home',data: {'index':3});
                else
                  Beamer.of(context).beamBack();
              },
              icon: Icon(Icons.west_outlined),
            ),
            actions: [
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
                          Text('이 리뷰를 삭제하시겠습니까?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
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
                                delete();
                              },
                              child: Text('삭제하기',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
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
              },icon: Icon(Icons.delete_outline_rounded),),
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: proHeight(10),),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: [
                          ...List.generate(
                              context.currentBeamLocation.state.data['result'][0]['images'].length,
                                  (index) => Padding(
                                    padding: EdgeInsets.all(proHeight(10.0)),
                                    child: Container(
                                      width: proWidth(250),
                                      height: proWidth(250),
                                      child: Image.network(
                                              context.currentBeamLocation.state.data['result'][0]['images'][index]['imageUrl'],
                                            fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                          ),
                        ]
                    ),
                  ),
                ),
                SizedBox(height: proHeight(10),),
                Center(
                  child: Text(
                    context.currentBeamLocation.state.data['result'][0]['productName'],
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                ),
                SizedBox(height: proHeight(10),),
                Center(
                  child: RatingBarIndicator(
                    rating: context.currentBeamLocation.state.data['result'][0]['score'].toDouble(),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.black,
                    ),
                    itemCount: 5,
                    itemSize: proHeight(50),
                    direction: Axis.horizontal,
                  ),

                ),
                SizedBox(height: proHeight(15),),
                Center(
                  child:
                      Text(
                        '${context.currentBeamLocation.state.data['result'][0]['text']}',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                  ),
                SizedBox(height: proHeight(10),),
              ],
            ),
          )
      ),
    );
  }
}