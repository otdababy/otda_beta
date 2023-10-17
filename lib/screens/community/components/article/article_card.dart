import 'dart:convert';
import 'package:app_v2/api/product_page_api.dart';
import 'package:app_v2/screens/clothing/clothing_page.dart';
import 'package:app_v2/utils/size_config.dart';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_v2/classes/product/product.dart';

import '../../../../api/community/specific_article_api.dart';
import '../../../../utils/user_secure_storage.dart';

class ArticleCard extends StatefulWidget {
  const ArticleCard({
    Key? key,
    required this.boardId,
    required this.nickName,
    required this.profileImageUrl,
    required this.text,
    required this.likeCount,
    required this.commentCount,
    required this.headImageUrl,
  }) : super(key: key);

  final int boardId;
  final String nickName;
  final String profileImageUrl;
  final String text;
  final int likeCount;
  final int commentCount;
  final String headImageUrl;


  @override
  _ArticleCardState createState() => _ArticleCardState(boardId: boardId, nickName: nickName, headImageUrl: headImageUrl,
      text: text, commentCount: commentCount, profileImageUrl: profileImageUrl, likeCount: likeCount);
}

class _ArticleCardState extends State<ArticleCard> {
  _ArticleCardState({
    Key? key,
    required this.boardId,
    required this.nickName,
    required this.profileImageUrl,
    required this.text,
    required this.likeCount,
    required this.commentCount,
    required this.headImageUrl,
  }); //: super(key: key);

  final int boardId;
  final String nickName;
  final String profileImageUrl;
  final String text;
  final int likeCount;
  final int commentCount;
  final String headImageUrl;


  void handleArticle(int id) async {
    //GET request
    print(id);
    try {
      String? userId = await UserSecureStorage.getUserId();
      String? jwt = await UserSecureStorage.getJwt();
      try{
        var a = await ArticleGetApi.getArticle(id, int.parse(userId!), jwt);
        final body = json.decode(a.body.toString());
        //result from GET
        final result = body['result'];
        print(result);
        print("이게 받아온 정보임");
        //Get 성공
        if(body['isSuccess']){
          //서버에서 board info 따와서 설정 후 화면 로드
          //빔으로 아티클 페이지로 넘김
          print("넘어가기 직전잉");
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{
        handleArticle(boardId),
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(proWidth(20), 0, proWidth(20), 0),
        child: Row(
            children: [
              //사진
              Container(
                width: proWidth(80),
                height: proWidth(80),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      //정사각형 아니더라도 빈공간 없이 차도록
                        fit: BoxFit.cover,
                        image: NetworkImage(headImageUrl)
                    ),
                    borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(width: proWidth(20),),
              //
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 5,),
                  //해쉬태그
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: proWidth(10),
                            height: proHeight(10),
                            child: CircleAvatar(
                              child: Image.network(profileImageUrl),
                            ),
                          ),
                          SizedBox(width: proWidth(5),),
                          Text(
                            nickName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      //라이크랑 커멘트
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 15,
                          ),
                          SizedBox(width: proWidth(5),),
                          Text(
                            likeCount.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: proWidth(10),),
                          Icon(
                            Icons.favorite,
                            size: 15,
                          ),
                          SizedBox(width: proWidth(5),),
                          Text(
                            commentCount.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
      )
    );
  }
}
